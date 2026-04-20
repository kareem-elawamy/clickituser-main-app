import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_sixvalley_ecommerce/utill/app_constants.dart';
import 'package:flutter_sixvalley_ecommerce/di_container.dart' as di;
import 'package:flutter_sixvalley_ecommerce/data/datasource/remote/dio/dio_client.dart';
import 'package:flutter_sixvalley_ecommerce/utill/app_config.dart';

class GatewayService {
  static const String gatewayUrl = 'https://gateway.ussus.net/api/stores';

  // ── SharedPreferences cache keys ──────────────────────────────────────────
  static const String cacheKey           = 'gateway_stores_cache';
  static const String selectedCountryKey = 'selected_country_cache';
  static const String selectedLangKey    = 'selected_language_cache';
  /// Persists the brand that was active when the country was chosen.
  /// Used to bust the cache when the device switches to a different flavor.
  static const String selectedBrandKey   = 'selected_brand_cache';

  // ─────────────────────────────────────────────────────────────────────────
  /// Fetches the store list from the Central Gateway and caches it locally.
  /// Called once at app startup (inside GatewayWrapper) so subsequent calls
  /// to [setDynamicApiBaseUrl] work purely from cache without a network round-trip.
  // ─────────────────────────────────────────────────────────────────────────
  static Future<void> fetchAndCacheStores() async {
    try {
      final response = await http.get(Uri.parse(gatewayUrl));
      if (response.statusCode == 200) {
        final prefs = di.sl<SharedPreferences>();
        await prefs.setString(cacheKey, response.body);
      }
    } catch (_) {
      // Network failure — fall back to previously cached data silently.
    }
  }

  // ─────────────────────────────────────────────────────────────────────────
  /// Attempts to restore the API base URL from the previously cached country
  /// and language selections.
  ///
  /// **Brand guard**: if the cached brand does not match [AppConfig.currentBrand]
  /// (e.g. leftover cache from a Clickit or different flavor session), the
  /// stale cache is cleared and `false` is returned immediately, which causes
  /// [GatewayWrapper] to force the user to [StoreSelectionScreen].
  ///
  /// Returns `true` only when a valid, brand-matching store URL was restored.
  // ─────────────────────────────────────────────────────────────────────────
  static bool initFromCache() {
    final prefs = di.sl<SharedPreferences>();

    // ── Brand guard: reject any cache that belongs to a different flavor ───
    final String? cachedBrand = prefs.getString(selectedBrandKey);
    if (cachedBrand != AppConfig.currentBrand) {
      prefs.remove(selectedCountryKey);
      prefs.remove(selectedLangKey);
      prefs.remove(selectedBrandKey);
      return false;
    }

    final String? cachedCountry = prefs.getString(selectedCountryKey);
    final String? cachedLang    = prefs.getString(selectedLangKey);

    if (cachedCountry != null) {
      return setDynamicApiBaseUrl(
        cachedCountry,
        null,
        languageCode: cachedLang ?? 'ar',
        showError: false,
      );
    }
    return false;
  }

  // ─────────────────────────────────────────────────────────────────────────
  /// Core gateway resolver.
  ///
  /// Filters the cached store list by:
  ///   • [AppConfig.currentBrand]  — derived from `--dart-define=BRAND=...`
  ///                                 (never from any UI selector)
  ///   • [countryCode]             — user-selected country
  ///   • `is_active == 1`          — only live stores
  ///
  /// On success:
  ///   1. Updates [AppConstants.baseUrl]
  ///   2. Updates the global [DioClient] base URL
  ///   3. Persists [countryCode] and [languageCode] to SharedPreferences
  ///
  /// On failure (no matching active store):
  ///   • Shows an "Unavailable" [SnackBar] if [showError] is `true` and
  ///     [context] is provided.
  ///
  /// Returns `true` on success, `false` on failure.
  // ─────────────────────────────────────────────────────────────────────────
  static bool setDynamicApiBaseUrl(
    String countryCode,
    BuildContext? context, {
    String languageCode = 'ar',
    bool showError = true,
  }) {
    bool hasMatch = false;

    final prefs      = di.sl<SharedPreferences>();
    final cachedData = prefs.getString(cacheKey);

    if (cachedData != null) {
      try {
        final decoded = json.decode(cachedData);

        // Gateway may return a bare list or wrap it in a { "data": [...] } object.
        final List<dynamic> storeList =
            decoded is List ? decoded : (decoded['data'] as List? ?? []);

        // The brand to match against — always from the compile-time flavor constant.
        final String brandFilter = AppConfig.currentBrand.toLowerCase();

        for (final store in storeList) {
          final String storeBrand = store['brand'].toString().toLowerCase().trim();

          // ── Filtering rules ─────────────────────────────────────────────
          // 1. Store must be active
          // 2. Store brand must exactly match the compile-time flavor brand
          // 3. Country must match
          // 4. Explicitly exclude 'clickt' (out-of-scope) and 'ui mart'
          final bool isActive        = store['is_active'] == 1;
          final bool brandMatches    = storeBrand == brandFilter;
          final bool countryMatches  = store['country_code']
              .toString()
              .toLowerCase()
              .trim() == countryCode.toLowerCase().trim();
          final bool notExcluded     = storeBrand != 'clickt' &&
                                       storeBrand != 'ui mart';

          if (isActive && brandMatches && countryMatches && notExcluded) {
            final String extractedUrl = store['api_base_url'] as String;

            // ── Apply globally ─────────────────────────────────────────────
            AppConstants.baseUrl = extractedUrl;
            di.sl<DioClient>().updateBaseUrl(extractedUrl);

            // ── Persist selections ─────────────────────────────────────────
            prefs.setString(selectedCountryKey, countryCode);
            prefs.setString(selectedLangKey, languageCode);
            prefs.setString(selectedBrandKey, AppConfig.currentBrand);

            hasMatch = true;
            break;
          }
        }
      } catch (_) {
        // JSON parsing error — treat as no-match.
      }
    }

    if (!hasMatch && showError && context != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${AppConfig.appName} is not yet available in the selected country.\n'
            'Please try another region.',
          ),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          margin: const EdgeInsets.all(16),
          duration: const Duration(seconds: 4),
        ),
      );
    }

    return hasMatch;
  }

  // ─────────────────────────────────────────────────────────────────────────
  /// Clears the persisted country and language cache.
  /// Call this when the user wants to switch region (e.g. from Settings).
  // ─────────────────────────────────────────────────────────────────────────
  static Future<void> clearCache() async {
    final prefs = di.sl<SharedPreferences>();
    await prefs.remove(selectedCountryKey);
    await prefs.remove(selectedLangKey);
    await prefs.remove(selectedBrandKey);
  }
}

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_sixvalley_ecommerce/utill/app_constants.dart';
import 'package:flutter_sixvalley_ecommerce/di_container.dart' as di;
import 'package:flutter_sixvalley_ecommerce/data/datasource/remote/dio/dio_client.dart';

class GatewayService {
  static const String gatewayUrl = 'https://gateway.ussus.net/api/stores';
  static const String cacheKey = 'gateway_stores_cache';
  static const String selectedBrandKey = 'selected_brand_cache';
  static const String selectedCountryKey = 'selected_country_cache';

  /// Fetches the store configurations from the Gateway and caches them.
  /// To be called on app startup.
  static Future<void> fetchAndCacheStores() async {
    try {
      final response = await http.get(Uri.parse(gatewayUrl));
      if (response.statusCode == 200) {
        final prefs = di.sl<SharedPreferences>();
        await prefs.setString(cacheKey, response.body);
      }
    } catch (e) {
      // Ignored for now. Allow fallback to previously cached data if network fails.
    }
  }
  
  /// Attempts to initialize the API base URL from a previously cached brand/country.
  /// Returns true if successful, false otherwise.
  static bool initFromCache() {
    final prefs = di.sl<SharedPreferences>();
    String? cachedBrand = prefs.getString(selectedBrandKey);
    String? cachedCountry = prefs.getString(selectedCountryKey);
    
    if (cachedBrand != null && cachedCountry != null) {
       return setDynamicApiBaseUrl(cachedBrand, cachedCountry, null, showError: false);
    }
    return false;
  }

  /// Sets the dynamic Base URL based on selected brand and countryCode.
  /// Returns true if successful, false otherwise.
  /// If unsuccessful, it shows an "Unavailable" message to the user.
  static bool setDynamicApiBaseUrl(String brand, String countryCode, BuildContext? context, {bool showError = true}) {
    bool hasMatch = false;
    final prefs = di.sl<SharedPreferences>();
    final cachedData = prefs.getString(cacheKey);
    
    if (cachedData != null) {
      try {
        final decoded = json.decode(cachedData);
        // Gateway may return a direct list or an object with a 'data' list.
        List<dynamic> storeList = decoded is List ? decoded : (decoded['data'] as List? ?? []);

        for (var store in storeList) {
          String storeBrand = store['brand'].toString().toLowerCase();
          
          if (store['is_active'] == 1 &&
              storeBrand != 'clickt' &&
              storeBrand != 'ui mart' &&
              storeBrand == brand.toLowerCase() &&
              store['country_code'].toString().toLowerCase() == countryCode.toLowerCase()) {
                
            String extractedUrl = store['api_base_url'];
            AppConstants.baseUrl = extractedUrl;
            
            // Update DioClient globally
            di.sl<DioClient>().updateBaseUrl(extractedUrl);
            
            // Persist the choice
            prefs.setString(selectedBrandKey, brand);
            prefs.setString(selectedCountryKey, countryCode);
            
            hasMatch = true;
            break;
          }
        }
      } catch (e) {
        // JSON parsing errors
      }
    }
    
    if (!hasMatch && showError && context != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Unavailable: No active store matches your selection.'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 4),
        ),
      );
    }
    
    return hasMatch;
  }
}

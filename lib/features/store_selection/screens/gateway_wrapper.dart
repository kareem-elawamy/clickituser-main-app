import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/push_notification/models/notification_body.dart';
import 'package:flutter_sixvalley_ecommerce/utill/gateway_service.dart';
import 'package:flutter_sixvalley_ecommerce/features/splash/screens/splash_screen.dart';
import 'package:flutter_sixvalley_ecommerce/features/store_selection/screens/store_selection_screen.dart';
import 'package:flutter_sixvalley_ecommerce/utill/brand_config.dart';
import 'package:flutter_sixvalley_ecommerce/utill/app_constants.dart';
import 'package:flutter_sixvalley_ecommerce/data/datasource/remote/dio/dio_client.dart';
import 'package:flutter_sixvalley_ecommerce/di_container.dart' as di;
import 'package:shared_preferences/shared_preferences.dart';

class GatewayWrapper extends StatefulWidget {
  final NotificationBody? body;
  const GatewayWrapper({Key? key, this.body}) : super(key: key);

  @override
  State<GatewayWrapper> createState() => _GatewayWrapperState();
}

class _GatewayWrapperState extends State<GatewayWrapper> {
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  void _initializeApp() async {
    if (!BrandConfig.useGateway) {
      // ── Umart: permanently anchored to Syria ────────────────────────────
      // The country is NEVER chosen by the user. It is hardcoded here and
      // written to SharedPreferences on every cold start so that any code
      // reading the cache (e.g. GatewayService.initFromCache) always sees a
      // valid, brand-matching Syria selection.
      if (BrandConfig.currentBrand == 'umart') {
        const String umartUrl    = 'https://umart.ussus.net';
        const String umartCountry = 'syria'; // matches gateway store country_code
        const String umartLang   = 'ar';

        // 1. Apply base URL in-memory
        AppConstants.baseUrl = umartUrl;
        try {
          di.sl<DioClient>().updateBaseUrl(umartUrl);
        } catch (_) {
          // DioClient may not yet be registered on very first frame; harmless.
        }

        // 2. Persist the Syria lock so nothing else ever prompts for a country
        try {
          final prefs = di.sl<SharedPreferences>();
          await prefs.setString(GatewayService.selectedCountryKey, umartCountry);
          await prefs.setString(GatewayService.selectedLangKey,    umartLang);
          await prefs.setString(GatewayService.selectedBrandKey,   BrandConfig.currentBrand);
        } catch (_) {
          // SharedPreferences not yet available; not critical as URL is set above.
        }
      }

      // Go directly to SplashScreen — StoreSelectionScreen is NEVER shown
      // for non-gateway (Umart) flavors.
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => SplashScreen(body: widget.body)),
        );
      }
      return;
    }

    // 1. Fetch current active stores online (cached to SharedPreferences)
    await GatewayService.fetchAndCacheStores();

    // 2. See if there is a store selection already cached
    bool hasSavedSelection = GatewayService.initFromCache();

    if (mounted) {
      if (hasSavedSelection) {
        // Setup is successful, safely proceed to original SplashScreen initialization
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => SplashScreen(body: widget.body)),
        );
      } else {
        // Prompt for selection
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => StoreSelectionScreen(body: widget.body)),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Basic Loader while quick checking occurs
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: const Center(
        child: CircularProgressIndicator(color: Colors.white),
      ),
    );
  }
}

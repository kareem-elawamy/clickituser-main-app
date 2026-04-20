import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/push_notification/models/notification_body.dart';
import 'package:flutter_sixvalley_ecommerce/utill/gateway_service.dart';
import 'package:flutter_sixvalley_ecommerce/features/splash/screens/splash_screen.dart';
import 'package:flutter_sixvalley_ecommerce/features/store_selection/screens/store_selection_screen.dart';
import 'package:flutter_sixvalley_ecommerce/utill/app_config.dart';
import 'package:flutter_sixvalley_ecommerce/utill/app_constants.dart';
import 'package:flutter_sixvalley_ecommerce/data/datasource/remote/dio/dio_client.dart';
import 'package:flutter_sixvalley_ecommerce/di_container.dart' as di;

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
    if (!AppConfig.useGateway) {
      if (AppConfig.currentBrand == 'umart') {
        const String umartUrl = 'https://umart.ussus.net';
        AppConstants.baseUrl = umartUrl;
        
        try {
           di.sl<DioClient>().updateBaseUrl(umartUrl);
        } catch(e) {
           // Client may not be registered yet depending on startup order.
        }
      }
      
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

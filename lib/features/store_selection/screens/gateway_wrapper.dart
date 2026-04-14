import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/push_notification/models/notification_body.dart';
import 'package:flutter_sixvalley_ecommerce/utill/gateway_service.dart';
import 'package:flutter_sixvalley_ecommerce/features/splash/screens/splash_screen.dart';
import 'package:flutter_sixvalley_ecommerce/features/store_selection/screens/store_selection_screen.dart';

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

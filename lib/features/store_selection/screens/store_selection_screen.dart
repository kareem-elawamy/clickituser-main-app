import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/features/splash/screens/splash_screen.dart';
import 'package:flutter_sixvalley_ecommerce/features/dashboard/screens/dashboard_screen.dart';
import 'package:flutter_sixvalley_ecommerce/utill/color_resources.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/gateway_service.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';

import 'package:flutter_sixvalley_ecommerce/features/order_details/screens/order_details_screen.dart';
import 'package:flutter_sixvalley_ecommerce/features/splash/controllers/splash_controller.dart';
import 'package:flutter_sixvalley_ecommerce/push_notification/models/notification_body.dart';
import 'package:flutter_sixvalley_ecommerce/features/auth/controllers/auth_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/chat/screens/inbox_screen.dart';
import 'package:flutter_sixvalley_ecommerce/features/maintenance/maintenance_screen.dart';
import 'package:flutter_sixvalley_ecommerce/features/notification/screens/notification_screen.dart';
import 'package:flutter_sixvalley_ecommerce/features/onboarding/screens/onboarding_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter_sixvalley_ecommerce/main.dart';

class StoreSelectionScreen extends StatefulWidget {
  final NotificationBody? body;
  const StoreSelectionScreen({Key? key, this.body}) : super(key: key);

  @override
  State<StoreSelectionScreen> createState() => _StoreSelectionScreenState();
}

class _StoreSelectionScreenState extends State<StoreSelectionScreen> {
  final List<String> _countries = ['oman', 'uae', 'saudi', 'qatar', 'kuwait', 'bahrain', 'iraq', 'syria', 'lebanon', 'jordan'];

  String? _selectedCountry;
  bool _isLoading = false;

  void _onContinue() {
    if (_selectedCountry == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a country.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    bool isSuccess = GatewayService.setDynamicApiBaseUrl(_selectedCountry!, context);

    if (isSuccess) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => SplashScreen(body: widget.body)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Logo or Header
                Image.asset(
                  Images.icon, // Using the app's standard icon
                  height: 100,
                  width: 100,
                ),
                const SizedBox(height: Dimensions.paddingSizeExtraLarge),
                
                Text(
                  'Welcome to Click It',
                  textAlign: TextAlign.center,
                  style: titilliumBold.copyWith(fontSize: 24, color: Theme.of(context).primaryColor),
                ),
                const SizedBox(height: Dimensions.paddingSizeSmall),
                Text(
                  'Please select your preferred region to continue',
                  textAlign: TextAlign.center,
                  style: titilliumRegular.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).hintColor),
                ),
                const SizedBox(height: 40),

                // Country Dropdown
                Text('Select Country/Region', style: titilliumSemiBold.copyWith(fontSize: Dimensions.fontSizeLarge)),
                const SizedBox(height: Dimensions.paddingSizeSmall),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                  decoration: BoxDecoration(
                    color: Theme.of(context).highlightColor,
                    borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
                    border: Border.all(color: Theme.of(context).primaryColor.withOpacity(0.2)),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      isExpanded: true,
                      hint: const Text('Choose a Country'),
                      value: _selectedCountry,
                      items: _countries.map((String country) {
                        return DropdownMenuItem<String>(
                          value: country,
                          child: Text(country.toUpperCase(), style: titilliumRegular),
                        );
                      }).toList(),
                      onChanged: _isLoading ? null : (String? newValue) {
                        setState(() {
                          _selectedCountry = newValue;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 50),

                // Continue Button
                ElevatedButton(
                  onPressed: _isLoading ? null : _onContinue,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    backgroundColor: Theme.of(context).primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
                    ),
                  ),
                  child: _isLoading 
                      ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : Text(
                          'CONTINUE',
                          style: titilliumBold.copyWith(
                            color: Colors.white,
                            fontSize: Dimensions.fontSizeLarge,
                          ),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/features/splash/screens/splash_screen.dart';
import 'package:flutter_sixvalley_ecommerce/localization/controllers/localization_controller.dart';
import 'package:flutter_sixvalley_ecommerce/push_notification/models/notification_body.dart';
import 'package:flutter_sixvalley_ecommerce/utill/app_config.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/gateway_service.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:provider/provider.dart';

class StoreSelectionScreen extends StatefulWidget {
  final NotificationBody? body;
  const StoreSelectionScreen({Key? key, this.body}) : super(key: key);

  @override
  State<StoreSelectionScreen> createState() => _StoreSelectionScreenState();
}

class _StoreSelectionScreenState extends State<StoreSelectionScreen>
    with SingleTickerProviderStateMixin {
  // ── Data ──────────────────────────────────────────────────────────────────
  static const List<String> _countries = [
    'oman', 'uae', 'saudi', 'qatar',
    'kuwait', 'bahrain', 'iraq', 'syria',
    'lebanon', 'jordan',
  ];

  static const Map<String, String> _countryDisplayNames = {
    'oman': '🇴🇲  Oman',
    'uae': '🇦🇪  UAE',
    'saudi': '🇸🇦  Saudi Arabia',
    'qatar': '🇶🇦  Qatar',
    'kuwait': '🇰🇼  Kuwait',
    'bahrain': '🇧🇭  Bahrain',
    'iraq': '🇮🇶  Iraq',
    'syria': '🇸🇾  Syria',
    'lebanon': '🇱🇧  Lebanon',
    'jordan': '🇯🇴  Jordan',
  };

  // Language options — code : display label
  static const Map<String, String> _languages = {
    'ar': 'العربية (Arabic)',
    'en': 'English',
  };

  String? _selectedCountry;
  String _selectedLanguageCode = 'ar'; // default to Arabic
  bool _isLoading = false;

  // ── Animation ─────────────────────────────────────────────────────────────
  late final AnimationController _animController;
  late final Animation<double> _fadeIn;
  late final Animation<Offset> _slideUp;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeIn = CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _slideUp = Tween<Offset>(
      begin: const Offset(0, 0.12),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animController, curve: Curves.easeOut));
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  // ── Logic ──────────────────────────────────────────────────────────────────
  Future<void> _onContinue() async {
    if (_selectedCountry == null) {
      _showSnackBar('Please select your country.', isError: true);
      return;
    }

    setState(() => _isLoading = true);

    // 1. Apply the gateway base URL — flavor-based, no UI brand selection
    final bool isSuccess = GatewayService.setDynamicApiBaseUrl(
      _selectedCountry!,
      context,
      languageCode: _selectedLanguageCode,
    );

    if (!isSuccess) {
      // Error SnackBar is already shown by GatewayService
      setState(() => _isLoading = false);
      return;
    }

    // 2. Apply language via LocalizationController
    if (mounted) {
      final locCtrl = Provider.of<LocalizationController>(context, listen: false);
      final targetLocale = Locale(
        _selectedLanguageCode,
        _selectedLanguageCode == 'ar' ? 'SA' : 'US',
      );
      locCtrl.setLanguage(targetLocale);
    }

    // 3. Navigate to SplashScreen to begin full app initialisation
    if (mounted) {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => SplashScreen(body: widget.body),
          transitionsBuilder: (_, anim, __, child) =>
              FadeTransition(opacity: anim, child: child),
          transitionDuration: const Duration(milliseconds: 400),
        ),
      );
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.redAccent : Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  // ── Build ──────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).primaryColor;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final screenH = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          // ── Background gradient ──────────────────────────────────────────
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    primary,
                    primary.withOpacity(0.7),
                    isDark
                        ? const Color(0xFF1A1A2E)
                        : const Color(0xFFF5F7FA),
                  ],
                  stops: const [0.0, 0.35, 0.6],
                ),
              ),
            ),
          ),

          // ── Decorative circle blobs ──────────────────────────────────────
          Positioned(
            top: -60,
            right: -60,
            child: _GlowCircle(
              size: 220,
              color: Colors.white.withOpacity(0.08),
            ),
          ),
          Positioned(
            top: screenH * 0.18,
            left: -40,
            child: _GlowCircle(
              size: 120,
              color: Colors.white.withOpacity(0.06),
            ),
          ),

          // ── Main content ─────────────────────────────────────────────────
          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  // ── Header ────────────────────────────────────────────
                  SizedBox(height: screenH * 0.06),
                  FadeTransition(
                    opacity: _fadeIn,
                    child: SlideTransition(
                      position: _slideUp,
                      child: _HeaderSection(appName: AppConfig.appName),
                    ),
                  ),

                  SizedBox(height: screenH * 0.045),

                  // ── Card ──────────────────────────────────────────────
                  FadeTransition(
                    opacity: _fadeIn,
                    child: SlideTransition(
                      position: _slideUp,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: Dimensions.paddingSizeLarge),
                        child: _SelectionCard(
                          isDark: isDark,
                          primary: primary,
                          selectedCountry: _selectedCountry,
                          countries: _countries,
                          countryDisplayNames: _countryDisplayNames,
                          selectedLanguageCode: _selectedLanguageCode,
                          languages: _languages,
                          isLoading: _isLoading,
                          onCountryChanged: (v) =>
                              setState(() => _selectedCountry = v),
                          onLanguageChanged: (v) =>
                              setState(() => _selectedLanguageCode = v!),
                          onContinue: _onContinue,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: screenH * 0.04),

                  // ── Flavor badge (debug helper — visible only in debug) ─
                  _FlavorBadge(brand: AppConfig.currentBrand),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Sub-widgets ────────────────────────────────────────────────────────────────

class _GlowCircle extends StatelessWidget {
  final double size;
  final Color color;
  const _GlowCircle({required this.size, required this.color});

  @override
  Widget build(BuildContext context) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(shape: BoxShape.circle, color: color),
      );
}

class _HeaderSection extends StatelessWidget {
  final String appName;
  const _HeaderSection({required this.appName});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Logo with white glow shadow
        Container(
          width: 96,
          height: 96,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 24,
                spreadRadius: 4,
              ),
            ],
          ),
          padding: const EdgeInsets.all(12),
          child: Image.asset(
            Images.logoImage,
            fit: BoxFit.contain,
            errorBuilder: (_, __, ___) => Image.asset(
              Images.icon,
              fit: BoxFit.contain,
            ),
          ),
        ),
        const SizedBox(height: 18),

        // App Name  — dynamic from AppConfig
        Text(
          appName,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 30,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Select your region to get started',
          style: TextStyle(
            color: Colors.white.withOpacity(0.82),
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}

class _SelectionCard extends StatelessWidget {
  final bool isDark;
  final Color primary;
  final String? selectedCountry;
  final List<String> countries;
  final Map<String, String> countryDisplayNames;
  final String selectedLanguageCode;
  final Map<String, String> languages;
  final bool isLoading;
  final ValueChanged<String?> onCountryChanged;
  final ValueChanged<String?> onLanguageChanged;
  final VoidCallback onContinue;

  const _SelectionCard({
    required this.isDark,
    required this.primary,
    required this.selectedCountry,
    required this.countries,
    required this.countryDisplayNames,
    required this.selectedLanguageCode,
    required this.languages,
    required this.isLoading,
    required this.onCountryChanged,
    required this.onLanguageChanged,
    required this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    final cardBg = isDark
        ? Colors.white.withOpacity(0.07)
        : Colors.white.withOpacity(0.96);
    final borderColor = isDark
        ? Colors.white.withOpacity(0.12)
        : Colors.white;
    final labelColor = isDark ? Colors.white70 : Colors.black87;
    final hintColor = isDark ? Colors.white38 : Colors.black38;

    return Container(
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: borderColor, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 32,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(22, 28, 22, 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Country ─────────────────────────────────────────────────────
          _SectionLabel(
            icon: Icons.public_rounded,
            label: 'Country / Region',
            color: primary,
          ),
          const SizedBox(height: 10),
          _StyledDropdown<String>(
            value: selectedCountry,
            hint: Text(
              'Choose a country',
              style: TextStyle(color: hintColor, fontSize: 14),
            ),
            items: countries.map((c) {
              return DropdownMenuItem<String>(
                value: c,
                child: Text(
                  countryDisplayNames[c] ?? c.toUpperCase(),
                  style: TextStyle(
                    color: labelColor,
                    fontSize: 14.5,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            }).toList(),
            onChanged: isLoading ? null : onCountryChanged,
            primary: primary,
            isDark: isDark,
          ),

          const SizedBox(height: 22),

          // ── Language ─────────────────────────────────────────────────────
          _SectionLabel(
            icon: Icons.language_rounded,
            label: 'Language',
            color: primary,
          ),
          const SizedBox(height: 10),
          _StyledDropdown<String>(
            value: selectedLanguageCode,
            hint: Text(
              'Choose a language',
              style: TextStyle(color: hintColor, fontSize: 14),
            ),
            items: languages.entries.map((e) {
              return DropdownMenuItem<String>(
                value: e.key,
                child: Text(
                  e.value,
                  style: TextStyle(
                    color: labelColor,
                    fontSize: 14.5,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            }).toList(),
            onChanged: isLoading ? null : onLanguageChanged,
            primary: primary,
            isDark: isDark,
          ),

          const SizedBox(height: 32),

          // ── Continue button ───────────────────────────────────────────────
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: isLoading ? null : onContinue,
              style: ElevatedButton.styleFrom(
                backgroundColor: primary,
                disabledBackgroundColor: primary.withOpacity(0.5),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: isLoading
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2.5,
                      ),
                    )
                  : const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Continue',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.4,
                          ),
                        ),
                        SizedBox(width: 8),
                        Icon(Icons.arrow_forward_rounded,
                            color: Colors.white, size: 18),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  const _SectionLabel({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: color, size: 16),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(
            color: color,
            fontSize: 13,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.3,
          ),
        ),
      ],
    );
  }
}

class _StyledDropdown<T> extends StatelessWidget {
  final T? value;
  final Widget hint;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?>? onChanged;
  final Color primary;
  final bool isDark;

  const _StyledDropdown({
    required this.value,
    required this.hint,
    required this.items,
    required this.onChanged,
    required this.primary,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withOpacity(0.05)
            : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark
              ? Colors.white.withOpacity(0.15)
              : Colors.grey.shade200,
          width: 1.2,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          isExpanded: true,
          value: value,
          hint: hint,
          dropdownColor: isDark ? const Color(0xFF2A2A3E) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          icon: Icon(Icons.keyboard_arrow_down_rounded,
              color: primary, size: 22),
          items: items,
          onChanged: onChanged,
        ),
      ),
    );
  }
}

/// Small pill badge showing the active flavor — useful during QA/testing.
class _FlavorBadge extends StatelessWidget {
  final String brand;
  const _FlavorBadge({required this.brand});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.25)),
      ),
      child: Text(
        'Flavor: $brand',
        style: const TextStyle(
          color: Colors.white70,
          fontSize: 11,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.4,
        ),
      ),
    );
  }
}

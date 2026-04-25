class AppConfig {
  static const String currentBrand = String.fromEnvironment('BRAND', defaultValue: 'velvey');
  
  static String get appName {
    switch (currentBrand) {
      case 'umart': return 'Umart';
      case 'ladychic': return 'LadyChic';
      case 'vivo': return 'VIVO';
      case 'veraalux': return 'Veraalux';
      case 'velvey':
      default:
        return 'Velvey';
    }
  }

  static bool get useGateway => currentBrand != 'umart';

  static String get appLogo => 'assets/images/logo/${currentBrand.toLowerCase()}_logo.png';
}

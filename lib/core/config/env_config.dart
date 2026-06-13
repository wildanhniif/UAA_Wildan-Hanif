class EnvConfig {
  // Mencegah class ini diinstansiasi dengan 'new EnvConfig()'
  EnvConfig._();

  // 1. Menangkap variabel 'ENV_NAME' dari terminal (Dev / Prod)
  static const String environment = String.fromEnvironment(
    'ENV_NAME',
    defaultValue: 'DEVELOPMENT',
  );

  // 2. Menangkap variabel 'BASE_URL' dari terminal
  static const String baseUrl = String.fromEnvironment(
    'BASE_URL',
    defaultValue: 'https://fakestoreapi.com', // Default fallback
  );

  // 3. Menangkap variabel 'SHOW_DEBUG_BANNER' (True / False)
  static const bool showDebugBanner = bool.fromEnvironment(
    'SHOW_DEBUG_BANNER',
    defaultValue: true,
  );

  // Fungsi praktis untuk mengecek apakah kita di Production
  static bool get isProduction => environment == 'PRODUCTION';
}

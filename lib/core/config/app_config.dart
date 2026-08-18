class AppConfig {
  const AppConfig._();

  static const apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://10.0.2.2:8000/api/v1',
  );

  static const supabaseUrl = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'https://rzjhalgyhznynhyxpuoz.supabase.co',
  );
  static const supabasePublishableKey = String.fromEnvironment(
    'SUPABASE_PUBLISHABLE_KEY',
    defaultValue: 'sb_publishable_XAukyV79YloO3bUO9E5V8w_ygHmtccd',
  );

  static bool get hasSupabaseConfig =>
      supabaseUrl.isNotEmpty && supabasePublishableKey.isNotEmpty;
}

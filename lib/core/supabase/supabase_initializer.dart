import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:well_less_app/core/config/app_config.dart';

Future<bool> initializeSupabase() async {
  if (!AppConfig.hasSupabaseConfig) {
    return false;
  }
  await Supabase.initialize(
    url: AppConfig.supabaseUrl,
    publishableKey: AppConfig.supabasePublishableKey,
  );
  return true;
}


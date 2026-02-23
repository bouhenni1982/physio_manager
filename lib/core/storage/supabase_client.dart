import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseClientProvider {
  const SupabaseClientProvider();

  SupabaseClient get client => Supabase.instance.client;
}

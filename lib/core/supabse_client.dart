import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> initSupabase() async {
  await Supabase.initialize(
    url: 'https://gqkjdevencvibiqvislk.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imdxa2pkZXZlbmN2aWJpcXZpc2xrIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDkwNDMwOTcsImV4cCI6MjA2NDYxOTA5N30.S9MEekdNFugTMOV5xAmdP6xWrVFpPwB-kN_Iwv0KOXY',
  );
}

final supabase = Supabase.instance.client;

import 'package:flutter/material.dart';
import 'package:mindmate_patient/login.dart';


import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  await Supabase.initialize(
    url: 'https://ntwdneuosxsgdkzzjbvc.supabase.co',
    anonKey: 'sb_publishable_gizGesbd1JfJ-8i21-FfFQ_wnjgfrkz',
  );
  runApp(const MainApp());
}
        
final supabase = Supabase.instance.client;

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: PatientLoginScreen()
    );
  }
}

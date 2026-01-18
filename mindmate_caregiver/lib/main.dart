import 'package:flutter/material.dart';
import 'package:mindmate_caregiver/login.dart';


import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  await Supabase.initialize(
    url: 'https://ntwdneuosxsgdkzzjbvc.supabase.co',
    anonKey: 'sb_publishable_gizGesbd1JfJ-8i21-FfFQ_wnjgfrkz',
  );
  runApp(MyApp());
}
        
final supabase = Supabase.instance.client;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CaregiverLoginScreen(),
    );
  }
}

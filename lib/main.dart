import 'package:flutter/material.dart';
import 'package:totalx/features/auth/presentation/screens/login_screen.dart';
import 'package:totalx/features/auth/presentation/screens/otp_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: OtpScreen(phone: "0000999999"),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:totalx/core/widgets/custom_key_pad.dart';
import 'package:totalx/features/auth/presentation/widgets/kcustom_button.dart';
import 'package:totalx/features/auth/presentation/widgets/kcustom_textfield.dart';
import 'package:totalx/features/auth/presentation/widgets/terms_privacy_text.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String _phone = '';

  void _onKeyTap(String value) {
    if (_phone.length < 10) {
      setState(() => _phone += value);
    }
  }

  void _onDelete() {
    if (_phone.isNotEmpty) {
      setState(() => _phone = _phone.substring(0, _phone.length - 1));
    }
  }

  void _submit() {
    if (_phone.length == 10) {
      debugPrint("Phone: $_phone");
    } else {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter a valid 10 digit phone number')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFAFAFA),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 60),

                    Center(
                      child: SizedBox(
                        width: 130,
                        height: 130,
                        child: Image.asset('assets/images/login_top_image.png'),
                      ),
                    ),

                    const SizedBox(height: 35),

                    const Text(
                      'Enter phone number',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color.fromARGB(255, 59, 59, 59),
                      ),
                    ),

                    const SizedBox(height: 13),

                    PhoneDisplayBox(phone: _phone),

                    const SizedBox(height: 20),

                    const TermsPrivacyText(),

                    const SizedBox(height: 20),

                    KcustomButton(text: 'Get OTP', onPressed: _submit),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),

            KCustomKeypad(onKeyTap: _onKeyTap, onDelete: _onDelete),
          ],
        ),
      ),
    );
  }
}

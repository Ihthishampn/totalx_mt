import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:totalx/core/enums/app_state.dart';
import 'package:totalx/core/widgets/custom_key_pad.dart';
import 'package:totalx/core/widgets/double_back_press_wrapper.dart';
import 'package:totalx/features/auth/presentation/provider/auth_provider.dart';
import 'package:totalx/features/auth/presentation/screens/otp_screen.dart';
import 'package:totalx/features/auth/presentation/widgets/kcustom_button.dart';
import 'package:totalx/features/auth/presentation/widgets/kcustom_textfield.dart';
import 'package:totalx/features/auth/presentation/widgets/terms_privacy_text.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DoubleBackPressWrapper(
      child: Scaffold(
        backgroundColor: const Color(0xFFFAFAFA),
        body: SafeArea(
          child: Consumer<AuthProvider>(
            builder: (context, authProvider, child) {
              return Column(
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
                              child: Image.asset(
                                'assets/images/login_top_image.png',
                              ),
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
                          PhoneDisplayBox(phone: authProvider.phone),
                          const SizedBox(height: 20),
                          const TermsPrivacyText(),
                          const SizedBox(height: 20),
                          if (authProvider.loginError != null)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.red.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: Colors.red),
                                ),
                                child: Text(
                                  authProvider.loginError!,
                                  style: const TextStyle(
                                    color: Colors.red,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ),
                          KcustomButton(
                            text: authProvider.state == AppState.loading
                                ? 'Sending OTP...'
                                : 'Get OTP',
                            onPressed: authProvider.state == AppState.loading
                                ? () {}
                                : () {
                                    authProvider.sendOtp().then((success) {
                                      if (success && context.mounted) {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (_) => const OtpScreen(),
                                          ),
                                        );
                                      }
                                    });
                                  },
                          ),
                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ),
                  KCustomKeypad(
                    onKeyTap: authProvider.addPhoneDigit,
                    onDelete: authProvider.removePhoneDigit,
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

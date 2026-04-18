import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:totalx/core/widgets/double_back_press_wrapper.dart';
import 'package:totalx/core/widgets/custom_key_pad.dart';
import 'package:totalx/features/auth/presentation/provider/auth_provider.dart';
import 'package:totalx/features/auth/presentation/widgets/otp_screen_widgets.dart';
import 'package:totalx/features/users/presentation/screens/user_screen.dart';

class OtpScreen extends StatelessWidget {
  const OtpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        return DoubleBackPressWrapper(
          child: Scaffold(
            backgroundColor: const Color(0xFFFAFAFA),
            body: SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: OtpScreenSection(
                      authProvider: authProvider,
                      resendSeconds: authProvider.resendSeconds,
                      showTestOtp: authProvider.showTestOtp,
                      onResend: () {
                        authProvider.resendOtp().then((success) {
                          if (success) {
                            authProvider.restartResendTimer();
                          }
                        });
                      },
                      onVerify: () {
                        authProvider.verifyOtp().then((success) {
                          if (success && context.mounted) {
                            authProvider.stopOtpTimer();
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                builder: (_) => const UserScreen(),
                              ),
                              (route) => false,
                            );
                          }
                        });
                      },
                      maskPhone: _getMaskedPhone,
                    ),
                  ),
                  KCustomKeypad(
                    onKeyTap: authProvider.addOtpDigit,
                    onDelete: authProvider.removeOtpDigit,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
// mask for hide number
  String _getMaskedPhone(String phone) {
    if (phone.length >= 2) {
      final visible = phone.substring(phone.length - 2);
      return '+91 *** *** $visible';
    }
    return '+91 $phone';
  }
}

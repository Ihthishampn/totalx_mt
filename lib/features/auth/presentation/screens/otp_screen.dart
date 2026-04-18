import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'package:totalx/core/widgets/double_back_press_wrapper.dart';
import 'package:totalx/core/widgets/custom_key_pad.dart';
import 'package:totalx/features/auth/presentation/provider/auth_provider.dart';
import 'package:totalx/features/auth/presentation/widgets/otp_screen_widgets.dart';
import 'package:totalx/features/users/presentation/screens/user_screen.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  late Timer _resendTimer;
  int _resendSeconds = 59;

  @override
  void initState() {
    super.initState();
    _startResendTimer();
  }

  void _startResendTimer() {
    _resendSeconds = 59;
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          if (_resendSeconds > 0) {
            _resendSeconds--;
          } else {
            timer.cancel();
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _resendTimer.cancel();
    super.dispose();
  }

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
                      resendSeconds: _resendSeconds,
                      onResend: () {
                        authProvider.resendOtp().then((success) {
                          if (success && mounted) {
                            _startResendTimer();
                          }
                        });
                      },
                      onVerify: () {
                        authProvider.verifyOtp().then((success) {
                          if (success && context.mounted) {
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

  String _getMaskedPhone(String phone) {
    if (phone.length >= 2) {
      final visible = phone.substring(phone.length - 2);
      return '+91 *** *** $visible';
    }
    return '+91 $phone';
  }
}

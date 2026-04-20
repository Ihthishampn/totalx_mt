import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'package:totalx/core/widgets/double_back_press_wrapper.dart';
import 'package:totalx/core/widgets/custom_key_pad.dart';
import 'package:totalx/features/auth/presentation/provider/auth_provider.dart';
import 'package:totalx/features/auth/presentation/widgets/otp_screen_widgets.dart';
import 'package:totalx/features/auth/presentation/screens/google_signin_screen.dart';
import 'package:totalx/features/users/presentation/screens/user_screen.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  Timer? _redirectTimer;
  bool _showGoogleButton = false;

  @override
  void initState() {
    super.initState();
    _redirectTimer = Timer(const Duration(seconds: 3), _showRedirectAlert);
  }

  @override
  void dispose() {
    _redirectTimer?.cancel();
    super.dispose();
  }
void _showRedirectAlert() {
  setState(() {
    _showGoogleButton = true;
  });

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => WillPopScope(
      onWillPop: () async => false,
      child: AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text(
          'Authentication Update Required',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [

              Text(
                '⚠️ DLT SMS Restriction Issue',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFE53935),
                ),
              ),
              SizedBox(height: 6),
              Text(
                'SMS OTP requests are returning success (200 OK), but messages are not being delivered due to DLT regulations.',
              ),

              SizedBox(height: 14),

              Text(
                '📌 DLT Registration Status',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFFF9800),
                ),
              ),
              SizedBox(height: 6),
              Text(
                'DLT registration has already been submitted for sender ID approval. However, due to compliance checks and sensitive verification requirements, the process is still under review.',
              ),

              SizedBox(height: 14),

              Text(
                '👨‍💼 HR Instruction',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E88E5),
                ),
              ),
              SizedBox(height: 6),
              Text(
                'As per HR support, Google Sign-In has been implemented as the primary authentication method.',
              ),
            ],
          ),
        ),

        actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        actions: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => _navigateToGoogleSignIn(),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1E88E5),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Continue with Google Sign-In',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

  void _navigateToGoogleSignIn() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const GoogleSignInScreen()),
      (route) => false,
    );
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
                  if (_showGoogleButton) ...[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Align(
                        alignment: Alignment.topRight,
                        child: TextButton.icon(
                          onPressed: _navigateToGoogleSignIn,
                          icon: const Icon(Icons.login, size: 16),
                          label: const Text('Google Sign-In',
                              style: TextStyle(fontSize: 12)),
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                          ),
                        ),
                      ),
                    ),
                  ],
                  Expanded(
                    child: OtpScreenSection(
                      authProvider: authProvider,
                      resendSeconds: authProvider.resendSeconds,
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

  String _getMaskedPhone(String phone) {
    if (phone.length >= 2) {
      final visible = phone.substring(phone.length - 2);
      return '+91 *** *** $visible';
    }
    return '+91 $phone';
  }
}

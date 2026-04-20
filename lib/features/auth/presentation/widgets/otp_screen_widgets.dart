import 'package:flutter/material.dart';
import 'package:totalx/core/enums/app_state.dart';
import 'package:totalx/features/auth/presentation/provider/auth_provider.dart';
import 'package:totalx/features/auth/presentation/widgets/kcustom_button.dart';
import 'package:totalx/features/auth/presentation/widgets/otp_display.dart';
import 'package:totalx/features/auth/presentation/widgets/otp_error_card.dart';
import 'package:totalx/features/auth/presentation/widgets/otp_sender_row.dart';

// otp screen break downs all here managing ......
class OtpScreenSection extends StatelessWidget {
  final AuthProvider authProvider;
  final int resendSeconds;
  final VoidCallback onResend;
  final VoidCallback onVerify;
  final String Function(String) maskPhone;

  const OtpScreenSection({
    super.key,
    required this.authProvider,
    required this.resendSeconds,
    required this.onResend,
    required this.onVerify,
    required this.maskPhone,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 40),
          Center(
            child: Image.asset(
              'assets/images/otp_top_image.png',
              height: 120,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 32),
          const Text(
            'OTP Verification',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Color(0xFF111111),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: Text(
              'Enter the verification code we just sent to ${maskPhone(authProvider.sentPhone)}',
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF666666),
                height: 1.5,
              ),
              softWrap: true,
            ),
          ),
          const SizedBox(height: 28),
          OtpDisplay(otp: authProvider.otp),
          if (authProvider.otpError != null) ...[
            const SizedBox(height: 16),
            OtpErrorCard(errorText: authProvider.otpError!),
          ],
          const SizedBox(height: 16),
          Center(
            child: Text(
              resendSeconds > 0 ? '$resendSeconds sec' : '',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.red,
              ),
            ),
          ),
          const SizedBox(height: 16),
          OtpResendRow(canResend: resendSeconds == 0, onResend: onResend),
          const SizedBox(height: 28),
          KcustomButton(
            text: authProvider.state == AppState.loading
                ? 'Verifying...'
                : 'Verify',
            onPressed: authProvider.state == AppState.loading
                ? () {}
                : onVerify,
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

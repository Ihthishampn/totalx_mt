

import 'package:flutter/material.dart';

class OtpResendRow extends StatelessWidget {
  final bool canResend;
  final VoidCallback onResend;

  const OtpResendRow({
    super.key,
    required this.canResend,
    required this.onResend,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Wrap(
        alignment: WrapAlignment.center,
        children: [
          const Text(
            "Didn't get OTP? ",
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: Color(0xFF666666),
            ),
          ),
          GestureDetector(
            onTap: canResend ? onResend : null,
            child: Text(
              'Resend',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: canResend
                    ? const Color(0xFF1565C0)
                    : const Color(0xFFCCCCCC),
                decoration: TextDecoration.underline,
                decorationThickness: 0.7,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

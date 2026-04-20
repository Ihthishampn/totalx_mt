import 'package:flutter/material.dart';
import 'package:totalx/features/auth/presentation/widgets/otp_box_field.dart';

class OtpDisplay extends StatelessWidget {
  final String otp;

  const OtpDisplay({super.key, required this.otp});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(
        6,
        (i) => KOtpBox(
          digit: i < otp.length ? otp[i] : '',
          isActive: i == otp.length,
        ),
      ),
    );
  }
}

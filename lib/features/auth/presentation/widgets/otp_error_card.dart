
import 'package:flutter/material.dart';

class OtpErrorCard extends StatelessWidget {
  final String errorText;

  const OtpErrorCard({super.key, required this.errorText});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.red.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.red),
        ),
        child: Text(
          errorText,
          style: const TextStyle(color: Colors.red, fontSize: 13),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';

class KOtpBox extends StatelessWidget {
  final String digit;
  final bool isActive;

  const KOtpBox({
    super.key,
    required this.digit,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final isFilled = digit.isNotEmpty;

    return Container(
      width: w * 0.12,  
      height: w * 0.14, 
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isFilled || isActive
              ? const Color(0xFF222222)
              : const Color(0xFFCCCCCC),
          width: 1.5,
        ),
        boxShadow: isFilled
            ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      alignment: Alignment.center,
      child: FittedBox(
        child: Text(
          digit,
          style: TextStyle(
            fontSize: w * 0.06, 
            fontWeight: FontWeight.w600,
            color: const Color(0xFF222222),
          ),
        ),
      ),
    );
  }
}
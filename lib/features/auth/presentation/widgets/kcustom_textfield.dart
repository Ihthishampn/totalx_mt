
import 'package:flutter/material.dart';

class PhoneDisplayBox extends StatelessWidget {
  final String phone;

  const PhoneDisplayBox({super.key, required this.phone});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: phone.isNotEmpty
              ? const Color(0xFF222222)
              : Colors.grey[300]!,
          width: phone.isNotEmpty ? 1.5 : 1,
        ),
      ),
      alignment: Alignment.centerLeft,
    child: Row(
  children: [
    Expanded(
      child: phone.isEmpty
          ? RichText(
              text: const TextSpan(
                children: [
                  TextSpan(
                    text: 'Enter phone number',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  TextSpan(
                    text: ' *',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.red,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            )
          : Text(
              phone,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF111111),
                fontWeight: FontWeight.w500,
              ),
            ),
    ),
  ],
),
    );
  }
}
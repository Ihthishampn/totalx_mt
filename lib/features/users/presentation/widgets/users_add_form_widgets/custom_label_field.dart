import 'package:flutter/material.dart';

class CustomLabelField extends StatelessWidget {
  final String label;
  final String hint;
  final bool isNumber;

  const CustomLabelField({
    super.key, 
    required this.label, 
    required this.hint, 
    this.isNumber = false
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14, 
            color: Colors.grey.shade600, 
            fontWeight: FontWeight.w500
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          keyboardType: isNumber ? TextInputType.number : TextInputType.text,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
          ),
        ),
      ],
    );
  }
}
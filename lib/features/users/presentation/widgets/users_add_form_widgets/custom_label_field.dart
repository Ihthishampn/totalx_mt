import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomLabelField extends StatelessWidget {
  final String label;
  final String hint;
  final bool isNumber;
  final bool hideCounter;
  final int? maxLength;
  final String? Function(String?)? validator;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;

  const CustomLabelField({
    super.key,
    required this.label,
    required this.hint,
    this.isNumber = false,
    this.hideCounter = false,
    this.validator,
    this.controller,
    this.onChanged,
    this.maxLength,
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
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: isNumber ? TextInputType.number : TextInputType.text,
          validator: validator,
          buildCounter: hideCounter
              ? (
                  _, {
                  required int currentLength,
                  int? maxLength,
                  bool? isFocused,
                }) => null
              : null,
          onChanged: onChanged,
          maxLength: maxLength,
          maxLengthEnforcement: maxLength != null
              ? MaxLengthEnforcement.enforced
              : MaxLengthEnforcement.none,
          inputFormatters: [
            if (isNumber) FilteringTextInputFormatter.digitsOnly,
          ],
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            errorMaxLines: 2,
          ),
        ),
      ],
    );
  }
}

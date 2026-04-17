import 'package:flutter/material.dart';

class SheetTitle extends StatelessWidget {
  final String title;
  const SheetTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: Color(0xFF161616),
      ),
    );
  }
}

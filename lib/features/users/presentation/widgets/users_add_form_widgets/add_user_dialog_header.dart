import 'package:flutter/material.dart';

class AddUserDialogHeader extends StatelessWidget {
  const AddUserDialogHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text(
      "Add A New User",
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: Color(0xFF161616),
      ),
    );
  }
}

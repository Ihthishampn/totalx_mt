import 'package:flutter/material.dart';

class AddUserFab extends StatelessWidget {
  final VoidCallback onTap;
  const AddUserFab({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: Colors.black,
      onPressed: onTap,
      shape: const CircleBorder(),
      child: const Icon(Icons.add, color: Colors.white),
    );
  }
}
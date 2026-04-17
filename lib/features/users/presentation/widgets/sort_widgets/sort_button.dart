
import 'package:flutter/material.dart';

class SortButton extends StatelessWidget {
  final VoidCallback onTap;
  const SortButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 45,
        width: 45,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Icon(Icons.sort, color: Colors.white),
      ),
    );
  }
}


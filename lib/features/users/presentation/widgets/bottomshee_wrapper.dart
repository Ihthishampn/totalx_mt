import 'package:flutter/material.dart';

class BottomSheetWrapper extends StatelessWidget {
  final Widget child;
  const BottomSheetWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: child,
    );
  }
}


import 'package:flutter/material.dart';

class UserInfo extends StatelessWidget {
  final String name;
  final int age;
  const UserInfo({super.key, required this.name, required this.age});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          name,
          style: const TextStyle(fontWeight: FontWeight.w600),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        Text("Age: $age", style: const TextStyle(color: Colors.grey)),
      ],
    );
  }
}

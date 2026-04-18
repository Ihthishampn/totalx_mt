import 'package:flutter/material.dart';
import 'package:totalx/features/users/presentation/widgets/user_display_card_widgets/user_avatar.dart';
import 'package:totalx/features/users/presentation/widgets/user_display_card_widgets/user_info.dart';

class UserCard extends StatelessWidget {
  final String name;
  final int age;
  final String avatarUrl;

  const UserCard({
    super.key,
    required this.name,
    required this.age,
    required this.avatarUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 76,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
            spreadRadius: 1,
          ),
        ],
      ),
      child: Row(
        children: [
          UserAvatar(imageUrl: avatarUrl),
          const SizedBox(width: 12),
          UserInfo(name: name, age: age),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:totalx/features/users/presentation/widgets/user_display_card_widgets/user_card.dart';

class UserList extends StatelessWidget {
  const UserList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      itemCount: 6,
      itemBuilder: (context, index) => const UserCard(
        name: "Martin Dokidis",
        age: 34,
        avatarUrl: "https://i.pravatar.cc/150?img=3",
      ),
    );
  }
}


import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:totalx/core/enums/app_state.dart';
import 'package:totalx/features/users/presentation/provider/user_provider.dart';
import 'package:totalx/features/users/presentation/widgets/user_display_card_widgets/user_card.dart';

class UserList extends StatelessWidget {
  const UserList({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        if (userProvider.state == AppState.loading &&
            userProvider.users.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (userProvider.state == AppState.error &&
            userProvider.users.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 48, color: Colors.red),
                const SizedBox(height: 16),
                Text(
                  'Failed to load users',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  userProvider.error ?? 'Unknown error',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => userProvider.loadUsers(),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        if (userProvider.users.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.people_outline, size: 48, color: Colors.grey),
                const SizedBox(height: 16),
                Text(
                  'No users found',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  userProvider.searchQuery.isNotEmpty
                      ? 'Try adjusting your search'
                      : 'Add your first user',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: Colors.grey),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          itemCount: userProvider.users.length,
          itemBuilder: (context, index) {
            final user = userProvider.users[index];
            return UserCard(
              name: user.name,
              age: user.age,
              avatarUrl:
                  user.imageUrl ??
                  'https://i.pravatar.cc/150?img=3', 
            );
          },
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:totalx/core/enums/app_state.dart';
import 'package:totalx/features/users/presentation/provider/user_provider.dart';
import 'package:totalx/features/users/presentation/widgets/user_display_card_widgets/user_card.dart';

class UserList extends StatefulWidget {
  const UserList({super.key});

  @override
  State<UserList> createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final triggerFetchMore =
        _scrollController.position.maxScrollExtent -
            _scrollController.position.pixels <=
        100;
    if (triggerFetchMore) {
      final userProvider = context.read<UserProvider>();
      if (userProvider.hasMore && !userProvider.isLoadingMore) {
        userProvider.loadMoreUsers();
      }
    }
  }

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

        final itemCount =
            userProvider.users.length + (userProvider.isLoadingMore ? 1 : 0);
        return ListView.builder(
          controller: _scrollController,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          itemCount: itemCount,
          itemBuilder: (context, index) {
            if (index >= userProvider.users.length) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Center(child: CircularProgressIndicator()),
              );
            }
            final user = userProvider.users[index];
            return UserCard(
              name: user.name,
              age: user.age,
              avatarUrl: user.imageUrl ?? 'https://plus.unsplash.com/premium_photo-1670455444534-8be2935455ae?fm=jpg&q=60&w=3000&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NXx8Y29sb3IlMjBzcGxhc2h8ZW58MHx8MHx8fDA%3D',
            );
          },
        );
      },
    );
  }
}

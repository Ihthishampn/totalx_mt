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
  bool _loadMoreErrorShown = false;

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
        final users = userProvider.users;
        final state = userProvider.state;

        if (state == AppState.error && users.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Failed to load users'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => userProvider.loadUsers(),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        if (state == AppState.loading && users.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (users.isEmpty) {
          return const Center(child: Text('No users found'));
        }

        if (state == AppState.error && !_loadMoreErrorShown) {
          _loadMoreErrorShown = true;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('Failed to load more users'),
                action: SnackBarAction(
                  label: 'Retry',
                  onPressed: () {
                    userProvider.loadMoreUsers();
                    _loadMoreErrorShown = false;
                  },
                ),
              ),
            );
          });
        } else if (state != AppState.error) {
          _loadMoreErrorShown = false;
        }

        return ListView.builder(
          controller: _scrollController,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          itemCount: users.length + (userProvider.isLoadingMore ? 1 : 0),
          itemBuilder: (context, index) {
            if (index >= users.length) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Center(child: CircularProgressIndicator()),
              );
            }
            final user = users[index];
            return UserCard(
              name: user.name,
              age: user.age,
              avatarUrl:
                  user.imageUrl ??
                  'https://plus.unsplash.com/premium_photo-1670455444534-8be2935455ae?fm=jpg&q=60&w=3000&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NXx8Y29sb3IlMjBzcGxhc2h8ZW58MHx8MHx8fDA%3D',
            );
          },
        );
      },
    );
  }
}

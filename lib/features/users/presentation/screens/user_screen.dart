import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:totalx/core/enums/app_state.dart';
import 'package:totalx/core/utils/auth_preferences.dart';
import 'package:totalx/core/widgets/double_back_press_wrapper.dart';
import 'package:totalx/features/auth/presentation/provider/auth_provider.dart';
import 'package:totalx/features/auth/presentation/screens/login_screen.dart';
import 'package:totalx/features/users/presentation/provider/user_provider.dart';
import 'package:totalx/features/users/presentation/provider/add_user_form_provider.dart';

import '../widgets/users_add_form_widgets/add_user_dilogue.dart';
import '../widgets/users_add_form_widgets/add_user_fab.dart';
import '../widgets/kcustom_user_appbar.dart';
import '../widgets/search_and_filter_row.dart';
import '../widgets/seccion_title.dart';
import '../widgets/sort_widgets/sort_bottom_sheet.dart';
import '../widgets/user_display_card_widgets/user_list.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UserProvider>().loadUsers();
    });
  }

  @override
  Widget build(BuildContext context) {
    return DoubleBackPressWrapper(
      child: Scaffold(
        backgroundColor: const Color(0xFFEBEBEB),
        appBar: UserAppBar(onLogout: _logout),
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              SearchAndFilterRow(
                onSortTap: () => _showSortSheet(context),
                onSearchChanged: (query) =>
                    context.read<UserProvider>().searchUsers(query),
              ),
              const SizedBox(height: 16),
              const SectionTitle(title: "Users Lists"),
              const SizedBox(height: 10),
              const Expanded(child: UserList()),
            ],
          ),
        ),
        floatingActionButton: AddUserFab(
          onTap: () => _showAddUserDialog(context),
        ),
      ),
    );
  }

  void _showSortSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => SortBottomSheet(
        onSortSelected: (isElder) {
          if (isElder != context.read<UserProvider>().isSortedByElder) {
            context.read<UserProvider>().toggleSort();
          }
        },
      ),
    );
  }

  void _showAddUserDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.black38,
      barrierDismissible: false,
      builder: (_) => ChangeNotifierProvider(
        create: (_) => AddUserFormProvider(),
        child: Consumer<UserProvider>(
          builder: (context, userProvider, child) {
            if (userProvider.justAddedUser) {
              final navigator = Navigator.of(context);
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (navigator.canPop()) {
                  navigator.pop();
                }
              });
            }

            return PopScope(
              canPop: userProvider.state != AppState.loading,
              child: AddUserDialog(
                onSave: userProvider.state == AppState.loading
                    ? null
                    : (name, phone, age, image) {
                        context.read<UserProvider>().addUser(
                          name,
                          phone,
                          age,
                          image,
                        );
                      },
                isLoading: userProvider.state == AppState.loading,
              ),
            );
          },
        ),
      ),
    );
  }

  void _logout() async {
    final authProvider = context.read<AuthProvider>();
    final navigator = Navigator.of(context);

    await AuthPreferences.setIsLoggedIn(false);
    await authProvider.logout();
    if (!mounted) return;

    navigator.pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }
}

import 'package:flutter/material.dart';

import '../widgets/users_add_form_widgets/add_user_dilogue.dart';
import '../widgets/users_add_form_widgets/add_user_fab.dart';
import '../widgets/kcustom_user_appbar.dart';
import '../widgets/search_and_filter_row.dart';
import '../widgets/seccion_title.dart';
import '../widgets/sort_widgets/sort_bottom_sheet.dart';
import '../widgets/user_display_card_widgets/user_list.dart';

class UserScreen extends StatelessWidget {
  const UserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEBEBEB),
      appBar: const UserAppBar(),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),
            SearchAndFilterRow(onSortTap: () => _showSortSheet(context)),
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
    );
  }

  static void _showSortSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => const SortBottomSheet(),
    );
  }

  static void _showAddUserDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.black38,
      builder: (_) => const AddUserDialog(),
    );
  }
}






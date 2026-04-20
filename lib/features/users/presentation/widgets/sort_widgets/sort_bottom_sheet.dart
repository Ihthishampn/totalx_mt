import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:totalx/features/users/presentation/widgets/bottomshee_wrapper.dart';
import 'package:totalx/features/users/presentation/widgets/sort_widgets/radio_option_title.dart';
import 'package:totalx/features/users/presentation/widgets/sheet_handle.dart';

import '../../provider/user_provider.dart';

import '../sheet_title.dart';

class SortBottomSheet extends StatelessWidget {
  final ValueChanged<bool>? onSortSelected;

  static const _options = ["All", "Age: Elder", "Age: Younger"];

  const SortBottomSheet({super.key, this.onSortSelected});

  @override
  Widget build(BuildContext context) {
    final selected = context.select<UserProvider, int>(
      (provider) => provider.selectedSortIndex,
    );
    final navigator = Navigator.of(context);

    return BottomSheetWrapper(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SheetHandle(),
          const SizedBox(height: 16),
          const SheetTitle(title: "Sort Users"),
          const SizedBox(height: 16),
          ..._options.asMap().entries.map(
                (entry) => RadioOptionTile(
                  label: entry.value,
                  isSelected: selected == entry.key,
                  onTap: () {
                    FocusScope.of(context).unfocus();
                    context.read<UserProvider>().setSortIndex(entry.key);
                    onSortSelected?.call(entry.key == 1);
                    Future.delayed(const Duration(milliseconds: 150), () {
                      if (!navigator.mounted) return;
                      navigator.pop();
                    });
                  },
                ),
              ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:totalx/features/users/presentation/widgets/bottomshee_wrapper.dart';
import 'package:totalx/features/users/presentation/widgets/sort_widgets/radio_option_title.dart';
import 'package:totalx/features/users/presentation/widgets/sheet_handle.dart';

import '../sheet_title.dart';

class SortBottomSheet extends StatefulWidget {
  const SortBottomSheet({super.key});

  @override
  State<SortBottomSheet> createState() => _SortBottomSheetState();
}

class _SortBottomSheetState extends State<SortBottomSheet> {
  int _selected = 0;

  static const _options = ["All", "Age: Elder", "Age: Younger"];

  @override
  Widget build(BuildContext context) {
    return BottomSheetWrapper(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SheetHandle(),
          const SizedBox(height: 16),
          const SheetTitle(title: "Sort"),
          const SizedBox(height: 16),
          ..._options.asMap().entries.map(
            (entry) => RadioOptionTile(
              label: entry.value,
              isSelected: _selected == entry.key,
              onTap: () {
                setState(() => _selected = entry.key);
                Future.delayed(
                  const Duration(milliseconds: 150),
                  () => Navigator.pop(context),
                );
              },
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}


import 'package:flutter/material.dart';
import 'package:totalx/features/users/presentation/widgets/search_field_widgets/search_field.dart';
import 'package:totalx/features/users/presentation/widgets/sort_widgets/sort_button.dart';

class SearchAndFilterRow extends StatelessWidget {
  final VoidCallback onSortTap;
  const SearchAndFilterRow({super.key, required this.onSortTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Row(
        children: [
          const Expanded(child: SearchField()),
          const SizedBox(width: 10),
          SortButton(onTap: onSortTap),
        ],
      ),
    );
  }
}


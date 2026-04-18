import 'package:flutter/material.dart';

class SearchField extends StatelessWidget {
  final ValueChanged<String>? onChanged;

  const SearchField({super.key, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.grey.shade400, width: 1),
      ),
      child: TextField(
        onChanged: onChanged,
        decoration: const InputDecoration(
          hintText: "search by name",
          hintStyle: TextStyle(color: Colors.grey),
          border: InputBorder.none,
          prefixIcon: Icon(Icons.search, color: Colors.black),
        ),
      ),
    );
  }
}

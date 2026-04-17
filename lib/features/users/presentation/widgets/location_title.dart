import 'package:flutter/material.dart';

class LocationTitle extends StatelessWidget {
  final String city;
  const LocationTitle({super.key, required this.city});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.location_on_rounded, size: 16, color: Colors.white),
        const SizedBox(width: 6),
        Text(city),
      ],
    );
  }
}
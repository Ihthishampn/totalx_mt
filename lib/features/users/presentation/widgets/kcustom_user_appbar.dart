import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:totalx/features/users/presentation/widgets/location_title.dart';

class UserAppBar extends StatelessWidget implements PreferredSizeWidget {
  const UserAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(69);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.light,
        statusBarColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      toolbarHeight: 69,
      title: const LocationTitle(city: "Nilambur"),
      titleTextStyle: const TextStyle(fontSize: 14, color: Colors.white),
    );
  }
}

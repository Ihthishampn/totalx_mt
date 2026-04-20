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
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
        statusBarColor: Colors.white,
      ),
      backgroundColor: Colors.black,
      toolbarHeight: 69,
    
      title: const LocationTitle(city: "Nilambur"),
    );
  }
}

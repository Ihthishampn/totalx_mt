import 'package:flutter/material.dart';
import 'package:totalx/core/utils/auth_preferences.dart';

class AuthRedirectButton extends StatelessWidget {
  final Widget destination;
  final String label;
  final bool popCurrentRoute;

  const AuthRedirectButton({
    super.key,
    required this.destination,
    this.label = 'Enter to User Screen',
    this.popCurrentRoute = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size.fromHeight(48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: () async {
          if (popCurrentRoute && Navigator.canPop(context)) {
            Navigator.of(context).pop();
          }

          await AuthPreferences.setIsLoggedIn(true);

          if (!context.mounted) return;

          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => destination),
            (route) => false,
          );
        },
        child: Text(label),
      ),
    );
  }
}

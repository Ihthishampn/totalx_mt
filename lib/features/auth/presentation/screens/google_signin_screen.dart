import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:totalx/core/utils/auth_preferences.dart';
import 'package:totalx/core/widgets/double_back_press_wrapper.dart';
import 'package:totalx/features/auth/presentation/provider/google_signin_provider.dart';
import 'package:totalx/features/users/presentation/screens/user_screen.dart';

class GoogleSignInScreen extends StatefulWidget {
  const GoogleSignInScreen({super.key});

  @override
  State<GoogleSignInScreen> createState() => _GoogleSignInScreenState();
}

class _GoogleSignInScreenState extends State<GoogleSignInScreen> {
  @override
  Widget build(BuildContext context) {
    return DoubleBackPressWrapper(
      message: 'Press back again to exit',
      child: Scaffold(
        backgroundColor: const Color(0xFFF6F8FB),
        appBar: AppBar(
          title: const Text('Authentication'),
          centerTitle: true,
          elevation: 0,
          titleTextStyle: TextStyle(
              fontWeight: FontWeight.bold, color: Colors.black, fontSize: 21),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Consumer<GoogleSignInProvider>(
                builder: (context, provider, child) {
                  return SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed: provider.isLoading
                          ? null
                          : () async {
                              final navigator = Navigator.of(context);
                              final result = await provider.signInWithGoogle();

                              if (result != null && mounted) {
                                await AuthPreferences.setIsLoggedIn(true);
                                navigator.pushAndRemoveUntil(
                                  MaterialPageRoute(
                                      builder: (_) => const UserScreen()),
                                  (route) => false,
                                );
                              }
                            },
                      icon: provider.isLoading
                          ? const SizedBox(
                              height: 18,
                              width: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(Icons.login),
                      label: const Text(
                        "Continue with Google",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1E88E5),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

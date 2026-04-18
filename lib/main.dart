import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:totalx/core/dio_client/dio_client.dart';
import 'package:totalx/core/env/env_config.dart';
import 'package:totalx/core/utils/auth_preferences.dart';
import 'package:totalx/features/auth/data/repo_impl/auth_repo_impl.dart';
import 'package:totalx/features/auth/presentation/provider/auth_provider.dart';
import 'package:totalx/features/auth/presentation/screens/login_screen.dart';
import 'package:totalx/features/users/data/repo_impl/user_repo_impl.dart';
import 'package:totalx/features/users/presentation/provider/user_provider.dart';
import 'package:totalx/features/users/presentation/screens/user_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  await AuthPreferences.init();

  await Supabase.initialize(
    url: EnvConfig.supabaseUrl,
    anonKey: EnvConfig.supabaseAnonKey,
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(AuthRepoImpl(DioClient())),
        ),
        ChangeNotifierProvider(create: (_) => UserProvider(UserRepoImpl())),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AuthPreferences.isLoggedIn()
          ? const UserScreen()
          : const LoginScreen(),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:totalx/features/auth/data/repo_impl/google_signin_repo_impl.dart';

class GoogleSignInProvider with ChangeNotifier {
  final GoogleSignInRepoImpl _repo = GoogleSignInRepoImpl();
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  Future<Map<String, dynamic>?> signInWithGoogle() async {
    _isLoading = true;
    notifyListeners();
    try {
      final result = await _repo.signInWithGoogle();
      return result;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}

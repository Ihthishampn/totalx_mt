import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:totalx/features/auth/domain/repo/google_signin_repo.dart';

class GoogleSignInRepoImpl implements GoogleSignInRepo {
  @override
  Future<Map<String, dynamic>?> signInWithGoogle() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
    if (googleUser == null) return null;

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final firebase_auth.AuthCredential credential =
        firebase_auth.GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final firebase_auth.UserCredential userCredential = await firebase_auth
        .FirebaseAuth.instance
        .signInWithCredential(credential);
    final firebase_auth.User? user = userCredential.user;
    if (user == null) return null;
//sa ve
    await Supabase.instance.client.from('auth_users').upsert({
      'id': user.uid,
      'email': user.email,
    });

    return {'uid': user.uid, 'email': user};
  }
}

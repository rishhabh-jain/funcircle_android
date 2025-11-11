import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

final _googleSignIn = GoogleSignIn(scopes: ['profile', 'email']);

Future<UserCredential?> googleSignInFunc() async {
  try {
    if (kIsWeb) {
      // Once signed in, return the UserCredential
      return await FirebaseAuth.instance.signInWithPopup(GoogleAuthProvider());
    }

    // Sign out first to ensure clean state
    await signOutWithGoogle().catchError((_) => null);

    print('DEBUG: Starting Google Sign-In...');

    // Sign in with Google (with timeout)
    final googleUser = await _googleSignIn.signIn().timeout(
      Duration(seconds: 30),
      onTimeout: () {
        print('ERROR: Google Sign-In timed out after 30 seconds');
        return null;
      },
    );

    if (googleUser == null) {
      print('DEBUG: Google Sign-In was cancelled or timed out');
      return null;
    }

    print('DEBUG: Google user signed in: ${googleUser.email}');

    // Get authentication tokens
    final auth = await googleUser.authentication.timeout(
      Duration(seconds: 10),
      onTimeout: () {
        print('ERROR: Getting Google authentication timed out');
        throw Exception('Authentication timeout');
      },
    );

    if (auth.idToken == null || auth.accessToken == null) {
      print('ERROR: Missing authentication tokens');
      return null;
    }

    print('DEBUG: Got authentication tokens, signing in to Firebase...');

    // Create Firebase credential
    final credential = GoogleAuthProvider.credential(
      idToken: auth.idToken,
      accessToken: auth.accessToken,
    );

    // Sign in to Firebase
    final userCredential = await FirebaseAuth.instance
        .signInWithCredential(credential)
        .timeout(
          Duration(seconds: 15),
          onTimeout: () {
            print('ERROR: Firebase sign-in timed out');
            throw Exception('Firebase authentication timeout');
          },
        );

    print('DEBUG: Successfully signed in to Firebase: ${userCredential.user?.uid}');
    return userCredential;

  } on FirebaseAuthException catch (e) {
    print('ERROR: FirebaseAuthException during Google Sign-In: ${e.code} - ${e.message}');
    rethrow;
  } catch (e, stackTrace) {
    print('ERROR: Exception during Google Sign-In: $e');
    print('Stack trace: $stackTrace');
    rethrow;
  }
}

Future signOutWithGoogle() => _googleSignIn.signOut();

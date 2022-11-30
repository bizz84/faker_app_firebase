import 'package:faker_app_firebase/google_client_id.dart';
import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authProvidersProvider = Provider<List<AuthProvider>>((ref) {
  return [
    EmailAuthProvider(),
    GoogleProvider(clientId: getGoogleClientId()),
  ];
});

final firebaseAuthProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});

final authStateChangesProvider = StreamProvider<User?>((ref) {
  return ref.watch(firebaseAuthProvider).authStateChanges();
});

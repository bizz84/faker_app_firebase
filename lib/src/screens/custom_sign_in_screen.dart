import 'package:faker_app_firebase/src/auth/providers.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CustomSignInScreen extends ConsumerWidget {
  const CustomSignInScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authProviders = ref.watch(authProvidersProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign in'),
      ),
      body: SignInScreen(
        providers: authProviders,
        actions: [
          AuthStateChangeAction<SignedIn>((context, state) {
            print('signed in');
            //context.goNamed(AppRoute.profile.name);
          }),
        ],
      ),
    );
  }
}

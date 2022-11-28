import 'package:faker_app_firebase/src/auth/providers.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CustomProfileScreen extends ConsumerWidget {
  const CustomProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authProviders = ref.watch(authProvidersProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: ProfileScreen(
        providers: authProviders,
        actions: [
          SignedOutAction((context) {
            print('signed out');
            //context.goNamed(AppRoute.signIn.name);
          }),
        ],
      ),
    );
  }
}

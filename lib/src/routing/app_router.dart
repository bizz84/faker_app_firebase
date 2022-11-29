import 'package:faker_app_firebase/src/auth/providers.dart';
import 'package:faker_app_firebase/src/routing/go_router_refresh_stream.dart';
import 'package:faker_app_firebase/src/screens/custom_profile_screen.dart';
import 'package:faker_app_firebase/src/screens/custom_sign_in_screen.dart';
import 'package:faker_app_firebase/src/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

enum AppRoute {
  signIn,
  home,
  profile,
}

final goRouterProvider = Provider<GoRouter>((ref) {
  final firebaseAuth = ref.watch(firebaseAuthProvider);
  return GoRouter(
    initialLocation: '/sign-in',
    debugLogDiagnostics: true,
    redirect: (context, state) {
      final isLoggedIn = firebaseAuth.currentUser != null;
      if (isLoggedIn) {
        if (state.subloc.startsWith('/sign-in')) {
          return '/home';
        }
      } else {
        if (state.subloc.startsWith('/home')) {
          return '/sign-in';
        }
      }
      return null;
    },
    // needed?
    refreshListenable: GoRouterRefreshStream(firebaseAuth.authStateChanges()),
    routes: [
      GoRoute(
        path: '/sign-in',
        name: AppRoute.signIn.name,
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          child: const CustomSignInScreen(),
        ),
      ),
      GoRoute(
        path: '/home',
        name: AppRoute.home.name,
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          child: const HomeScreen(),
        ),
        routes: [
          GoRoute(
            path: 'profile',
            name: AppRoute.profile.name,
            pageBuilder: (context, state) => MaterialPage(
              key: state.pageKey,
              fullscreenDialog: true,
              child: const CustomProfileScreen(),
            ),
          ),
        ],
      ),
    ],
  );
});

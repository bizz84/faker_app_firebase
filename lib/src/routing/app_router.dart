import 'package:faker_app_firebase/src/auth/providers.dart';
import 'package:faker_app_firebase/src/routing/go_router_refresh_stream.dart';
import 'package:faker_app_firebase/src/screens/custom_profile_screen.dart';
import 'package:faker_app_firebase/src/screens/custom_sign_in_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

enum AppRoute { signIn, profile }

final goRouterProvider = Provider<GoRouter>((ref) {
  final firebaseAuth = ref.watch(firebaseAuthProvider);
  return GoRouter(
    initialLocation: '/sign-in',
    debugLogDiagnostics: true,
    redirect: (context, state) {
      final isLoggedIn = firebaseAuth.currentUser != null;
      if (isLoggedIn) {
        if (state.subloc == '/sign-in') {
          return '/profile';
        }
      } else {
        if (state.subloc.startsWith('/profile')) {
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
        pageBuilder: (context, state) => NoTransitionPage(
          key: state.pageKey,
          child: const CustomSignInScreen(),
        ),
      ),
      GoRoute(
        path: '/profile',
        name: AppRoute.profile.name,
        pageBuilder: (context, state) => NoTransitionPage(
          key: state.pageKey,
          child: const CustomProfileScreen(),
        ),
      ),
    ],
  );
});

import 'package:faker_app_firebase/firebase_options.dart';
import 'package:faker_app_firebase/google_client_id.dart';
import 'package:faker_app_firebase/src/auth/providers.dart';
import 'package:faker_app_firebase/src/routing/app_router.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseUIAuth.configureProviders([
    GoogleProvider(clientId: getGoogleClientId()),
  ]);
  final container = ProviderContainer();
  // await until auth state is determined
  // this will prevent unnecessary redirects inside GoRouter when the app starts
  await container.read(authStateChangesProvider.future);
  runApp(UncontrolledProviderScope(container: container, child: const MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goRouter = ref.watch(goRouterProvider);
    return MaterialApp.router(
      routerConfig: goRouter,
      theme: ThemeData(primarySwatch: Colors.indigo),
    );
  }
}

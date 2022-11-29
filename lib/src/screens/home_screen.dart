import 'package:faker_app_firebase/src/data/auth_providers.dart';
import 'package:faker_app_firebase/src/common_widgets/error_message_widget.dart';
import 'package:faker_app_firebase/src/data/firestore_database.dart';
import 'package:faker_app_firebase/src/models/job.dart';
import 'package:faker_app_firebase/src/routing/app_router.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:faker/faker.dart' hide Job;
import 'package:go_router/go_router.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Jobs'), actions: [
        IconButton(
          icon: const Icon(Icons.person),
          onPressed: () => context.goNamed(AppRoute.profile.name),
        )
      ]),
      body: Consumer(
        builder: (context, ref, child) {
          final jobsQuery = ref.watch(jobsQueryProvider);
          return FirestoreListView<Job>(
            query: jobsQuery,
            itemBuilder: (context, jobSnapshot) {
              return ListTile(
                title: Text(jobSnapshot.data().jobName),
                dense: true,
              );
            },
            errorBuilder: (context, error, stackTrace) =>
                Center(child: ErrorMessageWidget(error.toString())),
            loadingBuilder: (context) =>
                const Center(child: CircularProgressIndicator()),
            emptyBuilder: (context) => const SizedBox.shrink(),
            // TODO: pageSize, pagination etc
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          final user = ref.read(currentUserProvider);
          final faker = Faker();
          final title = faker.job.title();
          ref.read(firestoreDatabaseProvider).addJob(user!.uid, title);
        },
      ),
    );
  }
}

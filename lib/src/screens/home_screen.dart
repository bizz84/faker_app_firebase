import 'package:faker_app_firebase/src/auth/providers.dart';
import 'package:faker_app_firebase/src/common_widgets/async_value_widget.dart';
import 'package:faker_app_firebase/src/data/firestore_database.dart';
import 'package:faker_app_firebase/src/models/job.dart';
import 'package:faker_app_firebase/src/routing/app_router.dart';
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
          final jobsAsync = ref.watch(jobsProvider);
          // TODO: Use Firestore UI
          return AsyncValueWidget<List<Job>>(
            value: jobsAsync,
            data: (jobs) => ListView.separated(
              itemBuilder: (context, index) {
                final job = jobs[index];
                return ListTile(
                  title: Text(job.jobName),
                  dense: true,
                );
              },
              itemCount: jobs.length,
              separatorBuilder: (context, index) => const Divider(),
            ),
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

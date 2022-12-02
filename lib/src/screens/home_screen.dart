import 'package:faker_app_firebase/src/data/auth_providers.dart';
import 'package:faker_app_firebase/src/data/firestore_repository.dart';
import 'package:faker_app_firebase/src/data/job.dart';
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
      appBar: AppBar(title: const Text('My CV'), actions: [
        IconButton(
          icon: const Icon(Icons.person),
          onPressed: () => context.goNamed(AppRoute.profile.name),
        )
      ]),
      body: const JobsListView(),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          final user = ref.read(authStateChangesProvider).value;
          final faker = Faker();
          final title = faker.job.title();
          final company = faker.company.name();
          ref
              .read(firestoreRepositoryProvider)
              .addJob(user!.uid, title, company);
        },
      ),
    );
  }
}

class JobsListView extends ConsumerWidget {
  const JobsListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final jobsQuery = ref.watch(jobsQueryProvider);
    if (jobsQuery == null) {
      return const SizedBox.shrink();
    }
    return FirestoreQueryBuilder<Job>(
      query: jobsQuery,
      pageSize: 10,
      builder: (context, snapshot, child) {
        if (snapshot.docs.isEmpty) {
          return Center(
              child: Text('No Data',
                  style: Theme.of(context).textTheme.headline5));
        }
        if (snapshot.isFetching) {
          // TODO
        }
        if (snapshot.hasError) {
          // TODO
        }
        return ListView.builder(
          itemCount: snapshot.docs.length,
          itemBuilder: (context, index) {
            // if we reached the end of the currently obtained items, we try to
            // obtain more items
            if (snapshot.hasMore && index + 1 == snapshot.docs.length) {
              // Tell FirestoreQueryBuilder to try to obtain more items.
              // It is safe to call this function from within the build method.
              snapshot.fetchMore();
            }
            final job = snapshot.docs[index].data();
            final jobId = snapshot.docs[index].id;

            return Dismissible(
              key: Key(jobId),
              background: Container(color: Colors.red),
              direction: DismissDirection.endToStart,
              onDismissed: (direction) {
                final user = ref.read(authStateChangesProvider).value;
                ref
                    .read(firestoreRepositoryProvider)
                    .deleteJob(user!.uid, jobId);
              },
              child: ListTile(
                title: Text(job.title),
                subtitle: Text(job.company),
                trailing: job.createdAt != null
                    ? Text(job.createdAt.toString(),
                        style: Theme.of(context).textTheme.caption)
                    : null,
                dense: true,
              ),
            );
          },
        );
      },
    );

    // return FirestoreListView<Job>(
    //   query: jobsQuery,
    //   pageSize: 10,
    //   itemBuilder: (context, jobSnapshot) {
    //     final job = jobSnapshot.data();
    //     return ListTile(
    //       title: Text(job.title),
    //       dense: true,
    //     );
    //   },
    //   errorBuilder: (context, error, stackTrace) =>
    //       Center(child: ErrorMessageWidget(error.toString())),
    //   loadingBuilder: (context) =>
    //       const Center(child: CircularProgressIndicator()),
    //   emptyBuilder: (context) => const SizedBox.shrink(),
    //   // TODO: pageSize, pagination etc
    // );
  }
}

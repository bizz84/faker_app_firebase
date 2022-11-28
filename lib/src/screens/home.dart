import 'package:faker_app_firebase/src/auth/providers.dart';
import 'package:faker_app_firebase/src/data/firestore_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:faker/faker.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView.separated(
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('Item $index'),
            trailing: const Text('\$100'),
          );
        },
        itemCount: 10,
        separatorBuilder: (context, index) {
          return const Divider();
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

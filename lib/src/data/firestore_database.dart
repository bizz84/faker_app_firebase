import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:faker_app_firebase/src/auth/providers.dart';
import 'package:faker_app_firebase/src/models/job.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FirestoreDatabase {
  FirestoreDatabase(this._firestore);
  final FirebaseFirestore _firestore;

  Future<void> addJob(String uid, String jobName) async {
    await _firestore.collection('users/$uid/jobs').add({
      'jobName': jobName,
    });
  }

  // TODO: Show get as well

  Stream<List<Job>> jobs(String uid) {
    return _firestore.collection('users/$uid/jobs').snapshots().map(
          (snapshot) => snapshot.docs
              .map((snapshot) => Job(
                    id: snapshot.id,
                    jobName: snapshot.data()['jobName'],
                  ))
              .toList(),
        );
  }
}

final firestoreDatabaseProvider = Provider<FirestoreDatabase>((ref) {
  return FirestoreDatabase(FirebaseFirestore.instance);
});

final jobsProvider = StreamProvider.autoDispose<List<Job>>((ref) {
  final database = ref.watch(firestoreDatabaseProvider);
  final user = ref.watch(authStateChangesProvider).value;
  if (user == null) {
    throw AssertionError('User is null');
  }
  return database.jobs(user.uid);
});

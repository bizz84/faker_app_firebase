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

  Query<Job> jobsQuery(String uid) {
    // TODO: order by
    return _firestore.collection('users/$uid/jobs').withConverter<Job>(
          fromFirestore: (doc, _) {
            final data = doc.data();
            return Job(
              id: doc.id,
              jobName: data != null ? data['jobName'] : '',
            );
          },
          toFirestore: (job, options) => {'jobName': job.jobName},
        );
  }

  // TODO: Show get as well
  Stream<List<Job>> jobs(String uid) {
    // TODO: order by
    final ref = _firestore.collection('users/$uid/jobs');
    return ref.snapshots().map(
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
  final user = ref.watch(authStateChangesProvider).value;
  if (user == null) {
    throw AssertionError('Can\'t query jobs when the user is null');
  }
  final database = ref.watch(firestoreDatabaseProvider);
  return database.jobs(user.uid);
});

final jobsQueryProvider = Provider.autoDispose<Query<Job>>((ref) {
  final user = ref.watch(authStateChangesProvider).value;
  if (user == null) {
    throw AssertionError('Can\'t query jobs when the user is null');
  }
  final database = ref.watch(firestoreDatabaseProvider);
  return database.jobsQuery(user.uid);
});

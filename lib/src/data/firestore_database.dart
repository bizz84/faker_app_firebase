import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:faker_app_firebase/src/data/auth_providers.dart';
import 'package:faker_app_firebase/src/models/job.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FirestoreDatabase {
  FirestoreDatabase(this._firestore);
  final FirebaseFirestore _firestore;

  Future<void> addJob(String uid, String title) =>
      _firestore.collection('users/$uid/jobs').add({
        'title': title,
        'createdAt': FieldValue.serverTimestamp(),
      });

  Future<void> deleteJob(String uid, String jobId) =>
      _firestore.doc('users/$uid/jobs/$jobId').delete();

  Query<Job> jobsQuery(String uid) {
    final collectionRef = _firestore
        .collection('users/$uid/jobs')
        .orderBy('createdAt', descending: true);
    return collectionRef.withConverter<Job>(
      fromFirestore: (doc, _) {
        final data = doc.data();
        return Job.fromMap(data!);
      },
      toFirestore: (job, options) => job.toMap(),
    );
  }

  // TODO: Show get as well
  Stream<List<Job>> jobs(String uid) {
    final collectionRef =
        _firestore.collection('users/$uid/jobs').orderBy('createdAt');
    return collectionRef.snapshots().map(
          (snapshot) => snapshot.docs
              .map((snapshot) => Job.fromMap(snapshot.data()))
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

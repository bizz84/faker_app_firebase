import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:faker_app_firebase/src/data/auth_providers.dart';
import 'package:faker_app_firebase/src/data/job.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FirestoreRepository {
  FirestoreRepository(this._firestore);
  final FirebaseFirestore _firestore;

  // create

  Future<void> addJob(String uid, String title, String company) =>
      _firestore.collection('users/$uid/jobs').add({
        'title': title,
        'company': company,
        // Note: Using serverTimestamp will cause onSnapshot to fire twice
        // First cache hit, then update from the server
        // https://stackoverflow.com/questions/71724670/why-fieldvalue-servertimestamp-return-null-value-from-first-snapshot/71731076#71731076
        'createdAt': FieldValue.serverTimestamp(),
      });

  Future<void> updateJob(
          String uid, String jobId, String title, String company) =>
      _firestore.doc('users/$uid/jobs/$jobId').update({
        'title': title,
        'company': company,
      });

  // delete
  Future<void> deleteJob(String uid, String jobId) =>
      _firestore.doc('users/$uid/jobs/$jobId').delete();

  // read
  Query<Job> jobsQuery(String uid) {
    final collectionRef = _firestore
        .collection('users/$uid/jobs')
        .orderBy('createdAt', descending: true);
    return collectionRef.withConverter<Job>(
      fromFirestore: (doc, _) {
        final data = doc.data();
        return Job.fromMap(data!);
      },
      toFirestore: (doc, options) => doc.toMap(),
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

final firestoreRepositoryProvider = Provider<FirestoreRepository>((ref) {
  return FirestoreRepository(FirebaseFirestore.instance);
});

final jobsQueryProvider = Provider.autoDispose<Query<Job>?>((ref) {
  final user = ref.watch(authStateChangesProvider).value;
  if (user == null) {
    return null;
    //throw AssertionError('Can\'t query user data when the user is null');
  }
  final database = ref.watch(firestoreRepositoryProvider);
  return database.jobsQuery(user.uid);
});

final jobsProvider = StreamProvider.autoDispose<List<Job>>((ref) {
  final user = ref.watch(authStateChangesProvider).value;
  if (user == null) {
    return const Stream.empty();
  }
  final database = ref.watch(firestoreRepositoryProvider);
  return database.jobs(user.uid);
});

import 'package:cloud_firestore/cloud_firestore.dart';

class Job {
  Job({required this.title, required this.createdAt});
  //final String id;
  final String title;
  final DateTime? createdAt;

  factory Job.fromMap(Map<String, dynamic> map) {
    final createdAt = map['createdAt'];
    return Job(
      title: map['title'] as String,
      // https://stackoverflow.com/a/71731076/436422
      createdAt: createdAt != null ? (createdAt as Timestamp).toDate() : null,
    );
  }

  Map<String, dynamic> toMap() => {
        'title': title,
        if (createdAt != null) 'createdAt': Timestamp.fromDate(createdAt!),
      };
}

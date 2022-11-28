class Job {
  Job({required this.id, required this.jobName});
  final String id;
  final String jobName;

  factory Job.fromMap(Map<String, dynamic> map) {
    return Job(
      id: map['id'] as String,
      jobName: map['jobName'] as String,
    );
  }
}

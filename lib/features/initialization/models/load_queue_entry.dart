class LoadQueueEntry {
  final String message;
  final Future<dynamic> Function() task;

  LoadQueueEntry({required this.message, required this.task});
}

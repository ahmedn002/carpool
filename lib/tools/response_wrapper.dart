class FirebaseResponseWrapper<T> {
  final T data;
  final String? message;
  final bool hasError;

  FirebaseResponseWrapper({
    required this.data,
    this.message,
    required this.hasError,
  });
}

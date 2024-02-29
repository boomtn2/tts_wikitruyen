class ErrorNetWork {
  int code;
  String message;
  String description;
  ErrorNetWork({
    this.code = 0,
    this.message = '',
    this.description = '',
  });

  @override
  String toString() =>
      'ErrorNetWork(code: $code, message: $message, description: $description)';
}

class ErrorModel {
  final String message;

  ErrorModel(this.message);

  Map<String, dynamic> get toJson => {
        "error": message.replaceAll("Exception: ", ""),
      };
}

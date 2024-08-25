extension RemoveException on Object {
  String get ex => toString().replaceAll("Exception: ", "");
}

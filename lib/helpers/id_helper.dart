import 'package:uuid/uuid.dart';

class IdHelper {
  static String get createID => Uuid().v4().toUpperCase();
}

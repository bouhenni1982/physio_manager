import 'dart:math';

class IdGenerator {
  static final Random _rand = Random();

  static String newId() {
    final ts = DateTime.now().microsecondsSinceEpoch;
    final r = _rand.nextInt(1 << 20);
    return '$ts$r';
  }
}

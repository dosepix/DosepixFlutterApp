// arg describes the operation mode
// next holds the next route to be executed
class ModeArguments {
  final int arg;
  final String next;
  ModeArguments(this.arg, this.next);
}

const int MODE_NONE = -1;
const int MODE_MEASUREMENT = 1;
const int MODE_ANALYZE = 2;

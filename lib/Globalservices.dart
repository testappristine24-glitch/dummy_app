class GlobalService {
  static final GlobalService _instance = GlobalService._internal();
  factory GlobalService() => _instance;
  GlobalService._internal() {
    hasLaunched = false;
  }

  // run() {
  //   hasLaunched = false;
  // }

  bool hasLaunched = false;
}

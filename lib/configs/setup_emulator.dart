import 'package:firebase_auth/firebase_auth.dart';

void setupEmulators() async {
  try {
    await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
  } catch (e) {
    // ignore: avoid_print
    print(e);
  }
}

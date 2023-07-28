
import 'flutter_contacts_plus_platform_interface.dart';

class FlutterContactsPlus {
  Future<String?> getPlatformVersion() {
    return FlutterContactsPlusPlatform.instance.getPlatformVersion();
  }
}

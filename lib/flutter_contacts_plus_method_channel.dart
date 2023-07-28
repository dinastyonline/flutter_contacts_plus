import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'flutter_contacts_plus_platform_interface.dart';

/// An implementation of [FlutterContactsPlusPlatform] that uses method channels.
class MethodChannelFlutterContactsPlus extends FlutterContactsPlusPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_contacts_plus');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}

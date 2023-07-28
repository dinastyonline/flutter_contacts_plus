import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flutter_contacts_plus_method_channel.dart';

abstract class FlutterContactsPlusPlatform extends PlatformInterface {
  /// Constructs a FlutterContactsPlusPlatform.
  FlutterContactsPlusPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterContactsPlusPlatform _instance = MethodChannelFlutterContactsPlus();

  /// The default instance of [FlutterContactsPlusPlatform] to use.
  ///
  /// Defaults to [MethodChannelFlutterContactsPlus].
  static FlutterContactsPlusPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutterContactsPlusPlatform] when
  /// they register themselves.
  static set instance(FlutterContactsPlusPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}

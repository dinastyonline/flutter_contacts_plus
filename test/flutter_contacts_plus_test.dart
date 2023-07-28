import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_contacts_plus/flutter_contacts_plus.dart';
import 'package:flutter_contacts_plus/flutter_contacts_plus_platform_interface.dart';
import 'package:flutter_contacts_plus/flutter_contacts_plus_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFlutterContactsPlusPlatform
    with MockPlatformInterfaceMixin
    implements FlutterContactsPlusPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final FlutterContactsPlusPlatform initialPlatform = FlutterContactsPlusPlatform.instance;

  test('$MethodChannelFlutterContactsPlus is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFlutterContactsPlus>());
  });

  test('getPlatformVersion', () async {
    FlutterContactsPlus flutterContactsPlusPlugin = FlutterContactsPlus();
    MockFlutterContactsPlusPlatform fakePlatform = MockFlutterContactsPlusPlatform();
    FlutterContactsPlusPlatform.instance = fakePlatform;

    expect(await flutterContactsPlusPlugin.getPlatformVersion(), '42');
  });
}

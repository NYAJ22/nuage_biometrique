import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nuage_biometrique/nuage_biometrique_method_channel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  MethodChannelNuageBiometrique platform = MethodChannelNuageBiometrique();
  const MethodChannel channel = MethodChannel('nuage_biometrique');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      channel,
      (MethodCall methodCall) async {
        return '42';
      },
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}

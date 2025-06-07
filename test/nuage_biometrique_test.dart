import 'package:flutter_test/flutter_test.dart';
import 'package:nuage_biometrique/nuage_biometrique.dart';
import 'package:nuage_biometrique/nuage_biometrique_platform_interface.dart';
import 'package:nuage_biometrique/nuage_biometrique_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockNuageBiometriquePlatform
    with MockPlatformInterfaceMixin
    implements NuageBiometriquePlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final NuageBiometriquePlatform initialPlatform = NuageBiometriquePlatform.instance;

  test('$MethodChannelNuageBiometrique is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelNuageBiometrique>());
  });

  test('getPlatformVersion', () async {
    NuageBiometrique nuageBiometriquePlugin = NuageBiometrique();
    MockNuageBiometriquePlatform fakePlatform = MockNuageBiometriquePlatform();
    NuageBiometriquePlatform.instance = fakePlatform;

    expect(await nuageBiometriquePlugin.getPlatformVersion(), '42');
  });
}

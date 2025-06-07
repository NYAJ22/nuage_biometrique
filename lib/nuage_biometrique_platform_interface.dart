import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'nuage_biometrique_method_channel.dart';

abstract class NuageBiometriquePlatform extends PlatformInterface {
  /// Constructs a NuageBiometriquePlatform.
  NuageBiometriquePlatform() : super(token: _token);

  static final Object _token = Object();

  static NuageBiometriquePlatform _instance = MethodChannelNuageBiometrique();

  /// The default instance of [NuageBiometriquePlatform] to use.
  ///
  /// Defaults to [MethodChannelNuageBiometrique].
  static NuageBiometriquePlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [NuageBiometriquePlatform] when
  /// they register themselves.
  static set instance(NuageBiometriquePlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}

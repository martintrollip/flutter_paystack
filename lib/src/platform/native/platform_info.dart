import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_paystack/src/platform/platform_info_interface.dart';

Future<PlatformInfoInterface> getPlatformInfo(
  String version,
  MethodChannel channel,
) async {
  return PlatformInfo.fromMethodChannel(version, channel);
}

/// Holds data that's different on Android and iOS
class PlatformInfo implements PlatformInfoInterface {
  PlatformInfo._({
    required this.userAgent,
    required this.paystackBuild,
    required this.deviceId,
  });

  @override
  final String deviceId;

  @override
  final String paystackBuild;

  @override
  final String userAgent;

  static Future<PlatformInfoInterface> fromMethodChannel(
      String version, MethodChannel channel) async {
    final platform = Platform.operatingSystem;
    String userAgent = "${platform}_Paystack_$version";
    String deviceId = await channel.invokeMethod('getDeviceId') ?? "";
    return PlatformInfo._(
      userAgent: userAgent,
      paystackBuild: version,
      deviceId: deviceId,
    );
  }

  @override
  String toString() {
    return '[userAgent = $userAgent, paystackBuild = $paystackBuild, deviceId = $deviceId]';
  }
}

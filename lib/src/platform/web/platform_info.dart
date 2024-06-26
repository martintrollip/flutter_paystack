import 'dart:html' as html;

import 'package:flutter/services.dart';
import 'package:flutter_paystack/src/platform/platform_info_interface.dart';
import 'package:uuid/uuid.dart';

Future<PlatformInfoInterface> getPlatformInfo(
  String version,
  MethodChannel _,
) async {
  return PlatformInfo.from(version);
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

  static Future<PlatformInfo> from(String version) async {
    final platform = 'web';
    String userAgent = "${platform}_Paystack_$version";
    String deviceId = await getWebDeviceId();
    return PlatformInfo._(
      userAgent: userAgent,
      paystackBuild: version,
      deviceId: deviceId,
    );
  }

  /// Generates a unique device id for web and stores it in local storage
  ///
  /// If the device id is already stored, it returns the stored device id
  ///
  /// It acts as a pseudo-device ID for the duration of the interaction.
  /// This ID will persist across sessions but not across browsers or devices,
  /// and it can be cleared by the user (e.g., by clearing browser data).
  static String getWebDeviceId() {
    String? deviceId = html.window.localStorage['deviceId'];

    if (deviceId == null) {
      deviceId = Uuid().v4();
      html.window.localStorage['deviceId'] = deviceId;
    }

    return deviceId;
  }

  @override
  String toString() {
    return '[userAgent = $userAgent, paystackBuild = $paystackBuild, deviceId = $deviceId]';
  }
}

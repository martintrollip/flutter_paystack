import 'dart:io';
import 'dart:html' as html;

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:uuid/uuid.dart';

/// Holds data that's different on Android and iOS
class PlatformInfo {
  final String userAgent;
  final String paystackBuild;
  final String deviceId;

  static Future<PlatformInfo> fromMethodChannel(MethodChannel channel) async {
    // TODO: Update for every new versions.
    final pluginVersion = "2.0.0";

    final platform = kIsWeb ? 'web' : Platform.operatingSystem;
    String userAgent = "${platform}_Paystack_$pluginVersion";
    String deviceId = await getDeviceId(channel);
    return PlatformInfo._(
      userAgent: userAgent,
      paystackBuild: pluginVersion,
      deviceId: deviceId,
    );
  }

  static Future<String> getDeviceId(MethodChannel channel) async {
    if (kIsWeb) {
      return getWebDeviceId();
    }
    return await channel.invokeMethod('getDeviceId') ?? "";
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

  const PlatformInfo._({
    required String userAgent,
    required String paystackBuild,
    required String deviceId,
  })  : userAgent = userAgent,
        paystackBuild = paystackBuild,
        deviceId = deviceId;

  @override
  String toString() {
    return '[userAgent = $userAgent, paystackBuild = $paystackBuild, deviceId = $deviceId]';
  }
}

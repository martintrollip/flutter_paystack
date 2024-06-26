import 'package:flutter_paystack/src/platform/paystack_stub.dart'
    if (dart.library.io) 'native/platform_info.dart'
    if (dart.library.js) 'web/platform_info.dart';
import 'package:flutter/services.dart';

/// An abstract class for Paystack to be implemented by the platform
abstract class PlatformInfoInterface {
  static final pluginVersion = "2.0.0"; // TODO: Update for every new versions.

  final String userAgent;
  final String paystackBuild;
  final String deviceId;

  PlatformInfoInterface({
    required this.userAgent,
    required this.paystackBuild,
    required this.deviceId,
  });

  static Future<PlatformInfoInterface> fromMethodChannel(
          MethodChannel channel) =>
      getPlatformInfo(
        pluginVersion,
        channel,
      );
}

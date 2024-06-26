import 'package:flutter/services.dart';
import 'package:flutter_paystack/src/platform/paystack_interface.dart';
import 'package:flutter_paystack/src/platform/platform_info_interface.dart';

/// Stub for Paystack
PaystackInterface getPaystack(String publicKey) =>
    throw UnsupportedError('Cannot create a PaystackInterface instance');

/// Stub for Platform info
Future<PlatformInfoInterface> getPlatformInfo(
  String version,
  MethodChannel channel,
) {
  throw UnsupportedError('Cannot create a PlatformInfoInterface instance');
}

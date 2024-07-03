import 'package:flutter/widgets.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:flutter_paystack/src/platform/paystack_stub.dart'
    if (dart.library.io) 'native/paystack.dart'
    if (dart.library.js) 'web/paystack.dart';

typedef OnSuccess = void Function({
  String? status,
  String? reference,
  String? message,
});

typedef OnLoad = void Function({
  String? id,
  dynamic customer,
  String? accessCode,
});

typedef OnError = void Function({String? message});

typedef OnCancel = void Function();

/// An abstract class for Paystack to be implemented by the platform
abstract class PaystackInterface {
  factory PaystackInterface(String publicKey) => getPaystack(publicKey);

  void inlinePopup({
    required Charge charge,
    String? label,
    OnSuccess? onSuccess,
    OnLoad? onLoad,
    OnError? onError,
    OnCancel? onCancel,
  });

  Future<CheckoutResponse> chargeCard({
    required BuildContext context,
    required Charge charge,
  });

  Future<CheckoutResponse> checkout(
    BuildContext context, {
    required Charge charge,
    required CheckoutMethod method,
    required bool fullscreen,
    bool hideEmail = false,
    bool hideAmount = false,
    Widget? logo,
  });
}

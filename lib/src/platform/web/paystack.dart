import 'dart:convert';
import 'dart:js_util' as utils;

import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_paystack/src/common/paystack.dart';
import 'package:flutter_paystack/src/models/charge.dart';
import 'package:flutter_paystack/src/models/checkout_response.dart';
import 'package:flutter_paystack/src/platform/paystack_interface.dart';
import 'package:flutter_paystack/src/platform/web/interop/paystack_pop.dart';
import 'package:js/js.dart' as js;

PaystackInterface getPaystack(String publicKey) => Paystack(publicKey);

class Paystack implements PaystackInterface {
  const Paystack(this.publicKey);

  final String publicKey;

  @override
  void inlinePopup({
    required Charge charge,
    String? label,
    void Function({
      String? status,
      String? reference,
      String? message,
    })? onSuccess,
    void Function({
      String? id,
      dynamic customer,
      String? accessCode,
    })? onLoad,
    void Function({String? message})? onError,
    void Function()? onCancel,
  }) {
    assert(
      charge.email != null && charge.reference != null,
      'Charge email and reference must not be null',
    );

    var meta = <String, dynamic>{};
    if (charge.metadata != null) {
      meta = jsonDecode(charge.metadata!);
    }

    final paystack = PaystackPop();
    paystack.newTransaction(PaystackTransactionOptions(
      key: publicKey,
      email: charge.email!,
      amount: charge.amount.toString(),
      currency: charge.currency,
      label: label,
      ref: charge.reference!,
      metadata: utils.jsify(meta),
      channels: ['card'],
      onSuccess: js.allowInterop(
        (PaymentSuccessResponse response) => onSuccess?.call(
          status: response.status,
          reference: response.reference,
          message: response.message,
        ),
      ),
      onLoad: js.allowInterop(
        (PaymentLoadResponse response) => onLoad?.call(
          id: response.id,
          customer: response.customer,
          accessCode: response.accessCode,
        ),
      ),
      onError: js.allowInterop(
        (PaymentErrorResponse response) =>
            onError?.call(message: response.message),
      ),
      onCancel: js.allowInterop(
        () => onCancel?.call(),
      ),
    ));
  }

  @override
  Future<CheckoutResponse> chargeCard({
    required BuildContext context,
    required Charge charge,
  }) async {
    debugPrint('.chargeCard not implemented for web');
    return Future.value(CheckoutResponse.defaults());
  }

  @override
  Future<CheckoutResponse> checkout(
    BuildContext context, {
    required Charge charge,
    required CheckoutMethod method,
    required bool fullscreen,
    bool hideEmail = false,
    bool hideAmount = false,
    Widget? logo,
  }) {
    debugPrint('.checkout not implemented for web');
    return Future.value(CheckoutResponse.defaults());
  }
}

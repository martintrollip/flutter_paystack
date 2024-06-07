import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_paystack/src/common/paystack.dart';
import 'package:flutter_paystack/src/models/charge.dart';
import 'package:flutter_paystack/src/models/checkout_response.dart';
import 'package:flutter_paystack/src/platform/paystack_interface.dart';

PaystackInterface getPaystack(String publicKey) => Paystack(publicKey);

class Paystack implements PaystackInterface {
  final String publicKey;

  Paystack(this.publicKey);

  @override
  Future<CheckoutResponse> chargeCard(
      {required BuildContext context, required Charge charge}) {
    // TODO: implement chargeCard
    throw UnimplementedError();
  }

  @override
  Future<CheckoutResponse> checkout(BuildContext context,
      {required Charge charge,
      required CheckoutMethod method,
      required bool fullscreen,
      bool hideEmail = false,
      bool hideAmount = false,
      Widget? logo}) {
    // TODO: implement checkout
    throw UnimplementedError();
  }
}

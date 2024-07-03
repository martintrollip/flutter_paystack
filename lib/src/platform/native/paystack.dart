import 'package:flutter/material.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:flutter_paystack/src/api/service/bank_service.dart';
import 'package:flutter_paystack/src/api/service/card_service.dart';
import 'package:flutter_paystack/src/common/my_strings.dart';
import 'package:flutter_paystack/src/common/string_utils.dart';
import 'package:flutter_paystack/src/platform/paystack_interface.dart';
import 'package:flutter_paystack/src/transaction/card_transaction_manager.dart';
import 'package:flutter_paystack/src/widgets/checkout/checkout_widget.dart';

PaystackInterface getPaystack(String publicKey) => Paystack(publicKey);

class Paystack implements PaystackInterface {
  const Paystack(this.publicKey);

  final String publicKey;

  @override
  Future<CheckoutResponse> chargeCard(
      {required BuildContext context, required Charge charge}) {
    return new CardTransactionManager(
            service: CardService(),
            charge: charge,
            context: context,
            publicKey: publicKey)
        .chargeCard();
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
  }) async {
    assert(() {
      _validateChargeAndKey(charge);
      switch (method) {
        case CheckoutMethod.card:
          if (charge.accessCode == null && charge.reference == null) {
            throw new ChargeException(Strings.noAccessCodeReference);
          }
          break;
        case CheckoutMethod.bank:
        case CheckoutMethod.selectable:
          if (charge.accessCode == null) {
            throw new ChargeException('Pass an accesscode');
          }
          break;
      }
      return true;
    }());

    CheckoutResponse? response = await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => new CheckoutWidget(
        publicKey: publicKey,
        bankService: BankService(),
        cardsService: CardService(),
        method: method,
        charge: charge,
        fullscreen: fullscreen,
        logo: logo,
        hideAmount: hideAmount,
        hideEmail: hideEmail,
      ),
    );
    return response == null ? CheckoutResponse.defaults() : response;
  }

  _validateChargeAndKey(Charge charge) {
    if (charge.amount.isNegative) {
      throw new InvalidAmountException(charge.amount);
    }
    if (!StringUtils.isValidEmail(charge.email)) {
      throw new InvalidEmailException(charge.email);
    }
  }

  @override
  void inlinePopup({
    required Charge charge,
    String? label,
    OnSuccess? onSuccess,
    OnLoad? onLoad,
    OnError? onError,
    OnCancel? onCancel,
  }) {
    debugPrint('inlinePopup not implemented for native');
  }
}

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_paystack/src/common/exceptions.dart';
import 'package:flutter_paystack/src/common/utils.dart';
import 'package:flutter_paystack/src/models/card.dart';
import 'package:flutter_paystack/src/models/charge.dart';
import 'package:flutter_paystack/src/models/checkout_response.dart';
import 'package:flutter_paystack/src/platform/paystack_interface.dart';
import 'package:flutter_paystack/src/platform/platform_info_interface.dart';

class PaystackPlugin {
  bool _sdkInitialized = false;
  String _publicKey = "";
  static late PlatformInfoInterface platformInfo;

  /// Initialize the Paystack object. It should be called as early as possible
  /// (preferably in initState() of the Widget.
  ///
  /// [publicKey] - your paystack public key. This is mandatory
  ///
  /// use [checkout] and you want this plugin to initialize the transaction for you.
  /// Please check [checkout] for more information
  ///
  initialize({required String publicKey}) async {
    assert(() {
      if (publicKey.isEmpty) {
        throw new PaystackException('publicKey cannot be null or empty');
      }
      return true;
    }());

    if (sdkInitialized) return;

    this._publicKey = publicKey;

    // Using cascade notation to build the platform specific info
    try {
      platformInfo =
          await PlatformInfoInterface.fromMethodChannel(Utils.methodChannel);
      _sdkInitialized = true;
    } on PlatformException {
      rethrow;
    }
  }

  dispose() {
    _publicKey = "";
    _sdkInitialized = false;
  }

  bool get sdkInitialized => _sdkInitialized;

  String get publicKey {
    // Validate that the sdk has been initialized
    _validateSdkInitialized();
    return _publicKey;
  }

  void _performChecks() {
    //validate that sdk has been initialized
    _validateSdkInitialized();
    //check for null value, and length and starts with pk_
    if (_publicKey.isEmpty || !_publicKey.startsWith("pk_")) {
      throw new AuthenticationException(Utils.getKeyErrorMsg('public'));
    }
  }

  /// Make payment by charging the user's card
  ///
  /// [context] - the widgets BuildContext
  ///
  /// [charge] - the charge object.

  Future<CheckoutResponse> chargeCard(BuildContext context,
      {required Charge charge}) {
    _performChecks();

    return PaystackInterface(publicKey).chargeCard(
      context: context,
      charge: charge,
    );
  }

  /// Make payment using Paystack's checkout form. The plugin will handle the whole
  /// processes involved.
  ///
  /// [context] - the widget's BuildContext
  ///
  /// [charge] - the charge object.
  ///
  /// [method] - The payment method to use(card, bank). It defaults to
  /// [CheckoutMethod.selectable] to allow the user to select. For [CheckoutMethod.bank]
  ///  or [CheckoutMethod.selectable], it is
  /// required that you supply an access code to the [Charge] object passed to [charge].
  /// For [CheckoutMethod.card], though not recommended, passing a reference to the
  /// [Charge] object will do just fine.
  ///
  /// Notes:
  ///
  /// * You can also pass the [PaymentCard] object and we'll use it to prepopulate the
  /// card  fields if card payment is being used
  ///
  /// [fullscreen] - Whether to display the payment in a full screen dialog or not
  ///
  /// [logo] - The widget to display at the top left of the payment prompt.
  /// Defaults to an Image widget with Paystack's logo.
  ///
  /// [hideEmail] - Whether to hide the email from the user. When
  /// `false` and an email is passed to the [charge] object, the email
  /// will be displayed at the top right edge of the UI prompt. Defaults to
  /// `false`
  ///
  /// [hideAmount]  - Whether to hide the amount from the  payment prompt.
  /// When `false` the payment amount and currency is displayed at the
  /// top of payment prompt, just under the email. Also the payment
  /// call-to-action will display the amount, otherwise it will display
  /// "Continue". Defaults to `false`
  Future<CheckoutResponse> checkout(
    BuildContext context, {
    required Charge charge,
    CheckoutMethod method = CheckoutMethod.selectable,
    bool fullscreen = false,
    Widget? logo,
    bool hideEmail = false,
    bool hideAmount = false,
  }) async {
    return PaystackInterface(publicKey).checkout(
      context,
      charge: charge,
      method: method,
      fullscreen: fullscreen,
      logo: logo,
      hideAmount: hideAmount,
      hideEmail: hideEmail,
    );
  }

  _validateSdkInitialized() {
    if (!sdkInitialized) {
      throw new PaystackSdkNotInitializedException(
          'Paystack SDK has not been initialized. The SDK has'
          ' to be initialized before use');
    }
  }
}

typedef void OnTransactionChange<Transaction>(Transaction transaction);
typedef void OnTransactionError<Object, Transaction>(
    Object e, Transaction transaction);

enum CheckoutMethod { card, bank, selectable }

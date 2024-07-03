import 'package:js/js.dart';

@JS('PaystackPop')
class PaystackPop {
  external factory PaystackPop();

  external PaystackPop newTransaction(PaystackTransactionOptions options);
}

@JS()
@anonymous
class PaystackTransactionOptions {
  external factory PaystackTransactionOptions({
    String key,
    String email,
    String amount,
    String ref,
    String? currency,
    String? label,
    List<String>? channels,
    JSMap metadata,
    void Function(PaymentSuccessResponse response)? onSuccess,
    void Function(PaymentLoadResponse response)? onLoad,
    void Function(PaymentErrorResponse response)? onError,
    void Function()? onCancel,
  });
}

@JS()
@anonymous
class PaymentSuccessResponse {
  external factory PaymentSuccessResponse();

  external String? status;
  external String? reference;
  external String? message;
}

@JS()
@anonymous
class PaymentErrorResponse {
  external factory PaymentErrorResponse();

  external String? message;
}

@JS()
@anonymous
class PaymentLoadResponse {
  external factory PaymentLoadResponse();

  external String? id;
  external String? customer;
  external String? accessCode;
}

@JS('Map')
class JSMap<K, V> {
  /// Returns an [JSIterator] of all the key value pairs in the [Map]
  ///
  /// The [JSIterator] returns the key value pairs as a [List<dynamic>].
  /// The [List] always contains two elements. The first is the key and the second is the value.
  @JS('prototype.entries')
  external JSIterator<List<dynamic>> entries();

  @JS('prototype.keys')
  external JSIterator<K> keys();

  @JS('prototype.values')
  external JSIterator<V> values();

  external int get size;

  external factory JSMap();
}

@JS()
class JSIterator<T> {
  external IteratorValue<T> next();

  external factory JSIterator();
}

@JS()
class IteratorValue<T> {
  external T get value;
  external bool get done;

  external factory IteratorValue();
}

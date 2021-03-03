import 'dart:async';
import 'package:flutter/services.dart';

class FlutterBegateway {
  static const MethodChannel _channel = const MethodChannel('flutter_begateway');

  static Future<String> encryptCardData(String cardData, String publicKey) async {
    var params = {
      'data': cardData,
      'publicKey': publicKey,
    };
    return await _channel.invokeMethod<String>('encryptData', params);
  }
}

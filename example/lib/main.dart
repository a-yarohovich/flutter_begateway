import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:flutter_begateway/flutter_begateway.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String cardNumber;
  String cvv;
  String holder;
  String expMonth;
  String expYear;
  String resp;

  Future<void> initCreditCard() async {
    final authToken = 'AUTH_TOKEN';
    String pubKey =
        'MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAxiq93sRjfWUiS/OE2ZPfMSAeRZFGpVVetqkwQveG0reIiGnCl4RPJGMH1ng3y3ekhTxO1Ze+ln3sCK0LJ/MPrR1lzKN9QbY4F3l/gmj/XLUseOPFtayxvQaC+lrYcnZbTFhqxB6I1MSF/3oeTqbjJvUE9KEDmGsZ57y0+ivbRo9QJs63zoKaUDpQSKexibSMu07nm78DOORvd0AJa/b5ZF+6zWFolVBmzuIgGDpCWG+Gt4+LSw9yiH0/43gieFr2rDKbb7e7JQpnyGEDT+IRP9uKCmlRoV1kHcVyHoNbC0Q9kV8jPW2K5rKuj80auV3I2dgjJEsvxMuHQOr4aoMAgQIDAQAB';
    cardNumber = await FlutterBegateway.encryptCardData('4012000000003010', pubKey);
    cvv = await FlutterBegateway.encryptCardData('147', pubKey);
    holder = await FlutterBegateway.encryptCardData('IVAN IVANOV', pubKey);
    expMonth = await FlutterBegateway.encryptCardData('09', pubKey);
    expYear = await FlutterBegateway.encryptCardData('2025', pubKey);
    Map<String, String> headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Basic $authToken',
    };
    Map<String, dynamic> body = {
      "request": {
        "amount": 100,
        "currency": "BYN",
        "description": "MEDIOBY Authorization",
        "tracking_id": "fb98b46e-56c0-4f6c-ad32-86319d8a82ae",
        "test": true,
        "language": "ru",
        "return_url": "https://wonderful-puma-28.telebit.io/api/user/payments/return",
        "encrypted_credit_card": {
          "number": cardNumber,
          "exp_month": expMonth,
          "exp_year": expYear,
          "verification_value": cvv,
          "holder": holder
        },
        "additional_data": {
          "contract": ["recurring", "card_on_file"]
        }
      }
    };
    http.Response r = await http.post(
      'https://gateway.bepaid.by/transactions/authorizations',
      headers: headers,
      body: jsonEncode(body),
    );
    print(body);
    resp = r.body;
    print(resp);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: initCreditCard(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return MaterialApp(
              home: Scaffold(
                appBar: AppBar(
                  title: const Text('Bepaid flutter plugin example app'),
                ),
                body: Center(
                  child: Text('Error: ${snapshot.error.toString()}'),
                ),
              ),
            );
          }
          return MaterialApp(
            home: Scaffold(
              appBar: AppBar(
                title: const Text('Bepaid flutter plugin example app'),
              ),
              body: Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SelectableText(resp),
                ),
              ),
            ),
          );
        }
        return FullScreenProgressIndicator();
      },
    );
  }
}

class FullScreenProgressIndicator extends StatelessWidget {
  const FullScreenProgressIndicator();
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: CircularProgressIndicator(
          strokeWidth: 6.0,
        ),
      ),
    );
  }
}

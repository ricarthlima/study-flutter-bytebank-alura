import 'dart:convert';

import 'package:flutter_persistence_alura/models/transaction.dart';
import 'package:http/http.dart';

import '../webclient.dart';

class TransactionWebClient {
  Future<List<Transaction>> findAll() async {
    final Response response = await client.get(
      Uri.parse(baseURL),
    );

    final List<dynamic> decodedJson = jsonDecode(response.body);
    List<Transaction> transactions = decodedJson
        .map(
          (dynamic json) => Transaction.fromJson(json),
        )
        .toList();

    return transactions;
  }

  Future<Transaction?> save(Transaction transaction, String password) async {
    String transactionJSON = jsonEncode(transaction.toJson());

    Response response = await client.post(
      Uri.parse(baseURL),
      headers: {
        "Content-type": "application/json",
        "password": password,
      },
      body: transactionJSON,
    );

    if (response.statusCode != 200) {
      throw HttpException(
          _getMessage(response.statusCode), response.statusCode);
    }

    Map<String, dynamic> json = jsonDecode(response.body);
    return Transaction.fromJson(json);
  }

  String? _getMessage(int statusCode) {
    if (_statusCodeResponses.containsKey(statusCode)) {
      return _statusCodeResponses[statusCode];
    }
    return "Unknow error";
  }

  static final Map<int, String> _statusCodeResponses = {
    400: "There was an error submitting transaction",
    401: "Authentication failed",
    409: "Transaction already exists"
  };
}

class HttpException implements Exception {
  final String? message;
  final int? statusCode;
  HttpException(this.message, this.statusCode);
}

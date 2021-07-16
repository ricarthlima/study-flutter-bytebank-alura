import 'dart:convert';

import 'package:flutter_persistence_alura/models/transaction.dart';
import 'package:http/http.dart';

import '../webclient.dart';

class TransactionWebClient {
  Future<List<Transaction>> findAll() async {
    final Response response = await client
        .get(
          Uri.parse("http://192.168.0.9:8080/transactions"),
        )
        .timeout(Duration(seconds: 5));

    final List<dynamic> decodedJson = jsonDecode(response.body);
    List<Transaction> transactions = decodedJson
        .map(
          (dynamic json) => Transaction.fromJson(json),
        )
        .toList();

    return transactions;
  }

  Future<Transaction> save(Transaction transaction, String password) async {
    String transactionJSON = jsonEncode(transaction.toJson());

    Response response = await client.post(
      Uri.parse(baseURL),
      headers: {
        "Content-type": "application/json",
        "password": password,
      },
      body: transactionJSON,
    );

    _throwHttpError(response.statusCode);

    Map<String, dynamic> json = jsonDecode(response.body);
    return Transaction.fromJson(json);
  }

  void _throwHttpError(int statusCode) =>
      throw Exception(_statusCodeResponses[statusCode]);

  static final Map<int, String> _statusCodeResponses = {
    400: "There was an error submitting transaction",
    401: "Authentication failed"
  };
}

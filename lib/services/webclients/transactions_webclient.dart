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

    switch (response.statusCode) {
      case 400:
        throw Exception("There was an error submitting transaction");
      case 401:
        throw Exception("Authentication failed");
    }

    Map<String, dynamic> json = jsonDecode(response.body);
    return Transaction.fromJson(json);
  }
}

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_persistence_alura/models/contact.dart';
import 'package:flutter_persistence_alura/models/transaction.dart';
import 'package:flutter_persistence_alura/services/webclients/transactions_webclient.dart';
import 'package:flutter_persistence_alura/widgets/progress.dart';
import 'package:flutter_persistence_alura/widgets/response_dialog.dart';
import 'package:flutter_persistence_alura/widgets/transaction_auth_dialog.dart';
import 'package:uuid/uuid.dart';

class TransactionForm extends StatefulWidget {
  final Contact contact;

  TransactionForm(this.contact);

  @override
  _TransactionFormState createState() => _TransactionFormState();
}

class _TransactionFormState extends State<TransactionForm> {
  final TextEditingController _valueController = TextEditingController();
  final TransactionWebClient _webClient = TransactionWebClient();
  final String transactionId = Uuid().v4();

  bool _sending = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New transaction'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Visibility(
                child: Progress(
                  message: "Sending",
                ),
                visible: _sending,
              ),
              Text(
                widget.contact.name,
                style: TextStyle(
                  fontSize: 24.0,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Text(
                  widget.contact.accountNumber.toString(),
                  style: TextStyle(
                    fontSize: 32.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: TextField(
                  controller: _valueController,
                  style: TextStyle(fontSize: 24.0),
                  decoration: InputDecoration(labelText: 'Value'),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: SizedBox(
                  width: double.maxFinite,
                  child: ElevatedButton(
                    child: Text('Transfer'),
                    onPressed: () {
                      final double? value =
                          double.tryParse(_valueController.text);
                      final transactionCreated =
                          Transaction(transactionId, value!, widget.contact);

                      showDialog(
                          context: context,
                          builder: (contextDialog) {
                            return TransactionAuthDialog(
                              onConfirm: (String password) async {
                                Transaction? transaction = await _send(
                                    transactionCreated, password, context);
                                if (transaction != null) {
                                  await showDialog(
                                      context: context,
                                      builder: (contextDialog) {
                                        return SuccessDialog(
                                            "Successful Transaction");
                                      });
                                  Navigator.pop(context);
                                }
                              },
                            );
                          });
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<Transaction?> _send(Transaction transactionCreated, String password,
      BuildContext context) async {
    setState(() {
      _sending = true;
    });
    Transaction? transaction =
        await _webClient.save(transactionCreated, password).catchError(
      (e) {
        _showFailureMessage(context, message: "Timeout Error");
      },
      test: (e) => e is TimeoutException,
    ).catchError(
      (e) {
        print("CHEGOU AQUI");
        print(e.statusCode);
        _showFailureMessage(context, message: e.message);
      },
      test: (e) => e is HttpException,
    ).catchError(
      (e) {
        _showFailureMessage(context);
      },
      test: (e) => e is Exception,
    ).whenComplete(() {
      setState(() {
        _sending = false;
      });
    });
    return transaction;
  }

  void _showFailureMessage(BuildContext context,
      {String message = "Unknow error"}) {
    showDialog(
        context: context,
        builder: (contextDialog) {
          return FailureDialog(message);
        });
  }
}

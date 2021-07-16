import 'package:flutter/material.dart';
import 'package:flutter_persistence_alura/models/transaction.dart';
import 'package:flutter_persistence_alura/services/webclients/transactions_webclient.dart';
import 'package:flutter_persistence_alura/widgets/centered_message.dart';
import 'package:flutter_persistence_alura/widgets/progress.dart';

class TransactionsList extends StatefulWidget {
  @override
  _TransactionsListState createState() => _TransactionsListState();
}

class _TransactionsListState extends State<TransactionsList> {
  final TransactionWebClient _webClient = TransactionWebClient();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transactions'),
      ),
      body: FutureBuilder<List<Transaction>>(
        future: _webClient.findAll(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              break;
            case ConnectionState.waiting:
              return Progress();
            case ConnectionState.active:
              break;
            case ConnectionState.done:
              if (snapshot.hasData) {
                final List<Transaction> transactions = snapshot.data!;
                if (transactions.isNotEmpty) {
                  return ListView.builder(
                    itemBuilder: (context, index) {
                      final Transaction transaction = transactions[index];
                      return Card(
                        child: ListTile(
                          leading: Icon(Icons.monetization_on),
                          title: Text(
                            transaction.value.toString(),
                            style: TextStyle(
                              fontSize: 24.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            transaction.contact.accountNumber.toString(),
                            style: TextStyle(
                              fontSize: 16.0,
                            ),
                          ),
                        ),
                      );
                    },
                    itemCount: transactions.length,
                  );
                } else {
                  return CenteredMessage(
                    "No transactions found",
                    icon: Icons.warning,
                  );
                }
              } else {
                return CenteredMessage(
                  "Server can't be reached",
                  icon: Icons.warning,
                );
              }
          }
          return CenteredMessage("Unknow Error");
        },
      ),
    );
  }
}

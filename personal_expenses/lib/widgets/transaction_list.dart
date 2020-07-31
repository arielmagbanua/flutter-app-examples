import 'package:flutter/material.dart';

import './transaction_item.dart';
import '../models/transaction.dart';

/// Widget for displaying all transactions made
class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;
  final Function deleteTx;

  /// [transactions] List of transactions
  /// [deleteTx] Delete function reference, enables outside widget to listen
  /// for deleting of transactions.
  TransactionList(this.transactions, this.deleteTx);

  @override
  Widget build(BuildContext context) {
    return transactions.isEmpty
        ? LayoutBuilder(
            builder: (ctx, constraints) {
              return Column(
                children: <Widget>[
                  Text(
                    'No transactions added yet!',
                    style: Theme.of(context).textTheme.title,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: constraints.maxHeight * 0.6,
                    child: Image.asset(
                      'assets/images/waiting.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              );
            },
          )
        : ListView(
            children: transactions.map((tx) {
            return TransactionItem(
              key: ValueKey(tx.id),
              transaction: tx,
              deleteTx: deleteTx,
            );
          }).toList());
  }
}

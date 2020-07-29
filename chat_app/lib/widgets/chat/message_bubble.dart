import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final String message;

  MessageBubble(this.message);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).accentColor,
            borderRadius: BorderRadius.circular(12),
          ),
          width: 140,
          padding: EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 16,
          ),
          margin: EdgeInsets.symmetric(
            vertical: 4,
            horizontal: 8,
          ),
          child: Text(
            message,
            style: TextStyle(
              color: Theme.of(context).accentTextTheme.title.color,
            ),
          ),
        ),
      ],
    );
  }
}

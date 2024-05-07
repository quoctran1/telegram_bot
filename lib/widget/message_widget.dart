import 'package:flutter/material.dart';
import 'package:teledart/model.dart';

class MessageWidget extends StatelessWidget {
  final TeleDartMessage message;
  const MessageWidget({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Text('Text: ${message.text} \n Name: ${message.from?.username}');
  }
}

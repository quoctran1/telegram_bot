import 'package:flutter/material.dart';
import 'package:teledart/model.dart';
import 'package:telegram_bot/controller.dart';
import 'package:telegram_bot/widget/message_widget.dart';

class Bot extends StatefulWidget {
  const Bot({super.key});

  @override
  State<Bot> createState() => _BotState();
}

class _BotState extends State<Bot> {
  late Controller controller;

  @override
  void initState() {
    controller = Controller();
    controller.init();
    Future.delayed(const Duration(seconds: 4), () {
      controller.listen();
    });
    super.initState();
  }

  @override
  void dispose() {
    controller.teleDart.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ValueListenableBuilder(
          valueListenable: controller.connectNotifier,
          builder: (BuildContext context, bool value, Widget? child) {
            if (!value) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Colors.red,
                ),
              );
            }
            return StreamBuilder(
              stream: controller.teleDart.onMessage(),
              builder: (BuildContext context,
                  AsyncSnapshot<TeleDartMessage> snapshot) {
                if (!snapshot.hasData) return const SizedBox();
                return MessageWidget(message: snapshot.data!);
              },
            );
          },
        ),
      ),
    );
  }
}

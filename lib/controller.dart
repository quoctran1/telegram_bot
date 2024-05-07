import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:teledart/model.dart';
import 'package:teledart/teledart.dart';
import 'package:teledart/telegram.dart';
import 'package:telegram_bot/command_repos.dart';
import 'package:http/http.dart' as http;

class Controller {
  String botToken = '7080618063:AAEliWracPEZSe-2qVl5_fbp53PoSCRdCgk';
  late TeleDart teleDart;
  ValueNotifier<bool> connectNotifier = ValueNotifier(false);
  CommandRepos commandRepos = CommandRepos();
  var url = Uri.http('localhost:8080', '/create-message');
  String baseImagePath =
      'https://api.telegram.org/file/bot7080618063:AAEliWracPEZSe-2qVl5_fbp53PoSCRdCgk/';

  void init() async {
    final result = await _init();
    connectNotifier.value = result;
  }

  Future<bool> _init() async {
    final username = (await Telegram(botToken).getMe()).username;
    teleDart = TeleDart(botToken, Event(username!));

    teleDart.start();
    return true;
  }

  Future<void> reply({
    required String chatID,
    required String message,
  }) async {
    teleDart.sendMessage(chatID, message);
  }

  void listen() async {
    teleDart.onMessage().listen((event) {
      replyMessage(event);
    });
    teleDart.onCommand().listen((event) {
      replyMessage(event);
    });
  }

  void replyCommand(TeleDartMessage teleDartMessage) async {
    try {
      var response = await http.post(url,
          body: jsonEncode({
            'content': '${teleDartMessage.text}',
            'userId': teleDartMessage.from!.id.toString()
          }));
      print('Response status: ${response.statusCode}');
      final result = jsonDecode(response.body);
      reply(
          chatID: teleDartMessage.chat.id.toString(),
          message: result['data']['text']);
    } catch (e) {
      print(e);
    }
  }

  void replyMessage(TeleDartMessage teleDartMessage) async {
    try {
      String imagePath = '';
      if (teleDartMessage.photo?.last != null) {
        final result = await teleDart.getFile(teleDartMessage.photo!.last.fileId);
        imagePath = 'Link ảnh: ${baseImagePath + result.filePath!}';
      }

      var response = await http.post(url,
          body: jsonEncode({
            'content': '${teleDartMessage.text}\n $imagePath',
            'userId': teleDartMessage.from!.id.toString()
          }));
      print('Response status: ${response.statusCode}');

      final decoded = utf8.decode(response.bodyBytes);
      final result = jsonDecode(decoded);
      print(result);
      reply(
          chatID: teleDartMessage.chat.id.toString(),
          message: result['data']['text']);
    } catch (e) {
      print(e);
    }
  }
}

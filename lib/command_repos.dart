import 'package:teledart/model.dart';

class CommandRepos {
  late TeleDartMessage teleDartMessage;

  void handel(String message) {
    switch (message) {
      case 'start':
        startCommand();
      case 'end':
        startCommand();
    }
  }

  Future<void> startCommand() async {}

  Future<void> endCommand() async {}
}

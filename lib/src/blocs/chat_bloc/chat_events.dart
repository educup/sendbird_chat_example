import 'dart:io';

import 'package:sendbird_sdk/sendbird_sdk.dart';

class ChatEvent {}

class ChatStartedEvent extends ChatEvent {
  final String userId;
  final String otherId;

  ChatStartedEvent({
    required this.userId,
    required this.otherId,
  });
}

class ChatHistoricalMessagesLoadedEvent extends ChatEvent {}

class ChatTextMessageSendedEvent extends ChatEvent {
  final String message;

  ChatTextMessageSendedEvent({
    required this.message,
  });
}

class ChatFileMessageSendedEvent extends ChatEvent {
  final String filename;
  final File file;

  ChatFileMessageSendedEvent({
    required this.filename,
    required this.file,
  });
}

class ChatMessageReceivedEvent extends ChatEvent {
  final BaseMessage message;

  ChatMessageReceivedEvent({
    required this.message,
  });
}

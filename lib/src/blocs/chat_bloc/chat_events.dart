import 'package:sendbird_sdk/sendbird_sdk.dart';

class ChatEvent {
  final String userId;
  final String otherId;

  ChatEvent({
    required this.userId,
    required this.otherId,
  });
}

class ChatStartedEvent extends ChatEvent {
  final ChannelEventHandler channelHandler;

  ChatStartedEvent({
    required String userId,
    required String otherId,
    required this.channelHandler,
  }) : super(
          userId: userId,
          otherId: otherId,
        );
}

class ChatHistoricalMessagesLoadedEvent extends ChatEvent {
  ChatHistoricalMessagesLoadedEvent({
    required String userId,
    required String otherId,
  }) : super(
          userId: userId,
          otherId: otherId,
        );
}

class ChatMessageSendedEvent extends ChatEvent {
  final String message;

  ChatMessageSendedEvent({
    required String userId,
    required String otherId,
    required this.message,
  }) : super(
          userId: userId,
          otherId: otherId,
        );
}

class ChatMessageReceivedEvent extends ChatEvent {
  final BaseMessage message;

  ChatMessageReceivedEvent({
    required String userId,
    required String otherId,
    required this.message,
  }) : super(
          userId: userId,
          otherId: otherId,
        );
}

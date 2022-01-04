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
  ChatStartedEvent({
    required String userId,
    required String otherId,
  }) : super(
          userId: userId,
          otherId: otherId,
        );
}

class ChatHistoricalMessagesLoadedEvent extends ChatEvent {
  final List<BaseMessage> actualMessages;
  final PreviousMessageListQuery historicalMessages;

  ChatHistoricalMessagesLoadedEvent({
    required String userId,
    required String otherId,
    required this.actualMessages,
    required this.historicalMessages,
  }) : super(
          userId: userId,
          otherId: otherId,
        );
}

class ChatMessageSendedEvent extends ChatEvent {
  final String message;
  final List<BaseMessage> actualMessages;
  final PreviousMessageListQuery historicalMessages;

  ChatMessageSendedEvent({
    required String userId,
    required String otherId,
    required this.message,
    required this.actualMessages,
    required this.historicalMessages,
  }) : super(
          userId: userId,
          otherId: otherId,
        );
}

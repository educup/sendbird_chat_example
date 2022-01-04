import 'package:sendbird_sdk/sendbird_sdk.dart';

class ChatEvent {
  final String userId;
  final String otherId;

  ChatEvent({
    required this.userId,
    required this.otherId,
  });
}

class ChatEventStarted extends ChatEvent {
  ChatEventStarted({
    required String userId,
    required String otherId,
  }) : super(
          userId: userId,
          otherId: otherId,
        );
}

class ChatEventHistoricalMessagesLoaded extends ChatEvent {
  final List<BaseMessage> actualMessages;
  final PreviousMessageListQuery historicalMessages;

  ChatEventHistoricalMessagesLoaded({
    required String userId,
    required String otherId,
    required this.actualMessages,
    required this.historicalMessages,
  }) : super(
          userId: userId,
          otherId: otherId,
        );
}

class ChatEventMessageSended extends ChatEvent {
  final String message;
  final List<BaseMessage> actualMessages;
  final PreviousMessageListQuery historicalMessages;

  ChatEventMessageSended({
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

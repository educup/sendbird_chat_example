import 'package:sendbird_sdk/sendbird_sdk.dart';

class ChatState {}

class ChatLoadInProgress extends ChatState {}

class ChatLoadSuccess extends ChatState {
  final List<BaseMessage> messages;
  final PreviousMessageListQuery historicalMessages;

  ChatLoadSuccess({
    required this.messages,
    required this.historicalMessages,
  });
}

class ChatLoadFailure extends ChatState {
  final String errorMessage;

  ChatLoadFailure({
    required this.errorMessage,
  });
}

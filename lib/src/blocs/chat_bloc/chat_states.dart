import 'package:sendbird_sdk/sendbird_sdk.dart';

class ChatState {}

class ChatInitialState extends ChatState {}

class ChatLoadInProgress extends ChatState {}

class ChatLoadSuccess extends ChatState {
  final List<BaseMessage> messages;

  ChatLoadSuccess({
    required this.messages,
  });
}

class ChatLoadFailure extends ChatState {
  final String errorMessage;

  ChatLoadFailure({
    required this.errorMessage,
  });
}

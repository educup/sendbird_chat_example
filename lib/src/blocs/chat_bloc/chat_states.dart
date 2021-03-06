import 'package:sendbird_sdk/sendbird_sdk.dart';

class ChatState {}

class ChatInitialState extends ChatState {}

class ChatLoadInProgress extends ChatState {}

class ChatLoadSuccess extends ChatState {
  final bool loading;
  final bool allLoaded;
  final List<BaseMessage> messages;

  ChatLoadSuccess({
    required this.loading,
    required this.allLoaded,
    required this.messages,
  });
}

class ChatLoadSuccessWithNotification extends ChatLoadSuccess {
  final String notification;

  ChatLoadSuccessWithNotification({
    required bool loading,
    required bool allLoaded,
    required List<BaseMessage> messages,
    required this.notification,
  }) : super(
          loading: loading,
          allLoaded: allLoaded,
          messages: messages,
        );
}

class ChatLoadFailure extends ChatState {
  final String errorMessage;

  ChatLoadFailure({
    required this.errorMessage,
  });
}

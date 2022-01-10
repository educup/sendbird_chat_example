import 'package:sendbird_sdk/sendbird_sdk.dart';

class ChatsListState {}

class ChatsListInitialState extends ChatsListState {}

class ChatsListLoadInProgress extends ChatsListState {}

class ChatsListLoadSuccess extends ChatsListState {
  final bool loading;
  final bool allLoaded;
  final List<GroupChannel> chats;

  ChatsListLoadSuccess({
    required this.loading,
    required this.allLoaded,
    required this.chats,
  });
}

class ChatsListLoadSuccessWithNotification extends ChatsListLoadSuccess {
  final String notification;

  ChatsListLoadSuccessWithNotification({
    required bool loading,
    required bool allLoaded,
    required List<GroupChannel> chats,
    required this.notification,
  }) : super(
          loading: loading,
          allLoaded: allLoaded,
          chats: chats,
        );
}

class ChatListChatPressSuccess extends ChatsListLoadSuccess {
  final String chatCompanionId;

  ChatListChatPressSuccess({
    required bool loading,
    required bool allLoaded,
    required List<GroupChannel> chats,
    required this.chatCompanionId,
  }) : super(
          loading: loading,
          allLoaded: allLoaded,
          chats: chats,
        );
}

class ChatsListLoadFailure extends ChatsListState {
  ChatsListLoadFailure({
    required this.errorMessage,
  });

  String errorMessage;
}

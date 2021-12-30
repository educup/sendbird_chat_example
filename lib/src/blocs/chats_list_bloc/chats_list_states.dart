import 'package:sendbird_sdk/sendbird_sdk.dart';

class ChatsListState {}

class ChatsListLoadInProgress extends ChatsListState {}

class ChatsListLoadSuccess extends ChatsListState {
  ChatsListLoadSuccess({
    required this.chats,
  });

  List<GroupChannel> chats;
}

class ChatsListLoadFailure extends ChatsListState {
  ChatsListLoadFailure({
    required this.message,
  });

  String message;
}

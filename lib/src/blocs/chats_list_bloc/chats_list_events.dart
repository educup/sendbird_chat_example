import 'package:sendbird_sdk/core/channel/group/group_channel.dart';

class ChatsListEvent {}

class ChatsListStarted extends ChatsListEvent {
  final String userId;

  ChatsListStarted({
    required this.userId,
  });
}

class ChatsListRefreshed extends ChatsListEvent {}

class ChatsListMoreChatsLoaded extends ChatsListEvent {}

class ChatsListNewChatPressed extends ChatsListEvent {
  final String otherId;
  ChatsListNewChatPressed({
    required this.otherId,
  });
}

class ChatsListChatJoined extends ChatsListEvent {
  final GroupChannel chat;

  ChatsListChatJoined({
    required this.chat,
  });
}

class ChatsListMessageReceived extends ChatsListEvent {
  final GroupChannel inChat;

  ChatsListMessageReceived({
    required this.inChat,
  });
}

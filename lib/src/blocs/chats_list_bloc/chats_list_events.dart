class ChatsListEvent {}

class ChatsListStarted extends ChatsListEvent {
  ChatsListStarted({
    required this.userId,
  });

  String userId;
}

class ChatsListRefreshed extends ChatsListEvent {
  ChatsListRefreshed({
    required this.userId,
  });

  String userId;
}

class ChatsListNewChatPressed extends ChatsListEvent {
  ChatsListNewChatPressed({
    required this.userId,
    required this.otherUserId,
  });

  String userId;
  String otherUserId;
}

class ChatsListEvent {
  final String userId;

  ChatsListEvent({
    required this.userId,
  });
}

class ChatsListStarted extends ChatsListEvent {
  ChatsListStarted({
    required String userId,
  }) : super(
          userId: userId,
        );
}

class ChatsListRefreshed extends ChatsListEvent {
  ChatsListRefreshed({
    required String userId,
  }) : super(
          userId: userId,
        );
}

class ChatsListMoreChatsLoaded extends ChatsListEvent {
  ChatsListMoreChatsLoaded({
    required String userId,
  }) : super(
          userId: userId,
        );
}

class ChatsListNewChatPressed extends ChatsListEvent {
  final String otherId;
  ChatsListNewChatPressed({
    required String userId,
    required this.otherId,
  }) : super(
          userId: userId,
        );
}

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:sendbird_chat_test/src/blocs/chats_list_bloc/chats_list_events.dart';
import 'package:sendbird_chat_test/src/blocs/chats_list_bloc/chats_list_states.dart';
import 'package:sendbird_chat_test/src/repositories/messaging_repository.dart';
import 'package:sendbird_sdk/sendbird_sdk.dart';

export 'chats_list_events.dart';
export 'chats_list_states.dart';

@injectable
class ChatsListBloc extends Bloc<ChatsListEvent, ChatsListState> {
  late final String userId;
  List<GroupChannel> chats = [];
  late GroupChannelListQuery chatsQuery;
  final MessagingRepository messagingRepository;

  ChatsListBloc({
    required this.messagingRepository,
  }) : super(ChatsListInitialState()) {
    on<ChatsListStarted>((event, emit) async {
      emit(ChatsListLoadInProgress());
      try {
        userId = event.userId;
        await messagingRepository.connect(userId);

        messagingRepository
            .removeChannelEventHandler(ChatsListEventHandler.chatListHandlerId);
        messagingRepository.registerChannelEventHandler(
          ChatsListEventHandler(
            userId: userId,
            bloc: this,
          ),
          ChatsListEventHandler.chatListHandlerId,
        );

        chatsQuery = messagingRepository.getPrivateChats(userId);
        chats = await chatsQuery.loadNext();
        emit(
          ChatsListLoadSuccess(
            loading: chatsQuery.loading,
            allLoaded: !chatsQuery.hasNext,
            chats: chats,
          ),
        );
      } catch (e) {
        emit(
          ChatsListLoadFailure(
            errorMessage: e.toString(),
          ),
        );
      }
    });

    on<ChatsListRefreshed>((event, emit) async {
      try {
        chatsQuery = messagingRepository.getPrivateChats(userId);
        chats = await chatsQuery.loadNext();
        emit(
          ChatsListLoadSuccess(
            loading: chatsQuery.loading,
            allLoaded: !chatsQuery.hasNext,
            chats: chats,
          ),
        );
      } catch (e) {
        emit(
          ChatsListLoadSuccessWithNotification(
            loading: chatsQuery.loading,
            allLoaded: !chatsQuery.hasNext,
            chats: chats,
            notification: e.toString(),
          ),
        );
      }
    });

    on<ChatsListMoreChatsLoaded>((event, emit) async {
      try {
        if (!chatsQuery.loading && chatsQuery.hasNext) {
          final newChats = await chatsQuery.loadNext();
          chats.addAll(newChats);
        }
        emit(ChatsListLoadSuccess(
          loading: chatsQuery.loading,
          allLoaded: !chatsQuery.hasNext,
          chats: chats,
        ));
      } catch (e) {
        emit(ChatsListLoadSuccessWithNotification(
          loading: chatsQuery.loading,
          allLoaded: !chatsQuery.hasNext,
          chats: chats,
          notification: e.toString(),
        ));
      }
    });

    on<ChatsListNewChatPressed>((event, emit) async {
      try {
        final newChat = await messagingRepository.createPrivateChat(
          userId,
          event.otherId,
        );

        int? originalPos;
        int pos = 0;
        for (final chat in chats) {
          if (newChat.channelUrl == chat.channelUrl) {
            originalPos = pos;
          }
          pos += 1;
        }
        if (originalPos != null) {
          chats.removeAt(originalPos);
        }
        chats.insert(0, newChat);

        emit(
          ChatsListLoadSuccess(
            loading: chatsQuery.loading,
            allLoaded: !chatsQuery.hasNext,
            chats: chats,
          ),
        );
      } catch (e) {
        emit(
          ChatsListLoadSuccessWithNotification(
            loading: chatsQuery.loading,
            allLoaded: !chatsQuery.hasNext,
            chats: chats,
            notification: e.toString(),
          ),
        );
      }
    });

    on<ChatsListChatJoined>((event, emit) {
      try {
        chats.insert(0, event.chat);

        emit(
          ChatsListLoadSuccess(
            loading: chatsQuery.loading,
            allLoaded: !chatsQuery.hasNext,
            chats: chats,
          ),
        );
      } catch (e) {
        emit(
          ChatsListLoadSuccessWithNotification(
            loading: chatsQuery.loading,
            allLoaded: !chatsQuery.hasNext,
            chats: chats,
            notification: e.toString(),
          ),
        );
      }
    });

    on<ChatsListMessageReceived>((event, emit) {
      try {
        int? originalPos;
        int pos = 0;
        for (final chat in chats) {
          if (event.inChat.channelUrl == chat.channelUrl) {
            originalPos = pos;
          }
          pos += 1;
        }
        if (originalPos != null) {
          chats.removeAt(originalPos);
        }
        chats.insert(0, event.inChat);

        emit(
          ChatsListLoadSuccess(
            loading: chatsQuery.loading,
            allLoaded: !chatsQuery.hasNext,
            chats: chats,
          ),
        );
      } catch (e) {
        emit(
          ChatsListLoadSuccessWithNotification(
            loading: chatsQuery.loading,
            allLoaded: !chatsQuery.hasNext,
            chats: chats,
            notification: e.toString(),
          ),
        );
      }
    });

    on<ChatsListChatPressed>((event, emit) async {
      try {
        final toUpdateChatUrl = messagingRepository.buildPrivateChatUrl(
            userId, event.chatCompanionId);

        int? originalPos;
        int pos = 0;
        for (final chat in chats) {
          if (toUpdateChatUrl == chat.channelUrl) {
            originalPos = pos;
          }
          pos += 1;
        }
        final updatedChat =
            await messagingRepository.getPrivateChatByUrl(toUpdateChatUrl);
        await messagingRepository.markChannelAsReaded(updatedChat);
        if (originalPos != null) {
          chats[originalPos] = updatedChat;
        }
        emit(
          ChatListChatPressSuccess(
            loading: chatsQuery.loading,
            allLoaded: !chatsQuery.hasNext,
            chats: chats,
            chatCompanionId: event.chatCompanionId,
          ),
        );
      } catch (e) {
        emit(
          ChatsListLoadSuccessWithNotification(
            loading: chatsQuery.loading,
            allLoaded: !chatsQuery.hasNext,
            chats: chats,
            notification: e.toString(),
          ),
        );
      }
    });
  }
}

class ChatsListEventHandler with ChannelEventHandler {
  final String userId;
  final ChatsListBloc bloc;
  static const String chatListHandlerId = 'chat-list-handler';

  ChatsListEventHandler({
    required this.userId,
    required this.bloc,
  });

  @override
  void onUserJoined(GroupChannel channel, User user) {
    if (user.isCurrentUser) {
      bloc.add(
        ChatsListChatJoined(
          chat: channel,
        ),
      );
    }
  }

  @override
  void onMessageReceived(BaseChannel channel, BaseMessage message) {
    if (channel is GroupChannel) {
      bloc.add(
        ChatsListMessageReceived(
          inChat: channel,
        ),
      );
    }
  }
}

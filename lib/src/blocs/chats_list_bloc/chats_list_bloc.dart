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
  List<GroupChannel> chats = [];
  late GroupChannelListQuery chatsQuery;

  ChatsListBloc({
    required this.messagingRepository,
  }) : super(ChatsListInitialState()) {
    on<ChatsListStarted>((event, emit) async {
      emit(ChatsListLoadInProgress());
      try {
        await messagingRepository.connect(event.userId);
        chatsQuery = messagingRepository.getPrivateChats(event.userId);
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
        chatsQuery = messagingRepository.getPrivateChats(event.userId);
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
          event.userId,
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
  }

  final MessagingRepository messagingRepository;
}

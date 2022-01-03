import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:sendbird_chat_test/src/blocs/chats_list_bloc/chats_list_events.dart';
import 'package:sendbird_chat_test/src/blocs/chats_list_bloc/chats_list_states.dart';
import 'package:sendbird_chat_test/src/repositories/messaging_repository.dart';

export 'chats_list_events.dart';
export 'chats_list_states.dart';

@injectable
class ChatsListBloc extends Bloc<ChatsListEvent, ChatsListState> {
  ChatsListBloc({
    required this.messagingRepository,
  }) : super(ChatsListLoadInProgress()) {
    on<ChatsListStarted>((event, emit) async {
      emit(ChatsListLoadInProgress());
      try {
        await messagingRepository.connect(event.userId);
        final chats = await messagingRepository.getPrivateChats(event.userId);
        emit(
          ChatsListLoadSuccess(
            chats: chats,
          ),
        );
      } catch (e) {
        emit(
          ChatsListLoadFailure(
            message: e.toString(),
          ),
        );
      }
    });
    on<ChatsListRefreshed>((event, emit) async {
      emit(ChatsListLoadInProgress());
      try {
        final chats = await messagingRepository.getPrivateChats(event.userId);
        emit(
          ChatsListLoadSuccess(
            chats: chats,
          ),
        );
      } catch (e) {
        emit(
          ChatsListLoadFailure(
            message: e.toString(),
          ),
        );
      }
    });
    on<ChatsListNewChatPressed>((event, emit) async {
      emit(ChatsListLoadInProgress());
      try {
        await messagingRepository.createPrivateChat(
          event.userId,
          event.otherUserId,
        );
        final chats = await messagingRepository.getPrivateChats(event.userId);
        emit(
          ChatsListLoadSuccess(
            chats: chats,
          ),
        );
      } catch (e) {
        emit(
          ChatsListLoadFailure(
            message: e.toString(),
          ),
        );
      }
    });
  }

  final MessagingRepository messagingRepository;
}

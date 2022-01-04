import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:sendbird_chat_test/src/blocs/chat_bloc/chat_events.dart';
import 'package:sendbird_chat_test/src/blocs/chat_bloc/chat_states.dart';
import 'package:sendbird_chat_test/src/repositories/repositories.dart';

export 'chat_events.dart';
export 'chat_states.dart';

@injectable
class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final MessagingRepository messagingRepository;

  ChatBloc({
    required this.messagingRepository,
  }) : super(ChatLoadInProgress()) {
    on<ChatStartedEvent>((event, emit) async {
      emit(ChatLoadInProgress());
      try {
        final historicalMessages = messagingRepository.getHistoricalMessages(
          event.userId,
          event.otherId,
        );
        final actualMessages = await historicalMessages.loadNext();

        emit(ChatLoadSuccess(
          messages: actualMessages,
          historicalMessages: historicalMessages,
        ));
      } catch (e) {
        emit(ChatLoadFailure(
          errorMessage: e.toString(),
        ));
      }
    });
    on<ChatHistoricalMessagesLoadedEvent>((event, emit) async {
      try {
        final messages = event.actualMessages;
        final historicalMessages = event.historicalMessages;

        final newHistoricalMessages = await historicalMessages.loadNext();
        messages.addAll(newHistoricalMessages);

        emit(ChatLoadSuccess(
          messages: messages,
          historicalMessages: historicalMessages,
        ));
      } catch (e) {
        emit(ChatLoadFailure(
          errorMessage: e.toString(),
        ));
      }
    });

    on<ChatMessageSendedEvent>((event, emit) async {
      try {
        final messages = event.actualMessages;
        final historicalMessages = event.historicalMessages;

        final pv = await messagingRepository.getPrivateChat(
          event.userId,
          event.otherId,
        );
        final message = await messagingRepository.sendMessage(
          pv,
          event.message,
        );
        messages.insert(0, message);

        emit(ChatLoadSuccess(
          messages: messages,
          historicalMessages: historicalMessages,
        ));
      } catch (e) {
        emit(ChatLoadFailure(
          errorMessage: e.toString(),
        ));
      }
    });
  }
}

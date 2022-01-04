import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:sendbird_chat_test/src/blocs/chat_bloc/chat_events.dart';
import 'package:sendbird_chat_test/src/blocs/chat_bloc/chat_states.dart';
import 'package:sendbird_chat_test/src/repositories/repositories.dart';
import 'package:sendbird_sdk/sendbird_sdk.dart';

export 'chat_events.dart';
export 'chat_states.dart';

@injectable
class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final MessagingRepository messagingRepository;
  final List<BaseMessage> messages = [];
  late final PreviousMessageListQuery historicalMessages;

  ChatBloc({
    required this.messagingRepository,
  }) : super(ChatInitialState()) {
    on<ChatStartedEvent>((event, emit) async {
      emit(ChatLoadInProgress());
      try {
        historicalMessages = messagingRepository.getHistoricalMessages(
          event.userId,
          event.otherId,
        );
        final oldMessages = await historicalMessages.loadNext();
        messages.addAll(oldMessages);

        final handlerId = messagingRepository.buildPrivateChatUrl(
            event.userId, event.otherId);
        messagingRepository.removeChannelEventHandler(handlerId);
        messagingRepository.registerChannelEventHandler(
          event.channelHandler,
          handlerId,
        );

        emit(ChatLoadSuccess(
          messages: messages,
        ));
      } catch (e) {
        emit(ChatLoadFailure(
          errorMessage: e.toString(),
        ));
      }
    });
    on<ChatHistoricalMessagesLoadedEvent>((event, emit) async {
      try {
        final newHistoricalMessages = await historicalMessages.loadNext();
        messages.addAll(newHistoricalMessages);

        emit(ChatLoadSuccess(
          messages: messages,
        ));
      } catch (e) {
        emit(ChatLoadFailure(
          errorMessage: e.toString(),
        ));
      }
    });

    on<ChatMessageSendedEvent>((event, emit) async {
      try {
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
        ));
      } catch (e) {
        emit(ChatLoadFailure(
          errorMessage: e.toString(),
        ));
      }
    });

    on<ChatMessageReceivedEvent>((event, emit) async {
      try {
        messages.insert(0, event.message);

        emit(ChatLoadSuccess(
          messages: messages,
        ));
      } catch (e) {
        emit(ChatLoadFailure(
          errorMessage: e.toString(),
        ));
      }
    });
  }
}

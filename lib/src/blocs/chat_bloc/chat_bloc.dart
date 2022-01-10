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
  late final String userId;
  late final String otherId;
  final MessagingRepository messagingRepository;
  final List<BaseMessage> messages = [];
  late final PreviousMessageListQuery historicalMessages;

  ChatBloc({
    required this.messagingRepository,
  }) : super(ChatInitialState()) {
    on<ChatStartedEvent>((event, emit) async {
      emit(ChatLoadInProgress());
      try {
        userId = event.userId;
        otherId = event.otherId;

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
          ChatEventHandler(
            userId: userId,
            otherId: otherId,
            bloc: this,
          ),
          handlerId,
        );

        emit(ChatLoadSuccess(
          loading: historicalMessages.loading,
          allLoaded: !historicalMessages.hasNext,
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
        if (!historicalMessages.loading && historicalMessages.hasNext) {
          final newHistoricalMessages = await historicalMessages.loadNext();
          messages.addAll(newHistoricalMessages);
        }
        emit(ChatLoadSuccess(
          loading: historicalMessages.loading,
          allLoaded: !historicalMessages.hasNext,
          messages: messages,
        ));
      } catch (e) {
        emit(ChatLoadSuccessWithNotification(
          loading: historicalMessages.loading,
          allLoaded: !historicalMessages.hasNext,
          messages: messages,
          notification: e.toString(),
        ));
      }
    });

    on<ChatTextMessageSendedEvent>((event, emit) async {
      try {
        final pv = await messagingRepository.getPrivateChat(
          userId,
          otherId,
        );
        final message = await messagingRepository.sendMessage(
          pv,
          event.message,
        );
        messages.insert(0, message);

        emit(ChatLoadSuccess(
          loading: historicalMessages.loading,
          allLoaded: !historicalMessages.hasNext,
          messages: messages,
        ));
      } catch (e) {
        emit(ChatLoadSuccessWithNotification(
          loading: historicalMessages.loading,
          allLoaded: !historicalMessages.hasNext,
          messages: messages,
          notification: e.toString(),
        ));
      }
    });

    on<ChatFileMessageSendedEvent>((event, emit) async {
      try {
        final pv = await messagingRepository.getPrivateChat(
          userId,
          otherId,
        );
        final message = await messagingRepository.sendFile(
          pv,
          event.file,
          filename: event.filename,
        );
        messages.insert(0, message);

        emit(ChatLoadSuccess(
          loading: historicalMessages.loading,
          allLoaded: !historicalMessages.hasNext,
          messages: messages,
        ));
      } catch (e) {
        emit(ChatLoadSuccessWithNotification(
          loading: historicalMessages.loading,
          allLoaded: !historicalMessages.hasNext,
          messages: messages,
          notification: e.toString(),
        ));
      }
    });

    on<ChatMessageReceivedEvent>((event, emit) async {
      try {
        final chat = await messagingRepository.getPrivateChat(userId, otherId);
        await messagingRepository.markChannelAsReaded(chat);

        messages.insert(0, event.message);

        emit(ChatLoadSuccess(
          loading: historicalMessages.loading,
          allLoaded: !historicalMessages.hasNext,
          messages: messages,
        ));
      } catch (e) {
        emit(ChatLoadSuccessWithNotification(
          loading: historicalMessages.loading,
          allLoaded: !historicalMessages.hasNext,
          messages: messages,
          notification: e.toString(),
        ));
      }
    });
  }
}

class ChatEventHandler with ChannelEventHandler {
  final String userId;
  final String otherId;
  final ChatBloc bloc;
  late final String chatUrl;

  ChatEventHandler({
    required this.userId,
    required this.otherId,
    required this.bloc,
  }) {
    chatUrl = bloc.messagingRepository.buildPrivateChatUrl(userId, otherId);
  }

  bool isForChat(GroupChannel chat) => chat.channelUrl == chatUrl;

  @override
  void onMessageReceived(
    BaseChannel channel,
    BaseMessage message,
  ) {
    if (channel is GroupChannel && isForChat(channel)) {
      bloc.add(
        ChatMessageReceivedEvent(
          message: message,
        ),
      );
    }
  }
}

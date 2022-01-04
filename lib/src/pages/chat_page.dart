import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:get_it/get_it.dart';
import 'package:sendbird_chat_test/src/blocs/blocs.dart';
import 'package:sendbird_sdk/sendbird_sdk.dart' as sendbird;

class ChatPage extends StatelessWidget {
  final String userId;
  final String otherId;

  const ChatPage({
    Key? key,
    required this.userId,
    required this.otherId,
  }) : super(
          key: key,
        );

  static BeamPage getPage(
    BuildContext context,
    String userId,
    String otherId,
  ) {
    final key = ValueKey(otherId);
    return BeamPage(
      key: key,
      title: otherId,
      child: ChatPage(
        key: key,
        userId: userId,
        otherId: otherId,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ChatBloc>(
      create: (context) => GetIt.I()
        ..add(
          ChatStartedEvent(
            userId: userId,
            otherId: otherId,
          ),
        ),
      child: ChatPageWidget(
        userId: userId,
        otherId: otherId,
      ),
    );
  }
}

class ChatPageWidget extends StatefulWidget {
  final String userId;
  final String otherId;

  const ChatPageWidget({
    Key? key,
    required this.userId,
    required this.otherId,
  }) : super(key: key);

  @override
  State<ChatPageWidget> createState() => _ChatPageWidgetState();
}

class _ChatPageWidgetState extends State<ChatPageWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.otherId),
      ),
      body: BlocConsumer<ChatBloc, ChatState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state is ChatLoadFailure) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: ${state.errorMessage}'),
                ],
              ),
            );
          } else if (state is ChatLoadInProgress) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  CircularProgressIndicator(),
                ],
              ),
            );
          } else if (state is ChatLoadSuccess) {
            return SafeArea(
              bottom: false,
              child: Chat(
                messages: _buildChatViewMessages(
                  state.messages,
                ),
                onSendPressed: (partialText) {
                  context.read<ChatBloc>().add(
                        ChatMessageSendedEvent(
                          userId: widget.userId,
                          otherId: widget.otherId,
                          actualMessages: state.messages,
                          message: partialText.text,
                          historicalMessages: state.historicalMessages,
                        ),
                      );
                },
                user: types.User(id: widget.userId),
              ),
            );
          }
          return Container();
        },
      ),
    );
  }

  List<types.Message> _buildChatViewMessages(
      List<sendbird.BaseMessage> messages) {
    final List<types.Message> castedMessages = [];
    final result = messages.map(
      (message) {
        if (message is sendbird.UserMessage) {
          return types.TextMessage(
            id: message.messageId.toString(),
            author: types.User(
              id: message.sender!.userId,
            ),
            text: message.message,
          );
        }
        return null;
      },
    ).toList();
    for (final castedMessage in result) {
      if (castedMessage != null) {
        castedMessages.add(castedMessage);
      }
    }
    return castedMessages;
  }
}

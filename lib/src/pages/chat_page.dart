import 'dart:io';

import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sendbird_chat_test/src/blocs/blocs.dart';
import 'package:sendbird_chat_test/src/repositories/messaging_repository.dart';
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
      create: (context) => GetIt.I(),
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
          if (state is ChatInitialState) {
            context.read<ChatBloc>().add(
                  ChatStartedEvent(
                    userId: widget.userId,
                    otherId: widget.otherId,
                    channelHandler: ChatEventHandler(
                      userId: widget.userId,
                      otherId: widget.otherId,
                      onMessageReceivedCallback: (message) =>
                          context.read<ChatBloc>().add(
                                ChatMessageReceivedEvent(
                                  userId: widget.userId,
                                  otherId: widget.otherId,
                                  message: message,
                                ),
                              ),
                    ),
                  ),
                );
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  CircularProgressIndicator(),
                ],
              ),
            );
          } else if (state is ChatLoadFailure) {
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
                onSendPressed: _handleSendPressed,
                onAttachmentPressed: _handleAttachmentPressed,
                user: types.User(
                  id: widget.userId,
                  firstName: widget.userId,
                ),
              ),
            );
          }
          return Container();
        },
      ),
    );
  }

  void _handleSendPressed(types.PartialText partialText) {
    context.read<ChatBloc>().add(
          ChatTextMessageSendedEvent(
            userId: widget.userId,
            otherId: widget.otherId,
            message: partialText.text,
          ),
        );
  }

  void _handleAttachmentPressed() async {
    final image = await ImagePicker().pickImage(
      imageQuality: 70,
      maxWidth: 1440,
      source: ImageSource.gallery,
    );

    if (image != null) {
      context.read<ChatBloc>().add(
            ChatFileMessageSendedEvent(
              userId: widget.userId,
              otherId: widget.otherId,
              filename: image.name,
              file: File(image.path),
            ),
          );
    }
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
              id: message.sender?.userId ?? 'unknown',
            ),
            text: message.message,
            createdAt: message.createdAt,
            updatedAt: message.updatedAt,
          );
        } else if (message is sendbird.FileMessage) {
          return types.ImageMessage(
            id: message.messageId.toString(),
            author: types.User(
              id: message.sender?.userId ?? 'unknown',
            ),
            name: message.name!,
            size: message.size ?? 0,
            uri: message.localFile?.path ?? message.secureUrl ?? message.url,
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

class ChatEventHandler with sendbird.ChannelEventHandler {
  final String userId;
  final String otherId;
  final void Function(sendbird.BaseMessage message) onMessageReceivedCallback;

  ChatEventHandler({
    required this.userId,
    required this.otherId,
    required this.onMessageReceivedCallback,
  });

  bool isForChat(sendbird.GroupChannel chat) {
    MessagingRepository repository = GetIt.I();
    return chat.channelUrl == repository.buildPrivateChatUrl(userId, otherId);
  }

  @override
  void onMessageReceived(
      sendbird.BaseChannel channel, sendbird.BaseMessage message) {
    if (channel is sendbird.GroupChannel && isForChat(channel)) {
      onMessageReceivedCallback(message);
    }
  }
}

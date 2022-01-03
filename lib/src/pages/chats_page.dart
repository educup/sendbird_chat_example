import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:sendbird_chat_test/src/blocs/blocs.dart';
import 'package:sendbird_chat_test/src/pages/new_chat_page.dart';
import 'package:sendbird_sdk/sendbird_sdk.dart';

class ChatsPage extends StatelessWidget {
  const ChatsPage({
    Key? key,
    required this.userId,
  }) : super(
          key: key,
        );

  static BeamPage getPage(BuildContext context, String userId) {
    final key = ValueKey(userId);
    return BeamPage(
      key: key,
      title: "$userId's Chats",
      child: ChatsPage(
        userId: userId,
      ),
    );
  }

  final String userId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ChatsListBloc>(
      create: (context) => GetIt.I()
        ..add(
          ChatsListStarted(
            userId: userId,
          ),
        ),
      child: ChatsPageWidget(
        userId: userId,
      ),
    );
  }
}

class ChatsPageWidget extends StatefulWidget {
  const ChatsPageWidget({
    Key? key,
    required this.userId,
  }) : super(key: key);

  final String userId;

  @override
  State<ChatsPageWidget> createState() => _ChatsPageWidgetState();
}

class _ChatsPageWidgetState extends State<ChatsPageWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chats'),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          final result = await Navigator.push<String>(
            context,
            MaterialPageRoute(
              builder: (context) => const NewChatPage(),
            ),
          );
          if (result != null && result.isNotEmpty) {
            context.read<ChatsListBloc>().add(
                  ChatsListNewChatPressed(
                      userId: widget.userId, otherUserId: result),
                );
          }
        },
      ),
      body: BlocConsumer<ChatsListBloc, ChatsListState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state is ChatsListLoadFailure) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: ${state.message}'),
                ],
              ),
            );
          } else if (state is ChatsListLoadSuccess) {
            if (state.chats.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text('No chats found'),
                  ],
                ),
              );
            } else {
              return SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    for (final chat in state.chats) buildChatPreview(chat),
                  ],
                ),
              );
            }
          } else if (state is ChatsListLoadInProgress) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  CircularProgressIndicator(),
                ],
              ),
            );
          }
          return Container();
        },
      ),
    );
  }

  Widget buildChatPreview(GroupChannel chat) {
    String chatCompanionId = 'Someone';
    for (final member in chat.members) {
      if (member.userId != widget.userId) {
        chatCompanionId = member.userId;
        break;
      }
    }

    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () {},
            child: Card(
              margin: const EdgeInsets.symmetric(
                vertical: 5,
                horizontal: 5,
              ),
              child: Container(
                height: 100,
                margin: const EdgeInsets.all(5),
                child: Text('Chat with $chatCompanionId'),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

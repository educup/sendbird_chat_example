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
      create: (context) => GetIt.I(),
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
                      userId: widget.userId, otherId: result),
                );
          }
        },
      ),
      body: BlocConsumer<ChatsListBloc, ChatsListState>(
        listener: (context, state) {
          if (state is ChatsListLoadSuccessWithNotification) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.notification),
                action: SnackBarAction(
                  label: 'Close',
                  onPressed: () {},
                ),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is ChatsListInitialState) {
            context.read<ChatsListBloc>().add(
                  ChatsListStarted(
                    userId: widget.userId,
                  ),
                );
            return _buildLoading();
          } else if (state is ChatsListLoadFailure) {
            return _buildError(state);
          } else if (state is ChatsListLoadSuccess) {
            if (state.chats.isEmpty) {
              return _buildEmptyChatsList();
            } else {
              return _buildChatsList(state);
            }
          } else if (state is ChatsListLoadInProgress) {
            return _buildLoading();
          }
          return Container();
        },
      ),
    );
  }

  Widget _buildError(ChatsListLoadFailure state) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Error: ${state.errorMessage}'),
        ],
      ),
    );
  }

  Widget _buildChatsList(ChatsListLoadSuccess state) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          for (final chat in state.chats) _buildChatPreview(chat),
        ],
      ),
    );
  }

  Widget _buildEmptyChatsList() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Text('No chats found'),
        ],
      ),
    );
  }

  Widget _buildLoading() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          CircularProgressIndicator(),
        ],
      ),
    );
  }

  Widget _buildChatPreview(GroupChannel chat) {
    String? chatCompanionId;
    for (final member in chat.members) {
      if (member.userId != widget.userId) {
        chatCompanionId = member.userId;
        break;
      }
    }

    if (chatCompanionId == null) return Container();

    double previewWidth = MediaQuery.of(context).size.width - 20;

    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () {
              context.beamToNamed('/${widget.userId}/chats/$chatCompanionId');
            },
            child: Card(
              margin: const EdgeInsets.symmetric(
                vertical: 8,
                horizontal: 10,
              ),
              child: Container(
                height: 70,
                margin: const EdgeInsets.all(5),
                child: SizedBox(
                  width: previewWidth,
                  child: Row(
                    children: [
                      SizedBox(
                        width: 70,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: chat.coverUrl != null
                              ? Image.network(chat.coverUrl!)
                              : Image.asset('default_channel_image.png'),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          mainAxisSize: MainAxisSize.max,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              chatCompanionId,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: Text(
                                    chat.lastMessage?.message ?? '',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                if (chat.unreadMessageCount > 0)
                                  Container(
                                    height: 31,
                                    decoration: BoxDecoration(
                                      color: Colors.blue,
                                      borderRadius: BorderRadius.circular(100),
                                    ),
                                    child: Center(
                                      child: Container(
                                        margin: const EdgeInsets.symmetric(
                                          horizontal: 3,
                                        ),
                                        child: Text(
                                          chat.unreadMessageCount.toString(),
                                          style: const TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

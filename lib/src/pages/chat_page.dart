import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:sendbird_chat_test/src/blocs/blocs.dart';

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
          ChatEventStarted(
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
          }
          return Container();
        },
      ),
    );
  }
}

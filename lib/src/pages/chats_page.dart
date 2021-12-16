import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';

class ChatsPage extends StatefulWidget {
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
        ));
  }

  final String userId;

  @override
  State<ChatsPage> createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Hello ${widget.userId}!'),
          ],
        ),
      ),
    );
  }
}

import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:sendbird_chat_test/src/utils/utils.dart';

class NewChatPage extends StatefulWidget {
  const NewChatPage({
    Key? key,
  }) : super(key: key);

  static BeamPage getPage(BuildContext context) {
    const key = ValueKey('new_chat');
    return const BeamPage(
      key: key,
      title: 'New Chat',
      child: NewChatPage(
        key: key,
      ),
    );
  }

  @override
  State<NewChatPage> createState() => _NewChatPageState();
}

class _NewChatPageState extends State<NewChatPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: '');
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(Constants.homeTitle),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  TextFormField(
                    controller: controller,
                    decoration: const InputDecoration(
                      labelText: 'New Chat with:',
                      hintText: 'User Name',
                    ),
                    validator: (value) => (value == null || value.isEmpty)
                        ? 'User Name must not be empty!'
                        : null,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      bool status = _formKey.currentState?.validate() ?? false;
                      if (status) {
                        final userID = controller.text;
                        Navigator.pop(context, userID);
                      }
                    },
                    child: const Text('Create Chat'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:sendbird_chat_test/src/utils/utils.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    Key? key,
  }) : super(key: key);

  static BeamPage getPage(BuildContext context) {
    const key = ValueKey('home');
    return const BeamPage(
      key: key,
      title: Constants.homeTitle,
      child: HomePage(
        key: key,
      ),
    );
  }

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
                      hintText: 'User Name',
                      labelText: 'User Name',
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
                        context.beamToNamed('$userID/chats');
                      }
                    },
                    child: const Text('Go to Chats'),
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

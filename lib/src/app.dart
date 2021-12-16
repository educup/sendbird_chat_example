import 'package:beamer/beamer.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:sendbird_chat_test/src/pages/pages.dart';
import 'package:sendbird_chat_test/src/router/router.dart';
import 'package:sendbird_chat_test/src/utils/constants.dart';

class CustomScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.stylus,
        PointerDeviceKind.invertedStylus,
        PointerDeviceKind.mouse,
        PointerDeviceKind.unknown,
      };
}

class SendBirdExampleApp extends StatelessWidget {
  const SendBirdExampleApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BeamerProvider(
      routerDelegate: AppRouter.routerDelegate,
      child: MaterialApp.router(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          routeInformationParser: AppRouter.routeInformationParser,
          routerDelegate: AppRouter.routerDelegate),
    );
  }
}

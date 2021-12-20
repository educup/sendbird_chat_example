import 'dart:async';
import 'dart:developer';

import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:sendbird_chat_test/src/app.dart';
import 'package:sendbird_chat_test/src/dependencies.dart';

void main() async {
  FlutterError.onError = (details) {
    log(details.exceptionAsString(), stackTrace: details.stack);
  };

  await runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      Beamer.setPathUrlStrategy();
      await configureDependencies();
      runApp(const SendBirdExampleApp());
    },
    (error, stackTrace) {},
  );
}

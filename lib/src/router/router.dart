import 'dart:developer';

import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:sendbird_chat_test/src/router/locations/locations.dart';

class AppRouter {
  static final routerDelegate = BeamerDelegate(
    routeListener: _listener,
    locationBuilder: BeamerLocationBuilder(
      beamLocations: [
        HomeLocation(),
      ],
    ),
    initialPath: '/',
  );

  static void _listener(
    RouteInformation routeInformation,
    BeamerDelegate delegate,
  ) {
    log('BeamTo: ${routeInformation.location}');
  }

  static final routeInformationParser = BeamerParser();

  static final backButtonDispatcher = BeamerBackButtonDispatcher(
    delegate: routerDelegate,
    fallbackToBeamBack: false,
  );
}

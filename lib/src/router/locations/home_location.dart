import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:sendbird_chat_test/src/pages/pages.dart';

class HomeLocation extends BeamLocation {
  @override
  List<BeamPage> buildPages(
    BuildContext context,
    RouteInformationSerializable state,
  ) =>
      [
        HomePage.getPage(context),
      ];

  @override
  List<Pattern> get pathPatterns => [
        '/',
      ];
}

import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:sendbird_chat_test/src/pages/pages.dart';

class HomeLocation extends BeamLocation<BeamState> {
  @override
  List<BeamPage> buildPages(
    BuildContext context,
    BeamState state,
  ) =>
      [
        HomePage.getPage(context),
      ];

  @override
  List<Pattern> get pathPatterns => [
        '/',
      ];
}

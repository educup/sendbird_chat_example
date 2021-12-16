import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:sendbird_chat_test/src/pages/pages.dart';
import 'package:sendbird_chat_test/src/router/locations/locations_utils.dart';

// ignore: constant_identifier_names
const String USER_ID = 'user_id';

class ChatsLocation extends BeamLocation<BeamState> {
  @override
  List<BeamPage> buildPages(
    BuildContext context,
    BeamState state,
  ) {
    final List<BeamPage> pages = [
      HomePage.getPage(context),
    ];

    final userId = state.pathParameters[USER_ID];

    if (userId != null) {
      if (state.lenGreaterThan(1) && state.matchSegment(1, 'chats')) {
        pages.add(ChatsPage.getPage(context, userId));
      }
    }

    return pages;
  }

  @override
  List<Pattern> get pathPatterns => [
        '/',
        '/:$USER_ID/chats',
      ];
}

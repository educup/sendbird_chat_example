// ignore_for_file: constant_identifier_names

import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:sendbird_chat_test/src/pages/pages.dart';
import 'package:sendbird_chat_test/src/router/locations/locations_utils.dart';

const String USER_ID = 'user_id';
const String OTHER_ID = 'other_id';

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

        final otherId = state.pathParameters[OTHER_ID];
        if (otherId != null) {
          pages.add(ChatPage.getPage(context, userId, otherId));
        }
      }
    }

    return pages;
  }

  @override
  List<Pattern> get pathPatterns => [
        '/',
        '/:$USER_ID/chats',
        '/:$USER_ID/chats/:$OTHER_ID',
      ];
}

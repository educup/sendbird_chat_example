import 'dart:io';
import 'package:injectable/injectable.dart';
import 'package:sendbird_sdk/sendbird_sdk.dart';

@lazySingleton
class MessagingRepository {
  MessagingRepository({
    @Named('sendbird-app-id') required String appId,
  }) {
    sendbirdSdk = SendbirdSdk(
      appId: appId,
    );
  }

  late final SendbirdSdk sendbirdSdk;

  Future<User> connect(String userId) async {
    return sendbirdSdk.connect(userId);
  }

  Future<GroupChannel> createPrivateChat(
    String userId1,
    String userId2,
  ) {
    final pvUrl = buildPrivateChatUrl(userId1, userId2);
    final params = GroupChannelParams()
      ..channelUrl = pvUrl
      ..userIds = [userId1, userId2]
      ..isDistinct = true;
    return GroupChannel.createChannel(params);
  }

  Future<GroupChannel> getPrivateChat(
    String userId1,
    String userId2,
  ) {
    final pvUrl = buildPrivateChatUrl(userId1, userId2);
    return GroupChannel.getChannel(pvUrl);
  }

  //TODO: Update getPrivateChats to work like historical messages
  Future<List<GroupChannel>> getPrivateChats(
    String userId,
  ) {
    final query = GroupChannelListQuery()
      ..userIdsIncludeIn = [userId]
      ..order = GroupChannelListOrder.latestLastMessage;
    return query.loadNext();
  }

  Future<UserMessage> sendMessage(
    GroupChannel groupChannel,
    String message, {
    int? replyTo,
  }) async {
    final params = UserMessageParams(message: message)
      ..parentMessageId = replyTo;
    final userMessage = groupChannel.sendUserMessage(
      params,
    );
    return userMessage;
  }

  Future<FileMessage> sendFile(
    GroupChannel groupChannel,
    File file, {
    String? filename,
    int? replyTo,
  }) async {
    final params = FileMessageParams.withFile(
      file,
      name: filename,
    )..parentMessageId = replyTo;
    final fileMessage = groupChannel.sendFileMessage(
      params,
    );
    return fileMessage;
  }

  String buildPrivateChatUrl(
    String id1,
    String id2,
  ) {
    String? first;
    String? last;

    final compare = id1.compareTo(id2);
    if (compare < 0) {
      first = id1;
      last = id2;
    } else {
      first = id2;
      last = id1;
    }

    return 'pv-$first-$last';
  }

  PreviousMessageListQuery getHistoricalMessages(
    String userId1,
    String userId2, {
    int limit = 30,
    bool reverse = true,
  }) {
    final channelUrl = buildPrivateChatUrl(userId1, userId2);
    final messagesQuery = PreviousMessageListQuery(
      channelType: ChannelType.group,
      channelUrl: channelUrl,
    )
      ..limit = limit
      ..reverse = reverse
      ..includeReplies = true
      ..includeParentMessageInfo = true;
    return messagesQuery;
  }

  void registerChannelEventHandler(
      ChannelEventHandler handler, String handlerId) {
    sendbirdSdk.addChannelEventHandler(handlerId, handler);
  }

  void removeChannelEventHandler(String handlerId) {
    sendbirdSdk.removeChannelEventHandler(handlerId);
  }
}

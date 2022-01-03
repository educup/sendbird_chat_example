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
    final pvUrl = _buildPrivateChatUrl(userId1, userId2);
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
    final pvUrl = _buildPrivateChatUrl(userId1, userId2);
    return GroupChannel.getChannel(pvUrl);
  }

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
    final premessage = groupChannel.sendUserMessage(
      params,
    );
    return premessage;
  }

  String _buildPrivateChatUrl(
    String id1,
    String id2,
  ) {
    return 'pv-$id1-$id2';
  }
}

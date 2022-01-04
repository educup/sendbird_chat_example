// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;
import 'package:sendbird_chat_test/src/blocs/chat_bloc/chat_bloc.dart' as _i3;
import 'package:sendbird_chat_test/src/blocs/chats_list_bloc/chats_list_bloc.dart'
    as _i6;
import 'package:sendbird_chat_test/src/dependencies.dart' as _i7;
import 'package:sendbird_chat_test/src/repositories/messaging_repository.dart'
    as _i5;
import 'package:sendbird_chat_test/src/repositories/repositories.dart'
    as _i4; // ignore_for_file: unnecessary_lambdas

// ignore_for_file: lines_longer_than_80_chars
/// initializes the registration of provided dependencies inside of [GetIt]
_i1.GetIt $initGetIt(_i1.GetIt get,
    {String? environment, _i2.EnvironmentFilter? environmentFilter}) {
  final gh = _i2.GetItHelper(get, environment, environmentFilter);
  final registerModule = _$RegisterModule();
  gh.factory<_i3.ChatBloc>(
      () => _i3.ChatBloc(messagingRepository: get<_i4.MessagingRepository>()));
  gh.factory<String>(() => registerModule.sendBirdAppId,
      instanceName: 'sendbird-app-id');
  gh.lazySingleton<_i5.MessagingRepository>(() => _i5.MessagingRepository(
      appId: get<String>(instanceName: 'sendbird-app-id')));
  gh.factory<_i6.ChatsListBloc>(() =>
      _i6.ChatsListBloc(messagingRepository: get<_i5.MessagingRepository>()));
  return get;
}

class _$RegisterModule extends _i7.RegisterModule {}

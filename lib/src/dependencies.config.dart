// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;
import 'package:sendbird_chat_test/src/dependencies.dart' as _i4;
import 'package:sendbird_chat_test/src/repositories/messaging_repository.dart'
    as _i3; // ignore_for_file: unnecessary_lambdas

// ignore_for_file: lines_longer_than_80_chars
/// initializes the registration of provided dependencies inside of [GetIt]
_i1.GetIt $initGetIt(_i1.GetIt get,
    {String? environment, _i2.EnvironmentFilter? environmentFilter}) {
  final gh = _i2.GetItHelper(get, environment, environmentFilter);
  final registerModule = _$RegisterModule();
  gh.factory<String>(() => registerModule.sendBirdAppId,
      instanceName: 'sendbird-app-id');
  gh.lazySingleton<_i3.MessagingRepository>(() => _i3.MessagingRepository(
      appId: get<String>(instanceName: 'sendbird-app-id')));
  return get;
}

class _$RegisterModule extends _i4.RegisterModule {}

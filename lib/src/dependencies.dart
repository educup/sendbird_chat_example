import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:sendbird_chat_test/src/dependencies.config.dart';

@InjectableInit(preferRelativeImports: false)
Future<void> configureDependencies() async => $initGetIt(GetIt.I);

@module
abstract class RegisterModule {
  @Named('sendbird-app-id')
  String get sendBirdAppId {
    return const String.fromEnvironment(
      'sendbird-app-id',
      defaultValue: '',
    );
  }
}

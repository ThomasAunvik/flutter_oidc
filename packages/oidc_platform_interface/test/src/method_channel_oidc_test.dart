import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:oidc_platform_interface/src/method_channel_oidc.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const kPlatformName = 'platformName';

  group('$MethodChannelOidc', () {
    late MethodChannelOidc methodChannelOidc;
    final log = <MethodCall>[];

    setUp(() async {
      methodChannelOidc = MethodChannelOidc();
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(
        methodChannelOidc.methodChannel,
        (methodCall) async {
          log.add(methodCall);
          switch (methodCall.method) {
            case MethodChannelOidc.kgetPlatformName:
              return kPlatformName;
            case MethodChannelOidc.kgetAuthorizationResponse:
              return null;
            default:
              return null;
          }
        },
      );
    });

    tearDown(log.clear);

    // test('getPlatformName', () async {
    //   final platformName = await methodChannelOidc.getPlatformName();
    //   expect(
    //     log,
    //     <Matcher>[isMethodCall(MethodChannelOidc.kgetPlatformName 'getPlatformName', arguments: null)],
    //   );
    //   expect(platformName, equals(kPlatformName));
    // });

    test('getAuth', () {
      // final resp = await methodChannelOidc.getAuthorizationResponse(metadata, request, options,);
      // expect(
      //   log,
      //   <Matcher>[isMethodCall(MethodChannelOidc.kgetAuthorizationResponse, arguments: null)],
      // );
      // expect(platformName, equals(kPlatformName));
    });
  });
}

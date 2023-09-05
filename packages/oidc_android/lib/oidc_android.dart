import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:oidc_core/oidc_core.dart';
import 'package:oidc_platform_interface/oidc_platform_interface.dart';

/// The Android implementation of [OidcPlatform].
class OidcAndroid extends OidcPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('oidc_android');

  /// Registers this class as the default instance of [OidcPlatform]
  static void registerWith() {
    OidcPlatform.instance = OidcAndroid();
  }

  // @override
  // Future<String?> getPlatformName() {
  //   return methodChannel.invokeMethod<String>('getPlatformName');
  // }

  @override
  Future<OidcAuthorizeResponse?> getAuthorizationResponse(
    OidcProviderMetadata metadata,
    OidcAuthorizeRequest request,
    OidcStore store,
    OidcAuthorizePlatformOptions options,
  ) async {
    const appAuth = FlutterAppAuth();
    final authorizationEndpoint = metadata.authorizationEndpoint;
    final tokenEndpoint = metadata.tokenEndpoint;
    if (authorizationEndpoint == null || tokenEndpoint == null) {
      throw const OidcException(
        'OIDC provider MUST declare an '
        'authorization endpoint and a token endpoint',
      );
    }
    final resp = await appAuth.authorize(
      AuthorizationRequest(
        request.clientId,
        request.redirectUri.toString(),
        serviceConfiguration: AuthorizationServiceConfiguration(
          authorizationEndpoint: authorizationEndpoint.toString(),
          tokenEndpoint: tokenEndpoint.toString(),
          endSessionEndpoint: metadata.endSessionEndpoint?.toString(),
        ),
        additionalParameters:
            request.extra.map((key, value) => MapEntry(key, value.toString())),
        issuer: metadata.issuer?.toString(),
        loginHint: request.loginHint,
        nonce: request.nonce,
        promptValues: request.prompt,
        scopes: request.scope,
        responseMode: request.responseMode,
        allowInsecureConnections: options.android.allowInsecureConnections,
        preferEphemeralSession: options.android.preferEphemeralSession,
      ),
    );
    if (resp == null) {
      return null;
    }
    return OidcAuthorizeResponse.fromJson({
      OidcAuthorizeResponse.kcode: resp.authorizationCode,
      OidcConstants_PKCE.codeVerifier: resp.codeVerifier,
      OidcConstants_AuthorizeRequest.nonce: resp.nonce,
      ...?resp.authorizationAdditionalParameters,
    });
  }

  // @override
  // Future<Uri?> getAuthorizationResponse(String state) async {

  // }
}

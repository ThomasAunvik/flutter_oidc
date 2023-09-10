import 'package:json_annotation/json_annotation.dart';
import 'package:oidc_core/src/constants.dart';
import 'package:oidc_core/src/converters.dart';
import 'package:oidc_core/src/models/json_based_object.dart';
import 'package:oidc_core/src/utils.dart';

part 'resp.g.dart';

const _implicitWarning =
    'This parameter is only usable in the implicit flow, which is deprecated.';

/// Successful Authentication Response
@JsonSerializable(
  createFactory: true,
  createToJson: false,
  converters: OidcInternalUtilities.commonConverters,
  constructor: '_',
)
class OidcAuthorizeResponse extends JsonBasedResponse {
  ///
  const OidcAuthorizeResponse._({
    required super.src,
    this.codeVerifier,
    this.redirectUri,
    this.code,
    this.sessionState,
    this.state,
    this.iss,
    this.nonce,
    this.scope = const [],
    @Deprecated(_implicitWarning) this.tokenType,
    @Deprecated(_implicitWarning) this.expiresIn,
    @Deprecated(_implicitWarning) this.accessToken,
    @Deprecated(_implicitWarning) this.idToken,
  });

  ///
  factory OidcAuthorizeResponse.fromJson(Map<String, dynamic> src) =>
      _$OidcAuthorizeResponseFromJson(src);

  @JsonKey(name: OidcConstants_AuthParameters.state)
  final String? state;

  @JsonKey(name: OidcConstants_AuthParameters.sessionState)
  final String? sessionState;

  /// OPTIONAL.
  ///
  /// The identifier of the authorization server which the client can use to
  /// prevent mixup attacks, if the client interacts with more than one
  /// authorization server.
  ///
  ///  See [RFC9207](https://www.rfc-editor.org/rfc/rfc9207.html) for additional details on when this parameter is necessary, and how the client can use it to prevent mixup attacks.
  @JsonKey(name: OidcConstants_AuthParameters.iss)
  final Uri? iss;

  /// REQUIRED, if the request_type was code.
  ///
  /// The authorization code generated by the authorization server.
  ///
  /// The authorization code MUST expire shortly after it is issued to
  /// mitigate the risk of leaks.
  ///
  /// A maximum authorization code lifetime of 10 minutes is RECOMMENDED.
  ///
  /// The client MUST NOT use the authorization code
  @JsonKey(name: OidcConstants_AuthParameters.code)
  final String? code;
  @JsonKey(name: OidcConstants_AuthParameters.codeVerifier)
  final String? codeVerifier;
  @JsonKey(name: OidcConstants_AuthParameters.nonce)
  final String? nonce;
  @JsonKey(name: OidcConstants_AuthParameters.redirectUri)
  final Uri? redirectUri;
  @JsonKey(
    name: OidcConstants_AuthParameters.scope,
    fromJson: OidcInternalUtilities.splitSpaceDelimitedString,
  )
  final List<String> scope;

  @Deprecated(_implicitWarning)
  @JsonKey(name: OidcConstants_AuthParameters.accessToken)
  final String? accessToken;

  @Deprecated(_implicitWarning)
  @JsonKey(name: OidcConstants_AuthParameters.idToken)
  final String? idToken;

  @Deprecated(_implicitWarning)
  @JsonKey(name: OidcConstants_AuthParameters.tokenType)
  final String? tokenType;

  @Deprecated(_implicitWarning)
  @JsonKey(
    name: OidcConstants_AuthParameters.expiresIn,
    readValue: OidcInternalUtilities.readDurationSeconds,
  )
  final Duration? expiresIn;
}

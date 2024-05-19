typedef AuthenticatorPayload = ({
  String userId,
  String email,
});

abstract interface class JWTAuthenticator {
  String generateToken({
    required String userId,
    required String email,
  });

  AuthenticatorPayload? getPayloadFromToken({
    required String token,
  });
}

abstract interface class JWTAuthenticator {
  String generateToken({
    required String userId,
    required String email,
  });
}

import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:dotenv/dotenv.dart';
import 'package:injectable/injectable.dart';
import 'package:ribbit_server/src/app/integration/jwt_authenticator.dart';

@Singleton(as: JWTAuthenticator)
final class JWTAuthenticatorImpl implements JWTAuthenticator {
  JWTAuthenticatorImpl._(String jwtSecret) : _jwtSecret = SecretKey(jwtSecret);

  final SecretKey _jwtSecret;

  @FactoryMethod(preResolve: true)
  static Future<JWTAuthenticatorImpl> init(
    DotEnv dotEnv,
  ) async {
    final secret = dotEnv['JWT_SECRET'];
    if (secret == null) {
      throw Exception(
        'Could not load JWTAuthenticator, no secret available in env',
      );
    }
    return JWTAuthenticatorImpl._(
      secret,
    );
  }

  @override
  String generateToken({
    required String userId,
    required String email,
  }) =>
      JWT(
        {
          'user_id': userId,
          'email': email,
        },
      ).sign(_jwtSecret);

  @override
  AuthenticatorPayload? getPayloadFromToken({required String token}) {
    final payloadData = JWT.verify(token, _jwtSecret).payload;

    if (payloadData is! Map) {
      return null;
    }

    final (userId, email) = (payloadData['user_id'], payloadData['email']);

    if ((userId, email) case (String(), String())) {
      return (
        userId: userId,
        email: email,
      );
    }

    return null;
  }
}

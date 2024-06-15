import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';
import 'package:ribbit_middle_end/ribbit_middle_end.dart';

part 'rest_client.g.dart';

@RestApi(parser: Parser.FlutterCompute)
abstract class RestClientBase {
  factory RestClientBase(Dio dio) = _RestClientBase;

  @POST('/create_user')
  Future<CreateUserResponse> createUser(
    CreateUserRequest request,
  );

  @POST('/login_user')
  Future<LoginUserResponse> loginUser(
    LoginUserRequest request,
  );

  @DELETE('/delete_own_user_account')
  Future<DeleteOwnUserAccountResponse> deleteOwnUserAccount();
}

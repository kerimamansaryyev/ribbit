import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/http.dart';
import 'package:ribbit_middle_end/ribbit_middle_end.dart';

part 'rest_client.g.dart';

@RestApi(parser: Parser.FlutterCompute)
abstract interface class RestClientBase {
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

@injectable
base class BaseRestClient extends _RestClientBase {
  BaseRestClient(
    this.internalClient,
  ) : super(internalClient);

  @protected
  final Dio internalClient;
}

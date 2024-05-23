import 'package:ribbit_server/src/app/repository/user_repository.dart';

sealed class CreateUserResult {}

final class CreateUserAlreadyExists implements CreateUserResult {
  const CreateUserAlreadyExists();
}

final class CreateUserSuccessfullyCreated implements CreateUserResult {
  const CreateUserSuccessfullyCreated({
    required this.user,
  });

  final UserRepositoryCreateUserDTO user;
}

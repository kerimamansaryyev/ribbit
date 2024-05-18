import 'package:ribbit_server/src/prisma/generated/model.dart';

sealed class CreateUserResult {}

final class CreateUserAlreadyExists implements CreateUserResult {
  const CreateUserAlreadyExists();
}

final class CreateUserSuccessfullyCreated implements CreateUserResult {
  const CreateUserSuccessfullyCreated({
    required this.user,
  });

  final User user;
}

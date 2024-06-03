typedef UserRepositoryCreateUserDTO = ({
  String id,
  String email,
});

typedef UserRepositoryValidateUserCredentialsDTO = ({
  String id,
  String email,
});

final class UserRepositoryGetUserByIdDTO {
  const UserRepositoryGetUserByIdDTO({
    required this.email,
    required this.id,
  });

  final String id;
  final String email;
}

abstract interface class UserRepository {
  Future<UserRepositoryCreateUserDTO> createUser({
    required String email,
    required String password,
  });

  Future<UserRepositoryValidateUserCredentialsDTO> validateUserCredentials({
    required String email,
    required String password,
  });

  Future<UserRepositoryGetUserByIdDTO?> getUserByUserId({
    required String userId,
  });

  Future<void> deleteUserById({
    required String userId,
  });
}

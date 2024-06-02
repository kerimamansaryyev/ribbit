typedef UserRepositoryCreateUserDTO = ({
  String id,
  String email,
  String name,
});

typedef UserRepositoryValidateUserCredentialsDTO = ({
  String id,
  String email,
  String name,
});

final class UserRepositoryGetUserByIdDTO {
  const UserRepositoryGetUserByIdDTO({
    required this.name,
    required this.email,
    required this.id,
  });

  final String id;
  final String email;
  final String name;
}

abstract interface class UserRepository {
  Future<UserRepositoryCreateUserDTO> createUser({
    required String email,
    required String password,
    required String name,
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

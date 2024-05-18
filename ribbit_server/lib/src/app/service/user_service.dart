/// Returned with [UserService.createUser]
typedef UserServiceCreateUserDTO = ({
  String userId,
  String email,
  String firstName,
  String accessToken,
});

/// Service responsible for User
abstract interface class UserService {
  /// Creating user and saving in repository
  Future<UserServiceCreateUserDTO> createUser({
    required String email,
    required String firstName,
  });
}

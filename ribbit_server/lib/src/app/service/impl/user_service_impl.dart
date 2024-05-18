import 'package:injectable/injectable.dart';
import 'package:orm/orm.dart';
import 'package:ribbit_server/src/app/service/user_service.dart';
import 'package:ribbit_server/src/prisma/generated/client.dart';
import 'package:ribbit_server/src/prisma/generated/prisma.dart';

/// Implementation of [UserService]
@Singleton(as: UserService)
final class UserServiceImpl implements UserService {
  /// Injecting prismaClient to use as DAO
  const UserServiceImpl({
    required this.prismaClient,
  });

  /// Using PrismaClient as DAO
  final PrismaClient prismaClient;

  @override
  Future<UserServiceCreateUserDTO> createUser({
    required String email,
    required String firstName,
  }) async {
    try {
      final user = await prismaClient.user.findMany();
      print(user);
    } catch (e) {
      print(e);
    }

    return (
      userId: 'user.id!',
      firstName: 'user.firstName!',
      email: 'user.email!',
      accessToken: '',
    );
  }
}

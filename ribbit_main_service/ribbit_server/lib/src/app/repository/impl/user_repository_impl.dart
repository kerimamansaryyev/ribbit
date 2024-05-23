import 'dart:async';

import 'package:injectable/injectable.dart';
import 'package:orm/orm.dart';
import 'package:ribbit_middle_end/ribbit_middle_end.dart';
import 'package:ribbit_server/src/app/repository/mixin/base_repository_mixin.dart';
import 'package:ribbit_server/src/app/repository/mixin/encrypted_repository_mixin.dart';
import 'package:ribbit_server/src/app/repository/user_repository.dart';
import 'package:ribbit_server/src/app/service/result/create_user_result.dart';
import 'package:ribbit_server/src/app/service/result/delete_user_result.dart';
import 'package:ribbit_server/src/app/service/result/validate_user_credentials_result.dart';
import 'package:ribbit_server/src/prisma/generated/client.dart';
import 'package:ribbit_server/src/prisma/generated/prisma.dart';

/// Implementation of [UserRepository] via [PrismaClient]
@Singleton(as: UserRepository)
final class UserRepositoryImpl
    with BaseRepositoryMixin, EncryptedRepositoryMixin
    implements UserRepository {
  @override
  Future<CreateUserResult> createUser({
    required String email,
    required String password,
    required String firstName,
  }) =>
      preventConnectionLeak(() async {
        final tx = await prismaClient.$transaction.start();
        try {
          final user = await tx.user.findUnique(
            where: UserWhereUniqueInput(
              email: email,
            ),
            include: const UserInclude(
              reminders: PrismaUnion.$1(false),
            ),
          );

          if (user != null) {
            await tx.$transaction.commit();
            return const CreateUserAlreadyExists();
          }

          final invalidInput = validateInputs(
            [
              InputValidators.userEmail(email),
              InputValidators.userPassword(password),
            ],
          );

          if (invalidInput != null) {
            await tx.$transaction.commit();
            return CreateUserInvalidInput(
              fieldName: invalidInput.fieldName,
            );
          }

          final createdUser = await tx.user.create(
            data: PrismaUnion.$1(
              UserCreateInput(
                email: email,
                password: hasString(password),
                firstName: firstName,
              ),
            ),
          );

          final result = CreateUserSuccessfullyCreated(
            user: (
              id: createdUser.id!,
              email: createdUser.email!,
              firstName: createdUser.firstName!,
            ),
          );

          await tx.$transaction.commit();

          return result;
        } catch (_) {
          await tx.$transaction.rollback();
          rethrow;
        }
      });

  @override
  Future<ValidateUserCredentialsResult> validateUserCredentials({
    required String email,
    required String password,
  }) =>
      preventConnectionLeak(
        () async {
          final user = await prismaClient.user.findUnique(
            where: UserWhereUniqueInput(
              email: email,
            ),
            include: const UserInclude(
              reminders: PrismaUnion.$1(false),
            ),
          );

          final userPassword = user?.password;

          if (user == null ||
              userPassword == null ||
              !validateString(given: password, hashed: userPassword)) {
            return const ValidateUserCredentialsNotValid();
          }

          return ValidateUserCredentialsSucceeded(
            user: (
              id: user.id!,
              email: user.email!,
              firstName: user.firstName!
            ),
          );
        },
      );

  @override
  Future<UserRepositoryGetUserByIdDTO?> getUserByUserId({
    required String userId,
  }) =>
      preventConnectionLeak(
        () async {
          final user = await prismaClient.user.findUnique(
            where: UserWhereUniqueInput(
              id: userId,
            ),
            include: const UserInclude(
              reminders: PrismaUnion.$1(false),
            ),
          );

          if (user == null) {
            return null;
          }

          return UserRepositoryGetUserByIdDTO(
            id: user.id!,
            email: user.email!,
            firstName: user.firstName!,
          );
        },
      );

  @override
  Future<DeleteUserResult> deleteUserById({
    required String userId,
  }) =>
      preventConnectionLeak(() async {
        final tx = await prismaClient.$transaction.start();
        try {
          final user = await tx.user.findUnique(
            where: UserWhereUniqueInput(
              id: userId,
            ),
            include: const UserInclude(
              reminders: PrismaUnion.$1(false),
            ),
          );

          if (user == null) {
            await tx.$transaction.commit();
            return const DeleteUserNotFound();
          }

          await tx.user.delete(
            where: UserWhereUniqueInput(
              id: userId,
            ),
          );
          await tx.$transaction.commit();

          return const DeleteUserDeleted();
        } catch (_) {
          await tx.$transaction.rollback();
          rethrow;
        }
      });
}

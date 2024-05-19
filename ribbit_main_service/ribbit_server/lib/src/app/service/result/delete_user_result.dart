sealed class DeleteUserResult {}

final class DeleteUserDeleted implements DeleteUserResult {
  const DeleteUserDeleted();
}

final class DeleteUserNotFound implements DeleteUserResult {
  const DeleteUserNotFound();
}

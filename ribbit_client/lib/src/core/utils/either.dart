extension EitherExtension<L, R> on Either<L, R> {
  T fold<T>({
    required T Function(L l) left,
    required T Function(R r) right,
  }) {
    return switch (this) {
      Left<L>(left: final l) => left(l),
      Right<R>(right: final r) => right(r),
      // For exhaustive matching purpose
      // Even if the types were not specified explicitly,
      // Left<dynamic> = Left<L> or Right<dynamic> = Right<R>
      // Thus, there at least one match with above 2 expressions
      Left<dynamic>() || Right<dynamic>() => throw StateError('Never happens'),
    };
  }

  Either<T, R> mapLeft<T>(T Function(L l) left) {
    return fold(
      left: (l) => Left(left(l)),
      right: Right.new,
    );
  }

  Either<L, T> mapRight<T>(T Function(R r) right) {
    return fold(
      left: Left.new,
      right: (r) => Right(right(r)),
    );
  }

  L? tryGetLeft() => fold(
        left: (l) => l,
        right: (_) => null,
      );

  R? tryGetRight() => fold(
        left: (_) => null,
        right: (r) => r,
      );

  bool isLeft() => this is Left<L>;

  bool isRight() => this is Right<R>;
}

sealed class Either<L, R> {}

final class Left<T> implements Either<T, Never> {
  const Left(this.left);
  final T left;
}

final class Right<T> implements Either<Never, T> {
  const Right(this.right);
  final T right;
}

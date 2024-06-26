import 'package:flutter_test/flutter_test.dart';
import 'package:ribbit_client/src/core/utils/either.dart';

Either<String, int> success() {
  return const Right(1);
}

Either<String, int> failure() {
  return const Left('failure');
}

void main() {
  test(
    'Never throws state error when one same dynamic types',
    () {
      const Either<dynamic, dynamic> either = Right(true);
      expect(
        either.fold(
          left: (l) => l,
          right: (r) => r,
        ),
        true,
      );
    },
  );
  test(
    'Never throws state error when one is dynamic type',
    () {
      const Either<int, dynamic> either = Right('Some String');
      expect(
        either.fold(
          left: (l) => l,
          right: (r) => r,
        ),
        'Some String',
      );
    },
  );
  test(
    'Never throws state error on same types',
    () {
      const Either<int, int> either = Right(3);
      expect(
        either.fold(
          left: (l) => l,
          right: (r) => r,
        ),
        3,
      );
    },
  );
  test(
    'Must return either "failure" or 1',
    () {
      final successfulResult = success();
      final failureResult = failure();

      expect(
        successfulResult.fold(
          left: (l) => l,
          right: (r) => r,
        ),
        1,
      );

      expect(
        failureResult.fold(
          left: (l) => l,
          right: (r) => r,
        ),
        'failure',
      );
    },
  );
  test(
    'Must give isLeft and isRight respectively',
    () {
      final successfulResult = success();
      final failureResult = failure();

      expect(
        successfulResult.isRight(),
        true,
      );
      expect(
        successfulResult.isLeft(),
        false,
      );

      expect(
        failureResult.isLeft(),
        true,
      );
      expect(
        failureResult.isRight(),
        false,
      );
    },
  );

  test(
    'Must give "success1" on success and "0failure" for failure',
    () {
      final successfulResult = success().mapRight<String>((r) => 'success$r');
      final failureResult = failure().mapLeft<String>((l) => '0$l');

      expect(
        successfulResult.fold(
          left: (l) => l,
          right: (r) => r,
        ),
        'success1',
      );

      expect(
        failureResult.fold(
          left: (l) => l,
          right: (r) => r,
        ),
        '0failure',
      );
    },
  );

  test(
    'Checking tryGet methods',
    () {
      final successfulResult = success().mapRight<String>((r) => 'success$r');
      final failureResult = failure().mapLeft<String>((l) => '0$l');

      expect(
        successfulResult.tryGetLeft(),
        null,
      );

      expect(
        successfulResult.tryGetRight(),
        'success1',
      );

      expect(
        failureResult.tryGetLeft(),
        '0failure',
      );

      expect(
        failureResult.tryGetRight(),
        null,
      );
    },
  );
}

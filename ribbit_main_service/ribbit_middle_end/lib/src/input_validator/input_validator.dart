typedef InputValidatorPredicate<T> = bool Function(T input);

abstract final class InputValidators {
  static InputValidator<String> userEmail(String input) => InputValidator.email(
        'email',
        input,
      );

  static InputValidator<String> userPassword(String input) =>
      InputValidator.password(
        'password',
        input,
      );

  static InputValidator<DateTime?> reminderRemindAtValidator(
    DateTime? inputDate,
  ) =>
      InputValidator(
        fieldName: 'remind_at',
        inputValidatorPredicate: (input) {
          if (input == null) return true;

          final now = DateTime.now();

          return !now.isAfter(input);
        },
        input: inputDate,
      );
}

final class InputValidator<T> {
  const InputValidator({
    required this.fieldName,
    required this.inputValidatorPredicate,
    required this.input,
  });

  final String fieldName;
  final T input;
  final InputValidatorPredicate<T> inputValidatorPredicate;

  bool isValid() => inputValidatorPredicate(input);

  static InputValidator<String> email(
    String fieldName,
    String input,
  ) =>
      InputValidator<String>(
        input: input,
        fieldName: fieldName,
        inputValidatorPredicate: (input) =>
            RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
                .hasMatch(input),
      );

  // ^: Asserts the position at the start of the string.
  // (?=.*[A-Z]): Positive lookahead to ensure at least one uppercase letter.
  // (?=.*[a-z]): Positive lookahead to ensure at least one lowercase letter.
  // (?=.*\d): Positive lookahead to ensure at least one digit.
  // (?=.*[!@#$%^&*(),.?":{}|<>]): Positive lookahead to ensure at least one special character from the specified set.
  //     .{8,}: Ensures the password is at least 8 characters long.
  // $: Asserts the position at the end of the string.
  static InputValidator<String> password(String fieldName, String input) =>
      InputValidator<String>(
        input: input,
        fieldName: fieldName,
        inputValidatorPredicate: (input) => RegExp(
          r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[!@#$%^&*(),.?":{}|<>]).{8,}$',
        ).hasMatch(input),
      );
}

typedef InputValidatorPredicate<T> = bool Function(T input);

typedef RemindAtDateValidationPredicate = bool Function(DateTime? input);

abstract final class InputValidators {
  static InputValidator<String> userEmail({
    required String fieldName,
    required String input,
  }) =>
      InputValidator.email(
        fieldName,
        input,
      );

  static InputValidator<String> userPassword({
    required String input,
    required String fieldName,
  }) =>
      InputValidator.password(
        fieldName,
        input,
      );

  static InputValidator<DateTime?> reminderRemindAtValidator({
    required String fieldName,
    required DateTime? inputDate,
    required RemindAtDateValidationPredicate inputValidationPredicate,
  }) =>
      InputValidator(
        fieldName: fieldName,
        inputValidatorPredicate: inputValidationPredicate,
        input: inputDate,
      );

  static InputValidator<String> firstNameValidator({
    required String fieldName,
    required String input,
  }) =>
      InputValidator.requiredString(
        fieldName,
        input,
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

  static InputValidator<String> requiredString(
    String fieldName,
    String input,
  ) =>
      InputValidator(
        fieldName: fieldName,
        inputValidatorPredicate: (input) => input.trim().isNotEmpty,
        input: input,
      );

  static InputValidator<String> email(
    String fieldName,
    String input,
  ) =>
      InputValidator<String>(
        fieldName: fieldName,
        input: input,
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
        fieldName: fieldName,
        input: input,
        inputValidatorPredicate: (input) => RegExp(
          r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[!@#$%^&*(),.?":{}|<>]).{8,}$',
        ).hasMatch(input),
      );
}

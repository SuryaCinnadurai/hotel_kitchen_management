import 'package:form_field_validator/form_field_validator.dart';

class Validator {
  Validator._();
  static List<FieldValidator<dynamic>> emailValidator = [
    RequiredValidator(errorText: 'Enter email address'),
    EmailValidator(errorText: 'Please enter valid email'),
  ];

  static List<FieldValidator<dynamic>> passwordValidator = [
    RequiredValidator(errorText: 'Please enter Password'),
    MinLengthValidator(8, errorText: 'Password must be atlist 8 digit'),
    PatternValidator(r'(?=.*?[#!@$%^&*-])',
        errorText: 'Password must be atlist one special character')
  ];

  static List<FieldValidator<dynamic>> loginPasswordValidator = [
    RequiredValidator(errorText: 'Please enter Password'),
  ];

  static List<FieldValidator<dynamic>> nameValidator = [
    RequiredValidator(errorText: 'It should not be empty'),
  ];

  static confirmPasswordValidator(String password, String confirmPassword) {
    return [
      PasswordMatchValidator(
          password: password,
          confirmPassword: confirmPassword,
          errorText: "Password doesn't match"),
    ];
  }
}

class PasswordMatchValidator extends FieldValidator {
  PasswordMatchValidator(
      {required String errorText,
      required this.password,
      required this.confirmPassword})
      : super(errorText);
  final String password;
  final String confirmPassword;
  final alphanumeric = RegExp(r'(?=.*?[#!@$%^&*-])');

  @override
  bool isValid(dynamic value) {
    return (alphanumeric.hasMatch(password) && password == confirmPassword);
  }
}

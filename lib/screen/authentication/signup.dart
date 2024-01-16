import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:hotel_kitchen_management/screen/authentication/login.dart';
import 'package:hotel_kitchen_management/screen/common/common_avatar.dart';
import 'package:hotel_kitchen_management/screen/common/common_button.dart';
import 'package:hotel_kitchen_management/screen/utils/color_constant.dart';
import 'package:hotel_kitchen_management/screen/utils/string_constant.dart';
import 'package:hotel_kitchen_management/screen/utils/validator.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formkey = GlobalKey<FormState>();
  bool _passwordVisible = false;
  bool _confirmPasswordVisible = false;
  bool _isCreating = false;
  String _currentSelectedRole = StringConstants.admin;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  List<String> roles = [
    StringConstants.admin,
    StringConstants.chef,
  ];

  Future<void> _createUserWithRoles(
      String email, String password, String name, String role) async {
    setState(() {
      _isCreating = true;
    });
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      String userId = userCredential.user!.uid;
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .set({'name': name, 'role': role, 'email': email});
      setState(() {
        _isCreating = false;
      });
      if (mounted) {
        FirebaseAuth.instance.signOut();
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const Login(),
            ));
      }
    } catch (e) {
      setState(() {
        _isCreating = false;
      });
      print('Error creating user: $e');
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(title: const Text(StringConstants.signUp)),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(22.0),
            child: Column(
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.only(top: 18.0),
                  child: CommonAvatar(),
                ),
                Form(
                  key: _formkey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: TextFormField(
                          controller: _nameController,
                          validator: MultiValidator(Validator.nameValidator),
                          decoration: const InputDecoration(
                            hintText: StringConstants.name,
                            labelText: StringConstants.name,
                            errorStyle: TextStyle(fontSize: 12.0),
                            border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: ColorConstant.error),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(9.0)),
                            ),
                          ),
                          onChanged: (value) => setState(() {}),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: FormField<String>(
                          builder: (FormFieldState<String> state) {
                            return InputDecorator(
                              decoration: InputDecoration(
                                errorStyle: const TextStyle(
                                    color: Colors.redAccent, fontSize: 16.0),
                                hintText: 'Please select expense',
                                label: const Text(StringConstants.role),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                              ),
                              isEmpty: _currentSelectedRole == '',
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: _currentSelectedRole,
                                  isDense: true,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      _currentSelectedRole =
                                          newValue ?? "Admin";
                                    });
                                  },
                                  items: roles.map((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: TextFormField(
                          controller: _emailController,
                          validator: MultiValidator(Validator.emailValidator),
                          decoration: const InputDecoration(
                            hintText: StringConstants.email,
                            labelText: StringConstants.email,
                            errorStyle: TextStyle(fontSize: 12.0),
                            border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: ColorConstant.error),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(9.0)),
                            ),
                          ),
                          onChanged: (value) => setState(() {}),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 25.0),
                        child: TextFormField(
                          controller: _passwordController,
                          validator:
                              MultiValidator(Validator.passwordValidator),
                          keyboardType: TextInputType.visiblePassword,
                          obscureText: !_passwordVisible,
                          decoration: InputDecoration(
                            hintText: StringConstants.password,
                            labelText: StringConstants.password,
                            errorStyle: const TextStyle(fontSize: 12.0),
                            border: const OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: ColorConstant.error),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(9.0)),
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _passwordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: ColorConstant.secondary,
                              ),
                              onPressed: () {
                                setState(() {
                                  _passwordVisible = !_passwordVisible;
                                });
                              },
                            ),
                          ),
                          onChanged: (value) => setState(() {}),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 25.0),
                        child: TextFormField(
                          controller: _confirmPasswordController,
                          validator: MultiValidator(
                              Validator.confirmPasswordValidator(
                                  _passwordController.text,
                                  _confirmPasswordController.text)),
                          keyboardType: TextInputType.visiblePassword,
                          obscureText: !_confirmPasswordVisible,
                          decoration: InputDecoration(
                            hintText: StringConstants.confirmPassword,
                            labelText: StringConstants.confirmPassword,
                            errorStyle: const TextStyle(fontSize: 12.0),
                            border: const OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: ColorConstant.error),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(9.0)),
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _confirmPasswordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: ColorConstant.secondary,
                              ),
                              onPressed: () {
                                setState(() {
                                  _confirmPasswordVisible =
                                      !_confirmPasswordVisible;
                                });
                              },
                            ),
                          ),
                          onChanged: (value) => setState(() {}),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 25.0),
                        child: CommonButton(
                            title: StringConstants.signUp,
                            isLoading: _isCreating,
                            onPressed: () {
                              if (_formkey.currentState!.validate()) {
                                _createUserWithRoles(
                                    _emailController.text,
                                    _passwordController.text,
                                    _nameController.text,
                                    _currentSelectedRole);
                              }
                            }),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

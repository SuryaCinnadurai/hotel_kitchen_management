import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:hotel_kitchen_management/screen/authentication/home.dart';
import 'package:hotel_kitchen_management/screen/authentication/signup.dart';
import 'package:hotel_kitchen_management/screen/common/common_avatar.dart';
import 'package:hotel_kitchen_management/screen/common/common_button.dart';
import 'package:hotel_kitchen_management/screen/utils/color_constant.dart';
import 'package:hotel_kitchen_management/screen/utils/string_constant.dart';
import 'package:hotel_kitchen_management/screen/utils/validator.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  Map userData = {};
  final _formkey = GlobalKey<FormState>();
  bool _passwordVisible = false;
  bool _isLoginUser = false;
  bool _isIncorrect = false;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _routeNavigation(Widget page) {
    _resetvalue();
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return page;
    }));
  }

  void _loginUser(String email, String password) async {
    _isIncorrect = false;
    setState(() {
      _isLoginUser = true;
    });
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      setState(() {
        _resetvalue();
      });
    } on FirebaseAuthException {
      _isIncorrect = true;
      setState(() {
        _isLoginUser = false;
      });
    }
  }

  _resetvalue() {
    _emailController.text = "";
    _passwordController.text = "";
    _isLoginUser = false;
    _isIncorrect = false;
    _passwordVisible = false;
    setState(() {});
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return GestureDetector(
              onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
              child: Scaffold(
                appBar: AppBar(
                  title: const Text(StringConstants.login),
                  centerTitle: true,
                ),
                body: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(
                              top: MediaQuery.of(context).size.width * 0.20),
                          child: const CommonAvatar(),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Form(
                            key: _formkey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(top: 15.0),
                                  child: TextFormField(
                                    controller: _emailController,
                                    validator: MultiValidator(
                                        Validator.emailValidator),
                                    decoration: const InputDecoration(
                                      hintText: StringConstants.email,
                                      labelText: StringConstants.email,
                                      errorStyle: TextStyle(fontSize: 12.0),
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: ColorConstant.error),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(9.0)),
                                      ),
                                    ),
                                    onChanged: (value) => setState(() {}),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 25.0),
                                  child: TextFormField(
                                    controller: _passwordController,
                                    validator: MultiValidator(
                                        Validator.loginPasswordValidator),
                                    keyboardType: TextInputType.visiblePassword,
                                    obscureText: !_passwordVisible,
                                    decoration: InputDecoration(
                                      hintText: StringConstants.password,
                                      labelText: StringConstants.password,
                                      errorStyle:
                                          const TextStyle(fontSize: 12.0),
                                      border: const OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: ColorConstant.error),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(9.0)),
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
                                            _passwordVisible =
                                                !_passwordVisible;
                                          });
                                        },
                                      ),
                                    ),
                                    onChanged: (value) => setState(() {}),
                                  ),
                                ),
                                if (_isIncorrect)
                                  const Padding(
                                    padding: EdgeInsets.only(top: 10),
                                    child: Text(
                                      "Email or password is incorrect",
                                      style:
                                          TextStyle(color: ColorConstant.error),
                                    ),
                                  ),
                                // Padding(
                                //   padding: const EdgeInsets.only(top: 15.0),
                                //   child: Align(
                                //     alignment: Alignment.topRight,
                                //     child: GestureDetector(
                                //       onTap: () {},
                                //       child: const Text(
                                //         StringConstants.forgotPassword,
                                //         style: TextStyle(
                                //             color: ColorConstant.linkTextColor),
                                //       ),
                                //     ),
                                //   ),
                                // ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 25.0),
                                  child: CommonButton(
                                    title: StringConstants.login,
                                    isLoading: _isLoginUser,
                                    onPressed: () {
                                      if (_formkey.currentState!.validate()) {
                                        _loginUser(_emailController.text,
                                            _passwordController.text);
                                      }
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 15.0),
                                  child: Center(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Text(StringConstants.signUpInfo),
                                        const SizedBox(width: 5.0),
                                        GestureDetector(
                                          onTap: () =>
                                              _routeNavigation(const SignUp()),
                                          child: const Text(
                                            StringConstants.signUp,
                                            style: TextStyle(
                                                color: ColorConstant
                                                    .linkTextColor),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }

          return const Home();
        });
  }
}

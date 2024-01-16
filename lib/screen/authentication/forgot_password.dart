import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:hotel_kitchen_management/screen/common/common_avatar.dart';
import 'package:hotel_kitchen_management/screen/common/common_button.dart';
import 'package:hotel_kitchen_management/screen/utils/color_constant.dart';
import 'package:hotel_kitchen_management/screen/utils/string_constant.dart';
import 'package:hotel_kitchen_management/screen/utils/validator.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final _formkey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  bool _isResettingPassword = false;

  void _forgotPassword(String email) async {
    setState(() {
      _isResettingPassword = true;
    });

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      setState(() {
        _isResettingPassword = false;
      });
    } catch (e) {
      setState(() {
        _isResettingPassword = false;
      });
      print("Failed to sent reset password mail");
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(title: const Text(StringConstants.forgotPasswordTitle)),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(22.0),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.width * 0.20),
                  child: const CommonAvatar(),
                ),
                Form(
                  key: _formkey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Padding(
                        padding: EdgeInsets.only(top: 20.0),
                        child: Text(
                          "Provide your email and we will send you a link to reset your password",
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
                        child: CommonButton(
                            title: StringConstants.reset,
                            isLoading: _isResettingPassword,
                            onPressed: () {
                              if (_formkey.currentState!.validate()) {
                                _forgotPassword(_emailController.text);
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

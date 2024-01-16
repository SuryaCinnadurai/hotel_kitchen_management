import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hotel_kitchen_management/main.dart';
import 'package:hotel_kitchen_management/screen/authentication/home.dart';
import 'package:hotel_kitchen_management/screen/authentication/login.dart';
import 'package:hotel_kitchen_management/screen/utils/color_constant.dart';
import 'package:hotel_kitchen_management/screen/utils/route_constant.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme:
            ColorScheme.fromSeed(seedColor: ColorConstant.primaryColor),
      ),
      navigatorKey: navigatorKey,
      initialRoute: FirebaseAuth.instance.currentUser == null
          ? RouteConstant.login
          : RouteConstant.home,
      routes: {
        RouteConstant.login: (context) {
          return const Login();
        },
        RouteConstant.home: (context) => const Home(),
      },
      home: const Login(),
    );
  }
}

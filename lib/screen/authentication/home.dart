import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:hotel_kitchen_management/screen/admin/dashboard.dart';
import 'package:hotel_kitchen_management/screen/chef/landing_page.dart';
import 'package:hotel_kitchen_management/screen/utils/string_constant.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  final _auth = FirebaseAuth.instance;

  @override
  void initState() {
    _subscribeNotification();
    super.initState();
  }

  _subscribeNotification() async {
    await FirebaseMessaging.instance.subscribeToTopic("neworder");
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(_auth.currentUser!.uid).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return const Text("Document does not exist");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          if (data['role'] == StringConstants.admin) {
            return AdminLandingPage(data: data);
          }
          return const ChefLandingPage();
        }

        return const Scaffold(
            body: Center(
          child: CircularProgressIndicator(),
        ));
      },
    );
  }
}

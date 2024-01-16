import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:hotel_kitchen_management/model/title_detail.dart';
import 'package:hotel_kitchen_management/screen/admin/create_order.dart';
import 'package:hotel_kitchen_management/screen/admin/inventory.dart';
import 'package:hotel_kitchen_management/screen/admin/menu.dart';
import 'package:hotel_kitchen_management/screen/admin/order.dart';
import 'package:hotel_kitchen_management/screen/admin/reporting.dart';
import 'package:hotel_kitchen_management/screen/authentication/login.dart';
import 'package:hotel_kitchen_management/screen/common/common_tile.dart';
import 'package:hotel_kitchen_management/screen/utils/string_constant.dart';

class AdminLandingPage extends StatefulWidget {
  const AdminLandingPage({super.key, required this.data});
  final Map<String, dynamic> data;

  @override
  State<AdminLandingPage> createState() => _AdminLandingPageState();
}

class _AdminLandingPageState extends State<AdminLandingPage> {
  late List<TileDetails> cardDetails;

  @override
  void initState() {
    cardDetails = [
      const TileDetails(
          title: StringConstants.order,
          icon: Icons.restaurant,
          navigationPage: OrderPage()),
      const TileDetails(
          title: StringConstants.inventory,
          icon: Icons.add_shopping_cart,
          navigationPage: InventoryPage()),
      const TileDetails(
          title: StringConstants.menu,
          icon: Icons.restaurant_menu,
          navigationPage: MenuPage()),
      const TileDetails(
          title: StringConstants.reporting,
          icon: Icons.assignment_outlined,
          navigationPage: ReportingPage()),
      const TileDetails(
          title: StringConstants.newOrder,
          icon: Icons.food_bank_outlined,
          navigationPage: CreateOrder()),
    ];

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(StringConstants.dashboard),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: IconButton(
                  onPressed: () {
                    FirebaseAuth.instance.signOut();
                    FirebaseMessaging.instance.unsubscribeFromTopic("neworder");
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Login(),
                        ));
                  },
                  icon: const Icon(Icons.logout_outlined)),
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 30),
            child: GridCardTile(
              cardDetails: cardDetails,
            ),
          ),
        ));
  }
}

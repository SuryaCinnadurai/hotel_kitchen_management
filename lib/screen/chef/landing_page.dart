import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:hotel_kitchen_management/screen/authentication/login.dart';
import 'package:hotel_kitchen_management/screen/common/order_tile.dart';
import 'package:hotel_kitchen_management/screen/utils/string_constant.dart';

class ChefLandingPage extends StatefulWidget {
  const ChefLandingPage({super.key});

  @override
  State<ChefLandingPage> createState() => _ChefLandingPageState();
}

class _ChefLandingPageState extends State<ChefLandingPage> {
  final CollectionReference _orderItems =
      FirebaseFirestore.instance.collection(StringConstants.orderCollection);

  _updateOrderStatus(String id, String status) {
    _orderItems.doc(id).update({StringConstants.statusObj: status});
  }

  _getItems(QuerySnapshot<Object?> data) {
    List<Map<String, dynamic>> items = [];
    for (var element in data.docs) {
      var item = element.data() as Map<String, dynamic>;
      item[StringConstants.idObj] = element.id;
      items.add(item);
    }
    var currentItem = items
        .where(
            (item) => item[StringConstants.statusObj] == StringConstants.accept)
        .toList();
    return currentItem;
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
                    ),
                  );
                },
                icon: const Icon(Icons.logout_outlined)),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection(StringConstants.orderCollection)
                    .snapshots(),
                builder:
                    (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                  List<Map<String, dynamic>> orders =
                      streamSnapshot.data != null
                          ? _getItems(streamSnapshot.data!)
                          : [];
                  return ListView.builder(
                    itemCount: orders.length,
                    itemBuilder: (ctx, index) {
                      Map<String, dynamic> foodDetails = orders[index];
                      return Card(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 5,
                                child: OrderTile(
                                  name: foodDetails[StringConstants.nameObj],
                                  address:
                                      foodDetails[StringConstants.addressObj],
                                  phone: foodDetails[StringConstants.phoneObj],
                                  totalAmount:
                                      foodDetails[StringConstants.totalObj],
                                  items: foodDetails[StringConstants.itemsObj],
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: IconButton(
                                    onPressed: () {
                                      _updateOrderStatus(
                                          foodDetails[StringConstants.idObj],
                                          StringConstants.prepared);
                                    },
                                    icon: const Icon(Icons.done)),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

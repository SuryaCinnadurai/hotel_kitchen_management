import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hotel_kitchen_management/screen/common/order_tile.dart';
import 'package:hotel_kitchen_management/screen/utils/string_constant.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({super.key});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
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
        .where((item) =>
            item[StringConstants.statusObj] == StringConstants.pending)
        .toList();
    return currentItem;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(StringConstants.menu),
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
                              IconButton(
                                  onPressed: () {
                                    _updateOrderStatus(
                                        foodDetails[StringConstants.idObj],
                                        StringConstants.accept);
                                  },
                                  icon: const Icon(Icons.done)),
                              IconButton(
                                  onPressed: () {
                                    _updateOrderStatus(
                                        foodDetails[StringConstants.idObj],
                                        StringConstants.reject);
                                  },
                                  icon: const Icon(Icons.close))
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

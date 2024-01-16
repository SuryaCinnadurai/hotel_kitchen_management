import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:hotel_kitchen_management/screen/authentication/login.dart';
import 'package:hotel_kitchen_management/screen/common/common_button.dart';
import 'package:hotel_kitchen_management/screen/common/order_tile.dart';
import 'package:hotel_kitchen_management/screen/utils/string_constant.dart';

class ReportingPage extends StatefulWidget {
  const ReportingPage({super.key});

  @override
  State<ReportingPage> createState() => _ReportingPageState();
}

class _ReportingPageState extends State<ReportingPage> {
  final CollectionReference _orderItems =
      FirebaseFirestore.instance.collection(StringConstants.orderCollection);
  List<Map<String, dynamic>> _orders = [];

  _updateOrderStatus(String id, String status) {
    _orderItems.doc(id).update({StringConstants.statusObj: status});
  }

  Future<void> exportToPDF(List<Map<String, dynamic>> jsonData) async {
    // Create a PDF document
    final pdf = pw.Document();

    final font = await rootBundle.load("assets/OpenSans-Light.ttf");
    final ttf = pw.Font.ttf(font);

    // Add a page to the PDF
    pdf.addPage(
      pw.Page(
        build: (context) {
          return pw.Center(
            child: pw.Text(jsonEncode(jsonData),
                style: pw.TextStyle(font: ttf, fontSize: 40)),
          );
        },
      ),
    );

    // Get the document directory on the device
    final directory = await getApplicationDocumentsDirectory();

    // Create a file to save the PDF
    final file = File('${directory.path}/example.pdf');

    try {
      // Write the PDF to the file
      await file.writeAsBytes(await pdf.save());
    } catch (e) {
      print(e);
    }
  }

  _getItems(QuerySnapshot<Object?> data) {
    List<Map<String, dynamic>> items = [];
    for (var element in data.docs) {
      var item = element.data() as Map<String, dynamic>;
      item[StringConstants.idObj] = element.id;
      items.add(item);
    }

    return items;
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
                  _orders = streamSnapshot.data != null
                      ? _getItems(streamSnapshot.data!)
                      : [];
                  return ListView.builder(
                    itemCount: _orders.length,
                    itemBuilder: (ctx, index) {
                      Map<String, dynamic> foodDetails = _orders[index];
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
                                child: Text(
                                    foodDetails[StringConstants.statusObj]),
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
            CommonButton(
                title: "Generate PDF",
                onPressed: () {
                  exportToPDF(_orders);
                },
                isLoading: false)
          ],
        ),
      ),
    );
  }
}

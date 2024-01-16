import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hotel_kitchen_management/screen/common/food_tile.dart';
import 'package:hotel_kitchen_management/screen/utils/color_constant.dart';
import 'package:hotel_kitchen_management/screen/utils/string_constant.dart';

class InventoryPage extends StatefulWidget {
  const InventoryPage({super.key});

  @override
  State<InventoryPage> createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {
  final CollectionReference _inventaryItems = FirebaseFirestore.instance
      .collection(StringConstants.inventoryCollection);
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _kgController = TextEditingController();
  final TextEditingController _imgURLController = TextEditingController();

  _addMenuItem() async {
    _showPopUp();
  }

  _editItem(String id, String name, String weight, String imageUrl) async {
    _nameController.text = name;
    _kgController.text = weight;
    _imgURLController.text = imageUrl;
    _showPopUp(id: id);
  }

  _deleteItem(String id) {
    _inventaryItems.doc(id).delete();
  }

  _resetvalue() {
    _nameController.text = "";
    _kgController.text = "";
    _imgURLController.text = "";
  }

  _showPopUp({String? id}) async {
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.topRight,
          fit: StackFit.loose,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        hintText: StringConstants.name,
                        labelText: StringConstants.name,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: TextFormField(
                      controller: _kgController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        hintText: StringConstants.weight,
                        labelText: StringConstants.weight,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: TextFormField(
                      controller: _imgURLController,
                      decoration: const InputDecoration(
                        hintText: StringConstants.imgURL,
                        labelText: StringConstants.imgURL,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: ElevatedButton(
                      child: const Text(StringConstants.submit),
                      onPressed: () async {
                        if (_nameController.text.isNotEmpty &&
                            _kgController.text.isNotEmpty) {
                          if (id != null) {
                            await _inventaryItems.doc(id).update({
                              StringConstants.nameObj: _nameController.text,
                              StringConstants.weightObj: _kgController.text,
                              StringConstants.imgURLObj: _imgURLController.text
                            });
                          } else {
                            await _inventaryItems.add({
                              StringConstants.nameObj: _nameController.text,
                              StringConstants.weightObj: _kgController.text,
                              StringConstants.imgURLObj: _imgURLController.text
                            });
                          }
                          if (mounted) {
                            _resetvalue();
                            Navigator.pop(context);
                          }
                        }
                      },
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              width: 40,
              height: 40,
              child: Center(
                child: GestureDetector(
                  onTap: () {
                    _resetvalue();
                    Navigator.of(context).pop();
                  },
                  child: const Icon(
                    Icons.close,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Inventory Items",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 30,
                  child: OutlinedButton(
                      onPressed: _addMenuItem,
                      child: const Text(
                        StringConstants.add,
                        style: TextStyle(color: ColorConstant.addButtonColor),
                      )),
                )
              ],
            ),
            const Padding(
              padding: EdgeInsets.only(top: 8.0),
              child: Divider(
                color: Colors.black,
                thickness: 0.1,
              ),
            ),
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection(StringConstants.inventoryCollection)
                    .snapshots(),
                builder:
                    (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                  return ListView.separated(
                    separatorBuilder: (context, index) =>
                        const Divider(color: Colors.black, thickness: 0.1),
                    itemCount: streamSnapshot.data != null
                        ? streamSnapshot.data!.docs.length
                        : 0,
                    itemBuilder: (ctx, index) {
                      QueryDocumentSnapshot<Object?> foodDetails =
                          streamSnapshot.data!.docs[index];
                      return Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Expanded(
                            child: FoodTile(
                              name: foodDetails[StringConstants.nameObj],
                              price: "",
                              imgURL: foodDetails[StringConstants.imgURLObj],
                              weight:
                                  foodDetails[StringConstants.weightObj] ?? "",
                            ),
                          ),
                          SizedBox(
                            height: 30,
                            child: OutlinedButton(
                                onPressed: () {
                                  _editItem(
                                    foodDetails.id,
                                    foodDetails[StringConstants.nameObj],
                                    foodDetails[StringConstants.weightObj] ??
                                        "",
                                    foodDetails[StringConstants.imgURLObj],
                                  );
                                },
                                child: const Text(
                                  StringConstants.edit,
                                  style: TextStyle(
                                      color: ColorConstant.addButtonColor),
                                )),
                          ),
                          GestureDetector(
                            onTap: () {
                              _deleteItem(foodDetails.id);
                            },
                            child: const Padding(
                              padding: EdgeInsets.only(left: 8.0),
                              child: Icon(
                                Icons.delete,
                                color: ColorConstant.deleteiconColor,
                              ),
                            ),
                          ),
                        ],
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

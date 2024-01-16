import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:hotel_kitchen_management/screen/common/common_button.dart';
import 'package:hotel_kitchen_management/screen/common/food_tile.dart';
import 'package:hotel_kitchen_management/screen/common/step_count.dart';
import 'package:hotel_kitchen_management/screen/utils/color_constant.dart';
import 'package:hotel_kitchen_management/screen/utils/string_constant.dart';
import 'package:hotel_kitchen_management/screen/utils/validator.dart';

class CreateOrder extends StatefulWidget {
  const CreateOrder({super.key});

  @override
  State<CreateOrder> createState() => _CreateOrderState();
}

class _CreateOrderState extends State<CreateOrder> {
  final _formkey = GlobalKey<FormState>();
  final List<Map<String, dynamic>> _orderItems = [];
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final CollectionReference _orders =
      FirebaseFirestore.instance.collection(StringConstants.orderCollection);

  _addItems(QueryDocumentSnapshot<Object?> foodDetails, int quentity) {
    int index = _orderItems.indexWhere(
        (element) => element[StringConstants.idObj] == foodDetails.id);
    if (quentity > 0) {
      Map<String, dynamic> orderItem = {
        StringConstants.idObj: foodDetails.id,
        StringConstants.nameObj: foodDetails[StringConstants.nameObj],
        StringConstants.quentityObj: quentity,
        StringConstants.totalObj:
            quentity * int.parse(foodDetails[StringConstants.priceObj]),
      };
      if (index == -1) {
        _orderItems.add(orderItem);
      } else {
        _orderItems[index] = orderItem;
      }
    }
  }

  String _getTotalAmount() {
    int total = 0;
    for (var orderItem in _orderItems) {
      total += orderItem[StringConstants.totalObj] as int;
    }
    return total.toString();
  }

  _resetvalue() {
    _nameController.text = "";
    _phoneController.text = "";
    _addressController.text = "";
  }

  _placeOrder() {
    if (_orderItems.isNotEmpty) {
      _showPopUp();
    }
  }

  _confirmOrder() async {
    Map<String, dynamic> orderDetails = {
      StringConstants.nameObj: _nameController.text,
      StringConstants.addressObj: _addressController.text,
      StringConstants.phoneObj: _phoneController.text,
      StringConstants.totalObj: _getTotalAmount(),
      StringConstants.statusObj: StringConstants.pending,
      StringConstants.itemsObj: _orderItems
    };

    await _orders.add(orderDetails);
    if (mounted) {
      Navigator.pop(context);
      Navigator.pop(context);
    }
  }

  _showPopUp() async {
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: Form(
          key: _formkey,
          child: Stack(
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
                        validator: MultiValidator(Validator.nameValidator),
                        decoration: const InputDecoration(
                          hintText: StringConstants.name,
                          labelText: StringConstants.name,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: TextFormField(
                        controller: _addressController,
                        validator: MultiValidator(Validator.nameValidator),
                        decoration: const InputDecoration(
                          hintText: StringConstants.address,
                          labelText: StringConstants.address,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: TextFormField(
                        controller: _phoneController,
                        validator: MultiValidator(Validator.nameValidator),
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                          hintText: StringConstants.phone,
                          labelText: StringConstants.phone,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const Text(
                            StringConstants.totalBill,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Text(
                              _getTotalAmount(),
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: ColorConstant.primaryRed),
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: CommonButton(
                        title: StringConstants.confirmOrder,
                        bgColor: ColorConstant.primaryRed,
                        onPressed: () {
                          if (_formkey.currentState!.validate()) {
                            _confirmOrder();
                          }
                        },
                        isLoading: false,
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(StringConstants.newOrder),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Menu items",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                    .collection(StringConstants.menuCollection)
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
                        children: [
                          Expanded(
                            child: FoodTile(
                              name: foodDetails[StringConstants.nameObj],
                              price: foodDetails[StringConstants.priceObj],
                              imgURL: foodDetails[StringConstants.imgURLObj],
                              weight: "",
                            ),
                          ),
                          NumericStepButton(
                            maxValue: 20,
                            onChanged: (value) {
                              _addItems(foodDetails, value);
                            },
                          )
                        ],
                      );
                    },
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 15.0),
              child: CommonButton(
                  title: "Place Order",
                  onPressed: _placeOrder,
                  isLoading: false),
            )
          ],
        ),
      ),
    );
  }
}

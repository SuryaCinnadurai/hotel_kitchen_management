import 'package:flutter/material.dart';
import 'package:hotel_kitchen_management/screen/utils/color_constant.dart';
import 'package:hotel_kitchen_management/screen/utils/string_constant.dart';

class OrderTile extends StatelessWidget {
  const OrderTile({
    super.key,
    required this.name,
    required this.address,
    required this.items,
    required this.phone,
    required this.totalAmount,
  });

  final String name;
  final String address;
  final List<dynamic> items;
  final String phone;
  final String totalAmount;

  List<Widget> _getItems() {
    List<Widget> children = [];
    for (var item in items) {
      children.add(Padding(
        padding: const EdgeInsets.all(2.0),
        child: Row(
          children: [
            Expanded(
              flex: 4,
              child: Text(
                item[StringConstants.nameObj],
                overflow: TextOverflow.visible,
                style: const TextStyle(fontSize: 14),
              ),
            ),
            Flexible(
              flex: 2,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: ColorConstant.primaryGreen,
                    width: 0.5,
                  ),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: ColoredBox(
                  color: ColorConstant.primaryGreen.withOpacity(0.2),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text(
                      " x${item[StringConstants.quentityObj]}",
                      overflow: TextOverflow.visible,
                      style: const TextStyle(fontSize: 11),
                    ),
                  ),
                ),
              ),
            ),
            Flexible(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.only(left: 25.0),
                child: Text(
                  item[StringConstants.totalObj].toString(),
                  overflow: TextOverflow.visible,
                  style: const TextStyle(fontSize: 14),
                ),
              ),
            )
          ],
        ),
      ));
    }
    return children;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    overflow: TextOverflow.visible,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  Text(
                    address,
                    overflow: TextOverflow.visible,
                    style: const TextStyle(fontSize: 14),
                  ),
                  Text(
                    phone,
                    overflow: TextOverflow.visible,
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    StringConstants.itemTitle,
                    overflow: TextOverflow.visible,
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  Column(
                    children: [
                      ..._getItems(),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Row(
                          children: [
                            const Expanded(
                              flex: 5,
                              child: Text(
                                StringConstants.totalBill,
                                overflow: TextOverflow.visible,
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                "₹$totalAmount",
                                overflow: TextOverflow.visible,
                                style: const TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.bold),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:hotel_kitchen_management/model/title_detail.dart';

class GridCardTile extends StatelessWidget {
  const GridCardTile({Key? key, required this.cardDetails}) : super(key: key);
  final List<TileDetails> cardDetails;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      childAspectRatio: 1.75,
      crossAxisSpacing: 5,
      mainAxisSpacing: 5,
      children: List.generate(
        cardDetails.length,
        (index) {
          TileDetails cardDetail = cardDetails[index];
          return Card(
            elevation: 3,
            child: InkWell(
              onTap: (() {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => cardDetail.navigationPage,
                  ),
                );
              }),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Icon(cardDetail.icon, size: 28),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(cardDetail.title),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

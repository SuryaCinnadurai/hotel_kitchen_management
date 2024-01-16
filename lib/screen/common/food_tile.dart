import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class FoodTile extends StatelessWidget {
  const FoodTile(
      {super.key,
      required this.name,
      required this.price,
      required this.imgURL,
      required this.weight});

  final String name;
  final String price;
  final String imgURL;
  final String weight;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 70,
          height: 70,
          child: CachedNetworkImage(
            fit: BoxFit.cover,
            imageUrl: imgURL,
            progressIndicatorBuilder: (context, url, progress) =>
                const Center(child: CircularProgressIndicator()),
          ),
        ),
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
                if (price.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      "₹$price",
                    ),
                  ),
                if (weight.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      "${weight}Kg",
                    ),
                  )
              ],
            ),
          ),
        )
      ],
    );
  }
}

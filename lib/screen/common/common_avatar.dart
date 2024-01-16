import 'package:flutter/material.dart';
import 'package:hotel_kitchen_management/screen/utils/color_constant.dart';

class CommonAvatar extends StatelessWidget {
  const CommonAvatar({super.key});

  @override
  Widget build(BuildContext context) {
    return const Icon(
      Icons.account_circle,
      size: 75,
      color: ColorConstant.secondary,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:hotel_kitchen_management/screen/utils/color_constant.dart';

class NumericStepButton extends StatefulWidget {
  final int minValue;
  final int maxValue;

  final ValueChanged<int> onChanged;

  const NumericStepButton(
      {Key? key,
      this.minValue = 0,
      this.maxValue = 10,
      required this.onChanged})
      : super(key: key);

  @override
  State<NumericStepButton> createState() {
    return _NumericStepButtonState();
  }
}

class _NumericStepButtonState extends State<NumericStepButton> {
  int count = 0;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(
          color: ColorConstant.primaryRed,
          width: 0.5,
        ),
        borderRadius: BorderRadius.circular(4),
      ),
      child: ColoredBox(
        color: ColorConstant.primaryRed.withOpacity(0.02),
        child: SizedBox(
          height: 30,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              GestureDetector(
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.0),
                  child: Icon(
                    Icons.remove,
                    color: ColorConstant.primaryRed,
                    size: 15,
                  ),
                ),
                onTap: () {
                  setState(() {
                    if (count > widget.minValue) {
                      count--;
                    }
                    widget.onChanged(count);
                  });
                },
              ),
              Text(
                count == 0 ? "ADD" : '$count',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: ColorConstant.primaryRed,
                  fontSize: 12.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
              GestureDetector(
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.0),
                  child: Icon(
                    Icons.add,
                    color: ColorConstant.primaryRed,
                    size: 15,
                  ),
                ),
                onTap: () {
                  setState(() {
                    if (count < widget.maxValue) {
                      count++;
                    }
                    widget.onChanged(count);
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

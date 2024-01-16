import 'package:flutter/material.dart';

class CommonButton extends StatelessWidget {
  const CommonButton(
      {required this.title,
      required this.onPressed,
      required this.isLoading,
      this.bgColor,
      super.key});

  final String title;
  final VoidCallback? onPressed;
  final bool isLoading;
  final Color? bgColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 50,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(bgColor),
        ),
        child: isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: Center(
                    child: CircularProgressIndicator(
                        strokeWidth: 2.0, color: Colors.white)))
            : Text(
                title,
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
      ),
    );
  }
}

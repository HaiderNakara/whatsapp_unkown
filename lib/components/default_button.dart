import 'package:flutter/material.dart';

class DefaulfButton extends StatelessWidget {
  const DefaulfButton({
    Key? key,
    required this.text,
    required this.press,
    required this.longPress,
  }) : super(key: key);
  final String text;
  final press;
  final longPress;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        onPressed: press,
        onLongPress: longPress,
        child: Text(
          text,
        ),
      ),
    );
  }
}

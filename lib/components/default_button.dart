import 'package:flutter/material.dart';

class DefaulfButton extends StatelessWidget {
  const DefaulfButton({
    Key? key,
    this.text,
    this.press,
  }) : super(key: key);
  final String? text;
  final Function? press;

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
        onPressed: press as void Function()?,
        child: Text(
          text!,
        ),
      ),
    );
  }
}

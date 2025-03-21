import 'package:flutter/material.dart';

class CostumeButton extends StatelessWidget {
  final Color bgColor;
  final String labelButton;
  final VoidCallback onPressed;
  final Color labelColor;

  const CostumeButton({
    super.key,
    required this.bgColor,
    required this.labelButton,
    required this.onPressed,
    required this.labelColor,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        minimumSize: Size(MediaQuery.of(context).size.width * 0.5, 50),
        backgroundColor: bgColor,
      ),
      onPressed: () {
        onPressed.call();
      },
      child: Text(labelButton, style: TextStyle(color: labelColor)),
    );
  }
}

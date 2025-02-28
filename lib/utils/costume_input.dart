import 'package:flutter/material.dart';

class CostumeInput extends StatelessWidget {
  final String label;
  final TextEditingController textEditingController;
  final bool obscureText;
  final IconData icon;
  final String textHint;
  final TextInputType textInputType;

  const CostumeInput({
    super.key,
    required this.label,
    required this.textEditingController,
    this.obscureText = false,
    required this.icon,
    required this.textHint,
    required this.textInputType,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          textAlign: TextAlign.left,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 5),
        TextFormField(
          controller: textEditingController,
          obscureText: obscureText,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: Colors.red),
            hintText: textHint,
            filled: true,
            fillColor: Colors.amber.shade100,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
          ),
          keyboardType: textInputType,
          validator: (val) {
            return val!.isEmpty ? "Tidak boleh kosong" : null;
          },
        ),
      ],
    );
  }
}

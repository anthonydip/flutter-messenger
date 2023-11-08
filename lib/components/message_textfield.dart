import 'package:flutter/material.dart';

class MessageTextField extends StatelessWidget {
  final controller;
  final String hintText;
  final Function()? onIconTap;

  const MessageTextField({
    super.key,
    required this.onIconTap,
    required this.controller,
    required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white)
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade400)
          ),
          fillColor: Colors.grey.shade200,
          filled: true,
          hintText: hintText,
          suffixIcon: GestureDetector(
            onTap: onIconTap,
            child: const Icon(Icons.send)
          )
        ),
      ),
    );
  }
}
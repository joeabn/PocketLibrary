import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class RoundedTextField extends StatelessWidget {
  final String textHint;
  final FocusNode? focusNode;
  final FormFieldValidator<String>? validator;
  final TextEditingController editingController;

  const RoundedTextField(
      {Key? key,
      required this.textHint,
      this.focusNode,
      required this.editingController,
      this.validator})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: editingController,
      focusNode: focusNode,
      validator: validator,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        filled: true,
        hintStyle: TextStyle(color: Colors.grey[800]),
        hintText: textHint,
        fillColor: Colors.white70,
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
          borderSide: const BorderSide(
            color: Colors.red,
          ),
        ),
      ),
    );
  }
}

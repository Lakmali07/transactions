import 'dart:core';

import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

class FormTextField extends StatelessWidget {
  final TextEditingController controller;
  final bool? obscureText;
  final String inputType; //Input Types = {none, email, password, num}
  final bool isRequired;
  final function;
  final bool? filled;
  final String? labelText;
  final Widget? suffixIcon;
  final FocusNode? focusNode;
  final void Function(String)? onFieldSubmitted;
  final InputDecoration? inputDecoration;
  final int? maxLength;

  const FormTextField(
      {required this.controller,
      this.obscureText = false,
      required this.inputType,
      required this.isRequired,
      this.function,
      this.filled,
      this.labelText,
      this.suffixIcon,
      this.focusNode,
      this.onFieldSubmitted,
      this.inputDecoration,
      this.maxLength});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      onFieldSubmitted: onFieldSubmitted,
      obscureText: obscureText!,
      maxLength: maxLength,
      keyboardType: inputType.isNotEmpty && inputType == "num"
          ? TextInputType.number
          : null,
      inputFormatters: inputType.isNotEmpty && inputType == "num"
          ? [
              FilteringTextInputFormatter.allow(RegExp('[0-9.-]+')),
            ]
          : null,
      decoration: inputDecoration ??
          InputDecoration(
            enabledBorder: const OutlineInputBorder(
              gapPadding: 0,
              borderSide: BorderSide(color: Colors.grey, width: 1.0),
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blue, width: 1.0),
            ),
            focusedErrorBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red, width: 1.0),
            ),
            isDense: true,
            suffixIcon: suffixIcon,
            fillColor: Colors.white,
            filled: filled,
            labelText: labelText,
            counterText: '',
            errorBorder: const OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.red, width: 1.0),
            ),
          ),

      // ignore: missing_return
      validator: (v) {
        //Required
        if (isRequired == true) {
          if (v!.isEmpty) {
            return 'Required Field';
          }
        }
        return null;
      },
    );
  }
}

Widget getPasswordSuffixIcon(function, obscureText) {
  return GestureDetector(
    onTap: function,
    child: obscureText ? Icon(Icons.visibility) : Icon(Icons.visibility_off),
  );
}

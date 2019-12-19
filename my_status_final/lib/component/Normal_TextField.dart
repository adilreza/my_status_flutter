import 'package:flutter/material.dart';
import '../Constant/constant.dart';

class NormalTextField extends StatelessWidget {
  NormalTextField({
    this.hint,
    @required this.inputType,
    this.validator,
    this.OnSaved,
    this.key,
    this.focusNode,
    this.onFieldSubmitted,
    this.onChange,
    this.controller,
    this.backgroundColor
  });

  final hint;
  final TextInputType inputType;
  final TextEditingController controller;

  final Function validator;
  final Function OnSaved;
  final Function onFieldSubmitted;
  final Function onChange;
  final Color backgroundColor;

  final Key key;
  final FocusNode focusNode;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onFieldSubmitted: onFieldSubmitted,
      controller: controller,
      focusNode: focusNode,onChanged: onChange,
      autofocus: true,
      key: key,
      style: KInputTextStyle,
      validator: validator,
      onSaved: OnSaved,
      textInputAction: TextInputAction.done,
      keyboardType: inputType,
      decoration: InputDecoration(

        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.grey,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.grey,
          ),
        ),
        labelText: '$hint',
        labelStyle: TextStyle(color: Colors.grey),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
            borderSide: BorderSide(color: Colors.red)),
      ),
    );
  }
}

import 'package:flutter/material.dart';

InputDecoration textfield(String hint)
{
  return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey[400]),border: InputBorder.none);

}

TextStyle simpleTextFieldStyle(){
  return TextStyle(color: Colors.yellow[200],fontSize:16);
}

TextStyle mediumTextStyle(){
  return TextStyle(color: Colors.white,fontSize:16);
}
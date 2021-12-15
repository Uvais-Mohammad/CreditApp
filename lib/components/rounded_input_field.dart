import 'package:flutter/material.dart';
import 'package:palets_app/components/text_field_container.dart';
import 'package:palets_app/constants.dart';

class RoundedInputField extends StatelessWidget {
  final String hintText;
  final IconData icon;
  final TextInputType? textType;
  final ValueChanged<String> onChanged;
  final TextEditingController username;
  const RoundedInputField({
    Key? key,
    required this.hintText,
    this.textType,
    this.icon = Icons.person,
    required this.onChanged,
    required this.username,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextFormField(
        controller: username,
        onChanged: onChanged,
        keyboardType: textType,
        cursorColor: kPrimaryColor,
        decoration: InputDecoration(
          icon: Icon(
            icon,
            color: kPrimaryColor,
          ),
          hintText: hintText,
          border: InputBorder.none,
        ),
      ),
    );
  }
}

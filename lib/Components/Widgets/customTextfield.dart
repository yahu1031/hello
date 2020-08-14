import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget {
  final ValueChanged onChanged;
  final TextEditingController textEditingController;
  final bool autofocus;
  final bool isPassword;
  final String hint;
  final bool onDigit;
  final bool isText;
  final Function onPressed;
  final FormFieldValidator<String> validator;
  final bool validatePassword;

  CustomTextField({
    @required this.onChanged,
    @required this.isPassword,
    this.validator,
    this.onPressed,
    this.textEditingController,
    this.autofocus = false,
    this.hint,
    this.isText = false,
    this.onDigit = false,
    this.validatePassword = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Material(
        borderRadius: BorderRadius.circular(7),
        child: Container(
          padding: EdgeInsets.all(0),
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.1),
            borderRadius: BorderRadius.circular(7),
          ),
          child: TextFormField(
            validator: validator,
            autofocus: autofocus,
            controller: textEditingController,
            textAlign: TextAlign.left,
            onChanged: onChanged,
            obscureText: isPassword,
            decoration: InputDecoration(
              errorText: (validatePassword && isPassword)
                  ? "Password must be at least 7 characters"
                  : null,
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10.0),
                ),
                borderSide: BorderSide(
                  color: Color(0xFF3F51B5),
                ),
              ),
              contentPadding: EdgeInsets.all(15),
              hintText: hint,
              border: InputBorder.none,
            ),
            keyboardType: isText
                ? TextInputType.text
                : onDigit ? TextInputType.number : TextInputType.emailAddress,
            inputFormatters: <TextInputFormatter>[
              onDigit
                  ? WhitelistingTextInputFormatter.digitsOnly
                  // ignore: deprecated_member_use
                  : BlacklistingTextInputFormatter.singleLineFormatter,
            ],
          ),
        ),
      ),
    );
  }
}

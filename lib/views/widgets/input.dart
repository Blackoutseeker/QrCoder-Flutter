import 'package:flutter/material.dart';

class Input extends StatelessWidget {
  final TextEditingController _textEditingController;
  final VoidCallback _saveQrCode;

  const Input(this._textEditingController, this._saveQrCode);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _textEditingController,
      onSubmitted: (_) => _saveQrCode(),
      maxLength: 1050,
      cursorColor: Theme.of(context).colorScheme.secondary,
      keyboardType: TextInputType.url,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 20,
      ),
      decoration: InputDecoration(
        hintText: 'Write a text',
        hintStyle: Theme.of(context).inputDecorationTheme.hintStyle,
        filled: true,
        fillColor: Theme.of(context).inputDecorationTheme.fillColor,
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
      ),
    );
  }
}

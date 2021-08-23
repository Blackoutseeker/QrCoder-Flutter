import 'package:flutter/material.dart';

class SaveButton extends StatelessWidget {
  final VoidCallback _saveQrCode;
  const SaveButton(this._saveQrCode);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: _saveQrCode,
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(
          Theme.of(context).accentColor
        ),
        padding: MaterialStateProperty.all<EdgeInsets>(
          const EdgeInsets.all(0)
        )
      ),
      child: Row(
        children: <Widget> [
          Expanded(
            child: Container(
              height: 50,
              child: const Center(
                child: const Text(
                  'Save',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22
                  )
                )
              )
            )
          ),
          Container(
            height: 50,
            width: 50,
            color: const Color.fromRGBO(0, 0, 0, 0.5),
            child: const Center(
              child: const Icon(Icons.save)
            )
          )
        ]
      )
    );
  }
}

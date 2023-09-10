import 'package:flutter/material.dart';

class SaveButton extends StatelessWidget {
  const SaveButton(this._saveQrCode, {super.key});
  final VoidCallback _saveQrCode;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: _saveQrCode,
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(
          Theme.of(context).colorScheme.secondary,
        ),
        padding: MaterialStateProperty.all<EdgeInsets>(
          const EdgeInsets.all(0),
        ),
      ),
      child: Row(
        children: <Widget>[
          const Expanded(
            child: SizedBox(
              height: 50,
              child: Center(
                child: Text(
                  'Save',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                  ),
                ),
              ),
            ),
          ),
          Container(
            height: 50,
            width: 50,
            color: const Color.fromRGBO(0, 0, 0, 0.5),
            child: const Center(
              child: Icon(Icons.save),
            ),
          ),
        ],
      ),
    );
  }
}

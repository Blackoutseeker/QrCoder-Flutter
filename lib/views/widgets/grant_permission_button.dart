import 'package:flutter/material.dart';

class GrantPermissionButton extends StatelessWidget {
  final VoidCallback _requestCameraPermission;

  const GrantPermissionButton(this._requestCameraPermission);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: _requestCameraPermission,
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(
          Theme.of(context).colorScheme.secondary,
        ),
      ),
      child: const Text('Grant camera permission'),
    );
  }
}

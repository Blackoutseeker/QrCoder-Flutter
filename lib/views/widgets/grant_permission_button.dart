import 'package:flutter/material.dart';

class GrantPermissionButton extends StatelessWidget {
  const GrantPermissionButton(this._requestCameraPermission, {super.key});
  final VoidCallback _requestCameraPermission;

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

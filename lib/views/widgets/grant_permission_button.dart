import 'package:flutter/material.dart';

class GrantPermissionButton extends StatelessWidget {
  final VoidCallback requestCameraPermission;
  const GrantPermissionButton(this.requestCameraPermission);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: requestCameraPermission,
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(
          Theme.of(context).accentColor
        )
      ),
      child: const Text(
        'Grant camera permission'
      )
    );
  }
}

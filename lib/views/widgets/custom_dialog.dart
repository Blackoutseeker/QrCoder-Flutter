import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomDialog extends StatelessWidget {
  final String qrcodeText;
  final bool canLaunchQrCodeText;
  final Future<void> Function() resumeCamera;
  const CustomDialog(this.qrcodeText, this.canLaunchQrCodeText, this.resumeCamera);

  void copyQrCodeTextToClipboard(BuildContext context) {
    Clipboard.setData(ClipboardData(text: qrcodeText));
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('QR code text copied to clipboard!'),
        duration: Duration(milliseconds: 2500)
      )
    );
  }

  void launchUrlFromQrCodeText() async {
    await launch(qrcodeText);
  }

  void dismissCustomDialog(BuildContext context) async {
    Navigator.pop(context, null);
    await resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      title: const Text('QR code text:'),
      content: Text(qrcodeText),
      actions: <TextButton> [
        TextButton(
          onPressed: () => copyQrCodeTextToClipboard(context),
          child: const Text('Copy')
        ),
        if (canLaunchQrCodeText)
          TextButton(
            onPressed: launchUrlFromQrCodeText,
            child: const Text('Open')
          ),
        TextButton(
          onPressed: () => dismissCustomDialog(context),
          child: const Text('Close')
        )
      ]
    );
  }
}

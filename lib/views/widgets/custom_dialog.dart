import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomDialog extends StatelessWidget {
  const CustomDialog(
    this._qrCodeText,
    this._canLaunchQrCodeText,
    this._resumeCamera, {
    super.key,
  });

  final String _qrCodeText;
  final bool _canLaunchQrCodeText;
  final Future<void> Function() _resumeCamera;

  void _copyQrCodeTextToClipboard(BuildContext context) {
    Clipboard.setData(ClipboardData(text: _qrCodeText));
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('QR code text copied to clipboard!'),
      duration: Duration(milliseconds: 2500),
    ));
  }

  void _launchUrlFromQrCodeText() async {
    await launchUrl(Uri.parse(_qrCodeText));
  }

  void _dismissCustomDialog(BuildContext context) async {
    Navigator.pop(context, null);
    await _resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      title: const Text('QR code text:'),
      content: Text(_qrCodeText),
      actions: <TextButton>[
        TextButton(
          onPressed: () => _copyQrCodeTextToClipboard(context),
          child: const Text('Copy'),
        ),
        if (_canLaunchQrCodeText)
          TextButton(
            onPressed: _launchUrlFromQrCodeText,
            child: const Text('Open'),
          ),
        TextButton(
          onPressed: () => _dismissCustomDialog(context),
          child: const Text('Close'),
        ),
      ],
    );
  }
}

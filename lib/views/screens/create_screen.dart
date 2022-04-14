import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:screenshot/screenshot.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'package:qrcoder/views/widgets/input.dart';
import 'package:qrcoder/views/widgets/save_button.dart';

class CreateScreen extends StatefulWidget {
  const CreateScreen();

  @override
  _CreateScreenState createState() => _CreateScreenState();
}

class _CreateScreenState extends State<CreateScreen> {
  final TextEditingController _textEditingController = TextEditingController();
  final ScreenshotController _screenshotController = ScreenshotController();

  PermissionStatus _storagePermissionStatus = PermissionStatus.denied;

  void _notifyUserWithSnackBar(String message, int milliseconds) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(milliseconds: milliseconds),
      ),
    );
  }

  Future<void> _requestStoragePermission() async {
    await Permission.storage
        .request()
        .then((PermissionStatus permissionStatus) => {
              this.setState(() {
                _storagePermissionStatus = permissionStatus;
              }),
            });
  }

  void _saveQrCode() {
    if (_storagePermissionStatus.isGranted &&
        _textEditingController.text.isNotEmpty)
      _screenshotController.capture().then((Uint8List? qrcodeImage) async {
        if (qrcodeImage != null) {
          final String captureTimestamp = new DateTime.now().toString();
          await ImageGallerySaver.saveImage(
            Uint8List.fromList(qrcodeImage),
            quality: 100,
            name: captureTimestamp,
          );
          _notifyUserWithSnackBar('QR code saved in your gallery!', 1500);
        }
      });
    else
      _requestStoragePermission();
    if (_storagePermissionStatus.isPermanentlyDenied)
      _notifyUserWithSnackBar(
          'Please grant storage permission to save QR codes.', 4000);
  }

  void _refreshOnTextFieldTextChange() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();

    _textEditingController.addListener(() {
      _refreshOnTextFieldTextChange();
    });

    final bool notHaveStoragePermission =
        _storagePermissionStatus != PermissionStatus.granted;
    if (notHaveStoragePermission) _requestStoragePermission();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(20),
          child: Input(_textEditingController, _saveQrCode),
        ),
        const SizedBox(height: 20),
        Screenshot(
          controller: _screenshotController,
          child: QrImage(
            data: _textEditingController.text,
            size: 250,
            backgroundColor: Colors.white,
          ),
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.all(20),
          child: SaveButton(_saveQrCode),
        ),
      ],
    );
  }
}

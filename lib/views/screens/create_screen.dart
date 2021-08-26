import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:qrcoder/views/widgets/input.dart';
import 'package:screenshot/screenshot.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:qrcoder/views/widgets/save_button.dart';

class CreateScreen extends StatefulWidget {
  const CreateScreen();

  @override
  _CreateScreenState createState() => _CreateScreenState();
}

class _CreateScreenState extends State<CreateScreen> {
  final TextEditingController textEditingController = TextEditingController();
  final ScreenshotController screenshotController = ScreenshotController();
  PermissionStatus storagePermissionStatus = PermissionStatus.denied;

  void notifyUserWithSnackBar(String message, int milliseconds) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(milliseconds: milliseconds)
      )
    );
  }

  void saveQrCode() {
    if (storagePermissionStatus.isGranted && textEditingController.text.isNotEmpty)
      screenshotController.capture().then((Uint8List? qrcodeImage) async {
        if (qrcodeImage != null) {
          final String captureTimestamp = new DateTime.now().toString();
          await ImageGallerySaver.saveImage(
            Uint8List.fromList(qrcodeImage),
            quality: 100,
            name: captureTimestamp
          );
          notifyUserWithSnackBar('QR code saved in your gallery!', 1500);
        }
      });
    else
      requestStoragePermission();
      if (storagePermissionStatus.isPermanentlyDenied)
        notifyUserWithSnackBar('Please grant storage permission to save QR codes.', 4000);
  }

  void requestStoragePermission() async {
    await Permission.storage.request()
    .then((PermissionStatus permissionStatus) => {
      this.setState(() {
        storagePermissionStatus = permissionStatus;
      })
    });
  }

  void refreshOnTextFieldTextChange() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();

    textEditingController.addListener(() {
      refreshOnTextFieldTextChange();
    });

    final bool notHaveStoragePermission = storagePermissionStatus != PermissionStatus.granted;
    if (notHaveStoragePermission)
      requestStoragePermission();
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget> [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Input(textEditingController, saveQrCode)
        ),
        const SizedBox(height: 20),
        Screenshot(
          controller: screenshotController,
          child: QrImage(
            data: textEditingController.text,
            size: 250,
            backgroundColor: Colors.white
          )
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.all(20),
          child: SaveButton(saveQrCode)
        )
      ]
    );
  }
}

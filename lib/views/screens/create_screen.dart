import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:qrcoder/utils/constants.dart';
import 'package:screenshot/screenshot.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'package:qrcoder/views/widgets/input.dart';
import 'package:qrcoder/views/widgets/save_button.dart';

class CreateScreen extends StatefulWidget {
  const CreateScreen({super.key});

  @override
  State<CreateScreen> createState() => _CreateScreenState();
}

class _CreateScreenState extends State<CreateScreen> {
  final TextEditingController _textEditingController = TextEditingController();
  final ScreenshotController _screenshotController = ScreenshotController();

  final BannerAd _bannerAd = BannerAd(
    adUnitId: Constants.bannerAdId,
    size: AdSize.banner,
    request: const AdRequest(),
    listener: const BannerAdListener(),
  );

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
              setState(() {
                _storagePermissionStatus = permissionStatus;
              }),
            });
  }

  void _saveQrCode() {
    if (_storagePermissionStatus.isGranted &&
        _textEditingController.text.isNotEmpty) {
      _screenshotController.capture().then((Uint8List? qrCodeImage) async {
        if (qrCodeImage != null) {
          final String captureTimestamp = DateTime.now().toString();
          await ImageGallerySaver.saveImage(
            Uint8List.fromList(qrCodeImage),
            quality: 100,
            name: captureTimestamp,
          );
          _notifyUserWithSnackBar('QR Code saved in your gallery!', 1500);
        }
      });
    } else {
      _requestStoragePermission();
    }
    if (_storagePermissionStatus.isPermanentlyDenied) {
      _notifyUserWithSnackBar(
        'Please grant storage permission to save QR Codes.',
        4000,
      );
    }
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

    _bannerAd.load();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    _bannerAd.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SizedBox(
          width: _bannerAd.size.width.toDouble(),
          height: _bannerAd.size.height.toDouble(),
          child: AdWidget(ad: _bannerAd),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Input(_textEditingController, _saveQrCode),
        ),
        const SizedBox(height: 20),
        Screenshot(
          controller: _screenshotController,
          child: QrImageView(
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

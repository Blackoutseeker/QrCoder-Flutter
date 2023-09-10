import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'package:qrcoder/utils/constants.dart';
import 'package:qrcoder/views/widgets/grant_permission_button.dart';
import 'package:qrcoder/views/widgets/custom_dialog.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  final ImagePicker _imagePicker = ImagePicker();

  final BannerAd _bannerAd = BannerAd(
    adUnitId: Constants.bannerAdId,
    size: AdSize.banner,
    request: const AdRequest(),
    listener: const BannerAdListener(),
  );

  final MobileScannerController _mobileScannerController =
      MobileScannerController(detectionSpeed: DetectionSpeed.noDuplicates);

  PermissionStatus _cameraPermissionStatus = PermissionStatus.denied;

  Future<void> _showCustomDialog(String barcodeText) async {
    final bool canLaunchQrCodeText = await canLaunchUrl(Uri.parse(barcodeText));
    if (mounted) {
      showDialog(
        context: context,
        builder: (_) => CustomDialog(
          barcodeText,
          canLaunchQrCodeText,
          _mobileScannerController.start,
        ),
        barrierDismissible: false,
        useSafeArea: true,
      );
    }
  }

  Future<void> _onBarcodeDetect(BarcodeCapture capture) async {
    final String? barcodeText = capture.barcodes.first.rawValue;
    if (barcodeText != null) {
      await _showCustomDialog(barcodeText);
    }
  }

  Future<void> _toggleCameraFlash() async {
    await _mobileScannerController.toggleTorch();
  }

  Future<void> _flipCamera() async {
    await _mobileScannerController.switchCamera();
  }

  Future<void> _scanImageFromGallery() async {
    await _mobileScannerController.stop();
    final XFile? image =
        await _imagePicker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      String barcodeText = await scanner.scanPath(image.path);
      _showCustomDialog(barcodeText);
    } else {
      await _mobileScannerController.start();
    }
  }

  Future<void> _requestCameraPermission() async {
    await Permission.camera
        .request()
        .then((PermissionStatus permissionStatus) => {
              setState(() {
                _cameraPermissionStatus = permissionStatus;
              })
            });
  }

  @override
  void initState() {
    super.initState();

    final bool notHaveCameraPermission =
        _cameraPermissionStatus != PermissionStatus.granted;
    if (notHaveCameraPermission) _requestCameraPermission();

    _bannerAd.load();
  }

  @override
  void dispose() {
    _mobileScannerController.dispose();
    _mobileScannerController.torchState.dispose();
    _bannerAd.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    FocusScope.of(context).requestFocus(FocusNode());

    if (_cameraPermissionStatus.isGranted) {
      return Stack(
        fit: StackFit.expand,
        alignment: AlignmentDirectional.bottomCenter,
        children: <Widget>[
          MobileScanner(
            onDetect: _onBarcodeDetect,
            controller: _mobileScannerController,
          ),
          Positioned(
            top: 16,
            child: SizedBox(
              width: _bannerAd.size.width.toDouble(),
              height: _bannerAd.size.height.toDouble(),
              child: AdWidget(ad: _bannerAd),
            ),
          ),
          Positioned(
            bottom: 20,
            width: 200,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(0, 0, 0, 0.5),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: IconButton(
                    icon: ValueListenableBuilder(
                      valueListenable: _mobileScannerController.torchState,
                      builder: (_, torchState, __) {
                        switch (torchState) {
                          case TorchState.off:
                            return const Icon(Icons.flash_on);
                          case TorchState.on:
                            return const Icon(Icons.flash_off);
                        }
                      },
                    ),
                    color: Colors.white,
                    onPressed: _toggleCameraFlash,
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(0, 0, 0, 0.5),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.cameraswitch),
                    color: Colors.white,
                    onPressed: _flipCamera,
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(0, 0, 0, 0.5),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.photo_library),
                    color: Colors.white,
                    onPressed: _scanImageFromGallery,
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    } else if (_cameraPermissionStatus.isDenied) {
      return Center(child: GrantPermissionButton(_requestCameraPermission));
    } else {
      return const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 40),
          child: Text(
            'Please grant camera permission to scan QR codes.',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
        ),
      );
    }
  }
}

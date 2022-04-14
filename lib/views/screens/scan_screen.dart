import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:qr_code_tools/qr_code_tools.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:qrcoder/views/widgets/grant_permission_button.dart';
import 'package:qrcoder/views/widgets/custom_dialog.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen();

  @override
  _ScanScreenState createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  final GlobalKey _qrViewKey = GlobalKey();
  final ImagePicker _imagePicker = ImagePicker();
  final BannerAd _bannerAd = BannerAd(
    adUnitId: dotenv.env['BANNER_AD_UNIT_ID']!,
    size: AdSize.banner,
    request: AdRequest(),
    listener: BannerAdListener(),
  );

  QRViewController? _qrViewController;
  PermissionStatus _cameraPermissionStatus = PermissionStatus.denied;
  bool _isFlashlightOff = false;

  Future<void> _showCustomDialog(String barcodeText) async {
    final bool canLaunchUrl = await canLaunch(barcodeText);
    showDialog(
      context: context,
      builder: (_) => CustomDialog(
        barcodeText,
        canLaunchUrl,
        _qrViewController!.resumeCamera,
      ),
      barrierDismissible: false,
      useSafeArea: true,
    );
  }

  void _onQRViewCreated(QRViewController qrViewController) {
    setState(() {
      this._qrViewController = qrViewController;
    });
    qrViewController.scannedDataStream.listen((Barcode barcode) async {
      await qrViewController.pauseCamera();
      _showCustomDialog(barcode.code);
    });
  }

  Future<void> _toggleCameraFlash() async {
    await _qrViewController?.toggleFlash();
    setState(() {
      this._isFlashlightOff = !this._isFlashlightOff;
    });
  }

  Future<void> _flipCamera() async {
    await _qrViewController?.flipCamera();
  }

  Future<void> _scanImageFromGallery() async {
    await _qrViewController?.pauseCamera();
    final XFile? image =
        await _imagePicker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      String barcodeText = await QrCodeToolsPlugin.decodeFrom(image.path);
      _showCustomDialog(barcodeText);
    } else
      _qrViewController?.resumeCamera();
  }

  Future<void> _requestCameraPermission() async {
    await Permission.camera
        .request()
        .then((PermissionStatus permissionStatus) => {
              this.setState(() {
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
    _qrViewController?.dispose();
    _bannerAd.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    FocusScope.of(context).requestFocus(FocusNode());

    if (_cameraPermissionStatus.isGranted)
      return Stack(
        fit: StackFit.expand,
        alignment: AlignmentDirectional.bottomCenter,
        children: <Widget>[
          QRView(
            key: _qrViewKey,
            onQRViewCreated: _onQRViewCreated,
            overlay: QrScannerOverlayShape(borderColor: Colors.white),
          ),
          Positioned(
            top: 16,
            child: SizedBox(
              child: AdWidget(ad: _bannerAd),
              width: _bannerAd.size.width.toDouble(),
              height: _bannerAd.size.height.toDouble(),
            ),
          ),
          Positioned(
            bottom: 20,
            width: 200,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                IconButton(
                  icon: Icon(
                    _isFlashlightOff ? Icons.flash_off : Icons.flash_on,
                  ),
                  color: Colors.white,
                  onPressed: _toggleCameraFlash,
                ),
                IconButton(
                  icon: const Icon(Icons.cameraswitch),
                  color: Colors.white,
                  onPressed: _flipCamera,
                ),
                IconButton(
                  icon: const Icon(Icons.photo_library),
                  color: Colors.white,
                  disabledColor: const Color.fromRGBO(255, 255, 255, 0.3),
                  onPressed: _scanImageFromGallery,
                ),
              ],
            ),
          ),
        ],
      );
    else if (_cameraPermissionStatus.isDenied)
      return Center(child: GrantPermissionButton(_requestCameraPermission));
    else
      return Center(
        child: const Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: const Text(
            'Please grant camera permission to scan QR codes.',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
        ),
      );
  }
}

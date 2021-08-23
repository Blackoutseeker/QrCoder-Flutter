import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:qrcoder/views/widgets/grant_permission_button.dart';
import 'package:qrcoder/views/widgets/custom_dialog.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen();

  @override
  _ScanScreenState createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  final GlobalKey qrViewKey = GlobalKey();
  QRViewController? qrViewController;
  PermissionStatus cameraPermissionStatus = PermissionStatus.denied;

  void showCustomDialog(String barcodeText) async {
    final bool canLaunchUrl = await canLaunch(barcodeText);
    showDialog(
      context: context,
      builder: (_) => CustomDialog(barcodeText, canLaunchUrl, qrViewController!.resumeCamera),
      barrierDismissible: false,
      useSafeArea: true
    );
  }

  void onQRViewCreated(QRViewController qrViewController) {
    setState(() {
      this.qrViewController = qrViewController;
    });
    qrViewController.scannedDataStream.listen((Barcode barcode) async {
      await qrViewController.pauseCamera();
      showCustomDialog(barcode.code);
    });
  }

  void toggleCameraFlash() async {
    await qrViewController?.toggleFlash();
  }

  void flipCamera() async {
    await qrViewController?.flipCamera();
  }

  void requestCameraPermission() async {
    await Permission.camera.request()
    .then((PermissionStatus permissionStatus) => {
      this.setState(() {
        cameraPermissionStatus = permissionStatus;
      })
    });
  }

  @override
  void initState() {
    super.initState();

    final bool notHaveCameraPermission = cameraPermissionStatus != PermissionStatus.granted;
    if (notHaveCameraPermission)
      requestCameraPermission();
  }

  @override
  void dispose() {
    qrViewController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (cameraPermissionStatus.isGranted)
      return Stack(
        fit: StackFit.expand,
        alignment: AlignmentDirectional.bottomCenter,
        children: <Widget> [
          QRView(
            key: qrViewKey,
            onQRViewCreated: onQRViewCreated,
            overlay: QrScannerOverlayShape(
              borderColor: Colors.white
            )
          ),
          Positioned(
            bottom: 20,
            width: 150,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget> [
                IconButton(
                  icon: const Icon(Icons.flash_on),
                  color: Colors.white,
                  onPressed: toggleCameraFlash
                ),
                IconButton(
                  icon: const Icon(Icons.cameraswitch),
                  color: Colors.white,
                  onPressed: flipCamera
                )
              ]
            )
          )
        ]
      );
    else if (cameraPermissionStatus.isDenied)
      return Center(
        child: GrantPermissionButton(requestCameraPermission)
      );
    else
      return Center(
        child: const Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 40
          ),
          child: const Text(
            'Please grant camera permission to scan QR codes.',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20
            )
          )
        )
      );
  }
}

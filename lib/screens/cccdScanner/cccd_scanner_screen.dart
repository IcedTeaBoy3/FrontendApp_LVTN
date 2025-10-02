import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';

class ScanCCCDScreen extends StatefulWidget {
  const ScanCCCDScreen({super.key});

  @override
  State<ScanCCCDScreen> createState() => _ScanCCCDScreenState();
}

class _ScanCCCDScreenState extends State<ScanCCCDScreen> {
  bool _hasPermission = false;

  @override
  void initState() {
    super.initState();
    _requestCameraPermission();
  }

  Future<void> _requestCameraPermission() async {
    var status = await Permission.camera.request();
    if (status.isGranted) {
      setState(() => _hasPermission = true);
    } else {
      openAppSettings(); // nếu bị từ chối vĩnh viễn thì mở cài đặt
    }
  }

  void _onDetect(BarcodeCapture capture) {
    final String? rawValue = capture.barcodes.first.rawValue;
    if (rawValue != null) {
      debugPrint("Quét được: $rawValue");

      // Chuyển route
      context.goNamed('addPatientProfile', queryParameters: {
        'infoIdCard': rawValue,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_hasPermission) {
      return const Scaffold(
        body: Center(child: Text("Cần quyền camera để quét CCCD")),
      );
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Quét CCCD",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
      ),
      body: Stack(
        children: [
          MobileScanner(onDetect: _onDetect),
          Align(
            alignment: Alignment.center,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.green, width: 2),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

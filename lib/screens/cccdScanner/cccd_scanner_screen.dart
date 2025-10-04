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
  bool _isScanning = false;

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
      context.goNamed('addEditPatientProfile', queryParameters: {
        'infoIdCard': rawValue,
      });
    }
  }

  void _onSelectImage() {
    debugPrint("Chọn ảnh từ thư viện");
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
          if (_isScanning)
            MobileScanner(onDetect: _onDetect)
          else
            Container(color: Colors.white),
          Align(
            alignment: Alignment.center,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.green, width: 2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: _isScanning
                  ? null
                  : const Center(
                      child: Icon(
                        Icons.qr_code_2,
                        size: 100,
                        color: Colors.grey,
                      ),
                    ),
            ),
          ),
          Positioned(
            bottom: 80,
            left: 0,
            right: 0,
            child: Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  textStyle: const TextStyle(fontSize: 16),
                  backgroundColor: _isScanning ? Colors.grey : Colors.blue,
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  setState(() {
                    _isScanning = true;
                  });
                },
                child: const Text("Bắt đầu quét"),
              ),
            ),
          ),
          Positioned(
            bottom: 50,
            left: 0,
            right: 0,
            child: Center(
              child: GestureDetector(
                onTap: _onSelectImage,
                child: const Text(
                  "Hoặc chọn ảnh từ thư viện",
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 16,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 150,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                color: Colors.black54,
                child: Text(
                  _isScanning
                      ? "Đặt CCCD trong khung để quét"
                      : "Nhấn nút để bắt đầu quét",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

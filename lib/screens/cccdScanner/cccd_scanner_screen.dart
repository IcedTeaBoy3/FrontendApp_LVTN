import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:go_router/go_router.dart';

class CccdScannerPage extends StatefulWidget {
  const CccdScannerPage({super.key});

  @override
  State<CccdScannerPage> createState() => _CccdScannerPageState();
}

class _CccdScannerPageState extends State<CccdScannerPage> {
  bool _found = false;

  void _handleBarcode(String raw) async {
    if (_found) return;
    _found = true;

    final parsed = _parseCccdRaw(raw);

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Dữ liệu phát hiện'),
        content: Text(parsed.toString()),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Hủy')),
          ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Xác nhận')),
        ],
      ),
    );

    if (confirm == true) {
      // Chuyển thẳng sang trang AddPatientProfile
      if (mounted) {
        context.goNamed('addPatientProfile', extra: parsed);
      }
    } else {
      _found = false;
    }
  }

  Map<String, dynamic> _parseCccdRaw(String raw) {
    try {
      final obj = jsonDecode(raw);
      if (obj is Map<String, dynamic>) return obj;
    } catch (_) {}

    final idMatch = RegExp(r'\b\d{9,12}\b').firstMatch(raw);
    final dobMatch =
        RegExp(r'(\d{1,2}[\/\-]\d{1,2}[\/\-]\d{4})').firstMatch(raw);

    return {
      'raw': raw,
      'id': idMatch?.group(0) ?? '',
      'dob': dobMatch?.group(0) ?? '',
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Quét mã CCCD')),
      body: MobileScanner(
        onDetect: (capture) {
          final raw = capture.barcodes.first.rawValue ?? '';
          if (raw.isNotEmpty) _handleBarcode(raw);
        },
      ),
    );
  }
}

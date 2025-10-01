import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../routes/app_routes.dart';

class ScannerController extends GetxController {
  MobileScannerController? controller;
  RxBool isScanning = true.obs;
  RxString scannedCode = ''.obs;
  RxBool isFlashOn = false.obs;

  @override
  void onInit() {
    super.onInit();
    controller = MobileScannerController();
  }

  @override
  void onClose() {
    controller?.dispose();
    super.onClose();
  }

  void handleScanResult(BarcodeCapture capture) {
    if (!isScanning.value) return;

    final List<Barcode> barcodes = capture.barcodes;
    if (barcodes.isEmpty) return;

    final String? code = barcodes.first.rawValue;
    if (code == null || code.isEmpty) return;

    // Prevent multiple rapid scans
    isScanning.value = false;
    scannedCode.value = code;

    // Add a small delay to show the scanning effect completion
    Future.delayed(const Duration(milliseconds: 200), () {
      if (code == 'login123') {
        // Valid scan - navigate to dashboard with the code
        Get.offNamed(AppRoutes.dashboard, arguments: code);
      } else {
        // Invalid scan - show error and redirect to home

        Get.offAllNamed(AppRoutes.home);

        Get.snackbar(
          'Invalid Scan',
          'The scanned code is not valid. Redirecting to home page.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
          margin: const EdgeInsets.only(left: 16, right: 16, bottom: 24),
          borderRadius: 12,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        );
      }
    });
  }

  void toggleFlash() {
    controller?.toggleTorch();
    isFlashOn.value = !isFlashOn.value;
  }

  void flipCamera() {
    controller?.switchCamera();
  }

  void resumeScanning() {
    isScanning.value = true;
  }
}

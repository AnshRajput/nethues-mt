import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../controllers/scanner_controller.dart';

class ScannerPage extends StatefulWidget {
  const ScannerPage({super.key});

  @override
  State<ScannerPage> createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage>
    with TickerProviderStateMixin {
  late AnimationController _scanAnimationController;
  late Animation<double> _scanAnimation;

  @override
  void initState() {
    super.initState();
    _scanAnimationController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    _scanAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _scanAnimationController,
        curve: Curves.easeInOut,
      ),
    );
    _scanAnimationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _scanAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ScannerController controller = Get.put(ScannerController());
    final screenSize = MediaQuery.of(context).size;
    final scanAreaSize = screenSize.width * 0.7; // 70% of screen width

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          'Scanner',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
      ),
      body: MobileScanner(
        controller: controller.controller!,
        onDetect: controller.handleScanResult,
        overlayBuilder: (context, constraints) => Container(
          color: Colors.black.withValues(alpha: 0.4),
          child: Stack(
            children: [
              // Scan area border
              Center(
                child: Container(
                  width: scanAreaSize,
                  height: scanAreaSize * 1.5,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),

              // Animated scanning line
              Obx(
                () => controller.isScanning.value
                    ? Center(
                        child: AnimatedBuilder(
                          animation: _scanAnimation,
                          builder: (context, child) {
                            return SizedBox(
                              width: scanAreaSize,
                              height: scanAreaSize * 1.5,
                              child: CustomPaint(
                                painter: ScanningLinePainter(
                                  animationValue: _scanAnimation.value,
                                  scanAreaHeight: scanAreaSize * 1.5,
                                ),
                              ),
                            );
                          },
                        ),
                      )
                    : const SizedBox.shrink(),
              ),

              // Control buttons
              Positioned(
                bottom: 80,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Flash toggle
                    _buildControlButton(
                      icon: Obx(
                        () => Icon(
                          controller.isFlashOn.value
                              ? Icons.flash_on
                              : Icons.flash_off,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                      onPressed: controller.toggleFlash,
                    ),

                    // Camera flip
                    _buildControlButton(
                      icon: const Icon(
                        Icons.flip_camera_ios,
                        color: Colors.white,
                        size: 28,
                      ),
                      onPressed: controller.flipCamera,
                    ),
                  ],
                ),
              ),

              // Loading indicator
              Obx(
                () => controller.isScanning.value
                    ? const SizedBox.shrink()
                    : const Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildControlButton({
    required Widget icon,
    required VoidCallback onPressed,
  }) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: IconButton(icon: icon, onPressed: onPressed),
    );
  }
}

class ScanningLinePainter extends CustomPainter {
  final double animationValue;
  final double scanAreaHeight;

  ScanningLinePainter({
    required this.animationValue,
    required this.scanAreaHeight,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Create gradient effect for the scanning line
    final gradient = LinearGradient(
      colors: [
        Colors.white.withValues(alpha: 0.0),
        Colors.white.withValues(alpha: 1.0),
        Colors.white.withValues(alpha: 0.0),
      ],
      stops: const [0.0, 0.5, 1.0],
    );

    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final gradientPaint = Paint()
      ..shader = gradient.createShader(rect)
      ..strokeWidth = 3.0
      ..style = PaintingStyle.stroke;

    // Calculate the position of the scanning line
    final lineY = animationValue * scanAreaHeight;

    // Draw the main scanning line
    canvas.drawLine(Offset(0, lineY), Offset(size.width, lineY), gradientPaint);

    // Add a subtle glow effect
    final glowPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.3)
      ..strokeWidth = 8.0
      ..style = PaintingStyle.stroke
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4.0);

    canvas.drawLine(Offset(0, lineY), Offset(size.width, lineY), glowPaint);
  }

  @override
  bool shouldRepaint(ScanningLinePainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}

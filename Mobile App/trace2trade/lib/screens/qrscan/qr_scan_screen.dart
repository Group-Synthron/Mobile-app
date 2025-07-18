import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:trace2trade/constants/colors.dart';
import 'package:trace2trade/screens/qrscan/qr_scan_controller.dart';
import 'package:trace2trade/widgets/custom_button.dart';

class QrScanScreen extends StatelessWidget {
  const QrScanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final QrScanController controller = Get.find<QrScanController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Scan QR Code"),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!controller.hasPermission.value) {
          return _buildPermissionRequestUI(controller);
        }

        if (controller.scannerState.value == ScannerState.error) {
          return _buildErrorUI(controller);
        }

        return Stack(
          alignment: Alignment.center,
          children: [
            MobileScanner(
              controller: controller.cameraController,
              onDetect: (capture) => controller.onQRCodeDetected(capture),
            ),
            _buildScannerOverlay(context, controller.animationController),
          ],
        );
      }),
    );
  }

  Widget _buildPermissionRequestUI(QrScanController controller) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.camera_alt,
              size: 80,
              color: AppColors.secondaryGray,
            ),
            const SizedBox(height: 16),
            const Text(
              "Camera Permission Required",
              style: TextStyle(color: Colors.white, fontSize: 22),
            ),
            const SizedBox(height: 8),
            const Text(
              "Please grant camera access to scan QR codes.",
              style: TextStyle(color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            CustomButton(
              label: "Grant Permission",
              onPressed: () => controller.requestPermission(),
              isLoading: controller.isLoading.value,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorUI(QrScanController controller) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 80, color: Colors.red),
            const SizedBox(height: 16),
            const Text(
              "Scanning Error",
              style: TextStyle(color: Colors.white, fontSize: 22),
            ),
            const SizedBox(height: 8),
            const Text(
              "An error occurred while scanning. Please try again.",
              style: TextStyle(color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            CustomButton(
              label: "Retry",
              onPressed: () {
                controller.scannerState.value = ScannerState.scanning;
                controller.resumeScanner();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScannerOverlay(
    BuildContext context,
    Animation<double> animation,
  ) {
    final double scanAreaSize = MediaQuery.of(context).size.width * 0.7;

    return CustomPaint(
      size: MediaQuery.of(context).size,
      painter: _ScannerOverlayPainter(
        scanAreaSize: scanAreaSize,
        animation: animation,
      ),
    );
  }
}

class _ScannerOverlayPainter extends CustomPainter {
  final double scanAreaSize;
  final Animation<double> animation;

  _ScannerOverlayPainter({required this.scanAreaSize, required this.animation})
    : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final rect = Rect.fromCenter(
      center: center,
      width: scanAreaSize,
      height: scanAreaSize,
    );

    // Darkened overlay
    canvas.drawPath(
      Path.combine(
        PathOperation.difference,
        Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height)),
        Path()
          ..addRRect(RRect.fromRectAndRadius(rect, const Radius.circular(20))),
      ),
      Paint()..color = Colors.black.withOpacity(0.6),
    );

    // Border paint
    final borderPaint =
        Paint()
          ..color = Colors.greenAccent
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3.0;

    const cornerLength = 30.0;

    // Draw corners
    final path =
        Path()
          ..moveTo(rect.left, rect.top + cornerLength)
          ..lineTo(rect.left, rect.top)
          ..lineTo(rect.left + cornerLength, rect.top) // Top-left
          ..moveTo(rect.right - cornerLength, rect.top)
          ..lineTo(rect.right, rect.top)
          ..lineTo(rect.right, rect.top + cornerLength) // Top-right
          ..moveTo(rect.right, rect.bottom - cornerLength)
          ..lineTo(rect.right, rect.bottom)
          ..lineTo(rect.right - cornerLength, rect.bottom) // Bottom-right
          ..moveTo(rect.left + cornerLength, rect.bottom)
          ..lineTo(rect.left, rect.bottom)
          ..lineTo(rect.left, rect.bottom - cornerLength); // Bottom-left
    canvas.drawPath(path, borderPaint);

    // Animated scanning line
    final animationRect = Rect.fromLTRB(
      rect.left,
      rect.top + (rect.height * animation.value),
      rect.right,
      rect.top + (rect.height * animation.value),
    );

    final linePaint =
        Paint()
          ..color = Colors.greenAccent.withOpacity(0.8)
          ..strokeWidth = 3.0
          ..shader = const LinearGradient(
            colors: [
              Colors.transparent,
              Colors.greenAccent,
              Colors.transparent,
            ],
            stops: [0.0, 0.5, 1.0],
          ).createShader(animationRect);

    canvas.drawLine(animationRect.topLeft, animationRect.topRight, linePaint);
  }

  @override
  bool shouldRepaint(covariant _ScannerOverlayPainter oldDelegate) {
    return animation.value != oldDelegate.animation.value;
  }
}
import 'package:flutter/material.dart';
import 'package:trace2trade/services/PermissionsService.dart';
import 'package:trace2trade/constants/colors.dart';

class PermissionsWrapper extends StatefulWidget {
  final Widget child;
  
  const PermissionsWrapper({
    super.key,
    required this.child,
  });

  @override
  State<PermissionsWrapper> createState() => _PermissionsWrapperState();
}

class _PermissionsWrapperState extends State<PermissionsWrapper> {
  bool _isCheckingPermissions = true;
  bool _permissionsGranted = false;
  String _statusMessage = 'Checking permissions...';

  @override
  void initState() {
    super.initState();
    _checkAndRequestPermissions();
  }

  Future<void> _checkAndRequestPermissions() async {
    setState(() {
      _statusMessage = 'Checking existing permissions...';
    });

    // Check if permissions are already granted
    bool hasPermissions = await PermissionsService.checkAllPermissions();
    
    if (hasPermissions) {
      setState(() {
        _permissionsGranted = true;
        _isCheckingPermissions = false;
      });
      return;
    }

    // Request permissions
    setState(() {
      _statusMessage = 'Requesting permissions...';
    });
    
    bool granted = await PermissionsService.requestAllPermissions();
    
    setState(() {
      _permissionsGranted = granted;
      _isCheckingPermissions = false;
      _statusMessage = granted 
          ? 'Permissions granted successfully!'
          : 'Some permissions were denied. You can enable them later in settings.';
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isCheckingPermissions) {
      return Scaffold(
        backgroundColor: AppColors.darkBg,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
              ),
              const SizedBox(height: 20),
              Text(
                _statusMessage,
                style: const TextStyle(
                  fontSize: 16,
                  color: AppColors.textLight,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              const Text(
                'Trace2Trade needs some permissions to work properly:',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.grey,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              const Text(
                '• Camera - For QR code scanning\n'
                '• Bluetooth - For device connectivity\n'
                '• Location - Required for Bluetooth\n'
                '• Storage - For saving documents',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.grey,
                ),
                textAlign: TextAlign.left,
              ),
            ],
          ),
        ),
      );
    }

    if (!_permissionsGranted) {
      return Scaffold(
        backgroundColor: AppColors.darkBg,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.warning_amber_rounded,
                  size: 80,
                  color: Colors.orange,
                ),
                const SizedBox(height: 20),
                const Text(
                  'Permissions Required',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textLight,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Text(
                  _statusMessage,
                  style: const TextStyle(
                    fontSize: 16,
                    color: AppColors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _checkAndRequestPermissions,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.textLight,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text('Request Permissions Again'),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        _permissionsGranted = true;
                      });
                    },
                    child: const Text(
                      'Continue Without Permissions',
                      style: TextStyle(color: AppColors.grey),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    // All permissions granted, show the actual app
    return widget.child;
  }
}
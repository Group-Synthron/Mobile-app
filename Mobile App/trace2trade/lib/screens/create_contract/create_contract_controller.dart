import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:trace2trade/services/smart_contract_service.dart';
import 'package:walletconnect_flutter_v2/walletconnect_flutter_v2.dart';
import 'package:trace2trade/constants/colors.dart';

class CreateContractController extends GetxController {
  final SmartContractService _contractService = SmartContractService();

  final vesselNameController = TextEditingController();
  final registrationNumberController = TextEditingController();
  final licensesController = TextEditingController();

  var isLoading = false.obs;
  var loadingMessage = ''.obs;
  var isWalletConnected = false.obs;
  var connectedAddress = ''.obs;

  Web3App? web3App;

  @override
  void onInit() {
    super.onInit();
    _initialize();
  }

  Future<void> _initialize() async {
    try {
      await _contractService.init();
      web3App = _contractService.getWeb3App();
      if (web3App != null) {
        _checkExistingSessions();
        web3App!.onSessionConnect.subscribe(_onSessionConnect);
        web3App!.onSessionDelete.subscribe(_onSessionDelete);
      }
    } catch (e) {
      Get.snackbar("Initialization Error", e.toString(),
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }
  
  void _checkExistingSessions() {
    if (web3App != null && web3App!.sessions.getAll().isNotEmpty) {
      final session = web3App!.sessions.getAll().first;
      connectedAddress.value = NamespaceUtils.getAccount(
        session.namespaces.values.first.accounts.first,
      );
      isWalletConnected.value = true;
    }
  }

  void _onSessionConnect(SessionConnect? args) {
    if (args != null) {
      _checkExistingSessions();
      if (Get.isDialogOpen ?? false) {
        Get.back(); // Close the QR code dialog
      }
    }
  }

  void _onSessionDelete(SessionDelete? args) {
    isWalletConnected.value = false;
    connectedAddress.value = '';
  }

  @override
  void onClose() {
    vesselNameController.dispose();
    registrationNumberController.dispose();
    licensesController.dispose();
    web3App?.onSessionConnect.unsubscribe(_onSessionConnect);
    web3App?.onSessionDelete.unsubscribe(_onSessionDelete);
    super.onClose();
  }

 Future<void> connectWallet() async {
    // Replace isInitializing check with proper connection state check
    if (web3App == null) {
      Get.snackbar("Error", "Wallet connection not initialized",
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    try {
      loadingMessage.value = "Connecting to Wallet...";
      isLoading.value = true;
      
      // Check if we already have an active session
      if (web3App!.sessions.getAll().isNotEmpty) {
        _checkExistingSessions();
        isLoading.value = false;
        return;
      }

      ConnectResponse response = await web3App!.connect(
        requiredNamespaces: {
          'eip155': const RequiredNamespace(
            chains: ['eip155:11155111'],
            methods: ['eth_sendTransaction', 'personal_sign'],
            events: ['chainChanged', 'accountsChanged'],
          ),
        },
      );
      
      final Uri? uri = response.uri;
      isLoading.value = false;

      if (uri != null) {
        Get.dialog(
          Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            backgroundColor: AppColors.primaryGreen,
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text("Scan with Wallet", 
                      style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white, 
                      borderRadius: BorderRadius.circular(12)),
                    child: QrImageView(
                      data: uri.toString(), 
                      version: QrVersions.auto, 
                      size: 200.0),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Scan this QR code with a WalletConnect-compatible mobile wallet.",
                    textAlign: TextAlign.center, 
                    style: TextStyle(color: Colors.grey[300])),
                ],
              ),
            ),
          ),
          barrierDismissible: false,
        );
      }
      await response.session.future;
    } catch (e) {
      Get.snackbar("Error", "Failed to connect wallet: ${e.toString()}", 
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> disconnectWallet() async {
    if (web3App != null && web3App!.sessions.getAll().isNotEmpty) {
      try {
        await web3App!.disconnectSession(
          topic: web3App!.sessions.getAll().first.topic,
          reason: WalletConnectError(
            code: 6000, 
            message: "User disconnected"
          ),
        );
      } catch (e) {
        Get.snackbar("Error", "Failed to disconnect: ${e.toString()}",
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    }
  }

  Future<void> createVesselContract() async {
    if (!isWalletConnected.value) {
      Get.snackbar("Error", "Please connect your wallet first.",
          backgroundColor: Colors.orange, colorText: Colors.white);
      return;
    }
    
    if (vesselNameController.text.isEmpty || registrationNumberController.text.isEmpty) {
      Get.snackbar("Error", "Vessel Name and Registration Number are required.",
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }
    
    try {
      loadingMessage.value = "Awaiting transaction confirmation in your wallet...";
      isLoading.value = true;
      
      final licenses = licensesController.text
          .split(',')
          .map((e) => e.trim())
          .where((s) => s.isNotEmpty)
          .toList();
      
      final txHash = await _contractService.createVessel(
        vesselName: vesselNameController.text,
        registrationNumber: registrationNumberController.text,
        licenses: licenses,
      );
      
      Get.snackbar("Success", "Transaction sent! Hash: $txHash",
          backgroundColor: Colors.green, 
          colorText: Colors.white, 
          duration: const Duration(seconds: 5));
      Get.back();
    } catch (e) {
      Get.snackbar("Transaction Failed", e.toString(),
          backgroundColor: Colors.red, 
          colorText: Colors.white, 
          duration: const Duration(seconds: 5));
    } finally {
      isLoading.value = false;
    }
  }
}
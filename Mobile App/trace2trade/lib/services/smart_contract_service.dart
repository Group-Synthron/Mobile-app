import 'dart:async';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:walletconnect_flutter_v2/walletconnect_flutter_v2.dart';

class SmartContractService {
  final String _rpcUrl = "https://sepolia.infura.io/v3/YOUR_INFURA_PROJECT_ID"; // Example: Sepolia Testnet
  final String _contractAddress = "YOUR_DEPLOYED_CONTRACT_ADDRESS";
  
  late Web3Client _client;
  late DeployedContract _contract;
  Web3App? _web3app; // The WalletConnect v2 client

  final Completer<Web3App> _web3AppCompleter = Completer<Web3App>();

  SmartContractService() {
    _client = Web3Client(_rpcUrl, Client());
  }

  // Call this method once to initialize the service
  Future<void> init() async {
    // Initialize WalletConnect client
    _web3app = await Web3App.createInstance(
      projectId: "YOUR_WALLETCONNECT_PROJECT_ID", // Get this from https://cloud.walletconnect.com
      metadata: const PairingMetadata(
        name: 'Trace2Trade App',
        description: 'Fish Inventory & Traceability',
        url: 'https://trace2trade.com',
        icons: ['https://trace2trade.com/logo.png'],
      ),
    );
     _web3AppCompleter.complete(_web3app);

    // Load the smart contract ABI
    final abiJson = await rootBundle.loadString("assets/contracts/VesselContract.json");
    final abi = ContractAbi.fromJson(abiJson, "VesselContract");
    _contract = DeployedContract(abi, EthereumAddress.fromHex(_contractAddress));
  }

  Web3App getWeb3App() {
    if (_web3app == null) {
      throw StateError("SmartContractService not initialized. Call init() first.");
    }
    return _web3app!;
  }

  Future<String> createVessel({
    required String vesselName,
    required String registrationNumber,
    required List<String> licenses,
  }) async {
    final web3App = await _web3AppCompleter.future;

    if (web3App.sessions.getAll().isEmpty) {
        throw Exception("No active wallet session found. Please connect first.");
    }
    
    final session = web3App.sessions.getAll().first;
    final walletAddress = NamespaceUtils.getAccount(
        session.namespaces.values.first.accounts.first,
    );

    // The web3dart client is used to encode the function call data
    final transactionData = _contract.function('createVessel').encodeCall([
        vesselName,
        registrationNumber,
        licenses
    ]);

    try {
      // Send the transaction through WalletConnect
      final txHash = await web3App.request(
        topic: session.topic,
        chainId: 'eip155:11155111', // Sepolia Testnet Chain ID
        request: SessionRequestParams( // <--- FIX: Changed from SessionRequest to SessionRequestParams
          method: 'eth_sendTransaction',
          params: [
            {
              'from': walletAddress,
              'to': _contract.address.hex,
              'data': bytesToHex(transactionData, include0x: true),
            },
          ],
        ),
      );
      return txHash.toString();
    } catch (e) {
      print("Error sending transaction: $e");
      throw Exception("Failed to create vessel. The transaction was rejected or failed.");
    }
  }
}

import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:trace2trade/routes/app_routes.dart';
import 'package:trace2trade/screens/bluetooth/bluetooth_screen.dart';
import 'package:trace2trade/screens/create_contract/create_contract_binding.dart';
import 'package:trace2trade/screens/create_contract/create_contract_screen.dart';
import 'package:trace2trade/screens/dashboard/dashboard_binding.dart';
import 'package:trace2trade/screens/dashboard/dashboard_screen.dart';
import 'package:trace2trade/screens/login/login_binding.dart';
import 'package:trace2trade/screens/login/login_screen.dart'; // <-- ADD THIS IMPORT
import 'package:trace2trade/screens/bluetooth/bluetooth_binding.dart';
import 'package:trace2trade/screens/qrgenerator/qr_generate_binding.dart';
import 'package:trace2trade/screens/qrgenerator/qr_generate_screen.dart';
import 'package:trace2trade/screens/qrscan/qr_scan_binding.dart';
import 'package:trace2trade/screens/qrscan/qr_scan_screen.dart';

class AppPages {
  // ...
  static final routes = [
    // ... other routes
    GetPage(
      name: Routes.LOGIN,
      page: () => const LoginScreen(),
      binding: LoginBinding(), // <-- ADD THIS BINDING
    ),
    GetPage(
      name: Routes.BLUETOOTH,
      page: () => const BluetoothScreen(),
      binding: BluetoothBinding(), // <-- ADD THIS BINDING
    ),
    GetPage(
      name: Routes.DASHBOARD,
      page: () => const DashboardScreen(),
      binding: DashboardBinding(), // <-- ADD THIS BINDING
    ),
    GetPage(
      name: Routes.CREATE_CONTRACT,
      page: () => const CreateContractScreen(),
      binding: CreateContractBinding(), // <-- ADD THIS
    ),
     GetPage(
      name: Routes.QR_GENERATE,
      page: () => const QrGenerateScreen(),
      binding: QrGenerateBinding(), // <-- ADD THIS
    ),
     GetPage(
      name: Routes.QR_SCAN,
      page: () => const QrScanScreen(),
      binding: QrScanBinding(), // <-- ADD THIS
    ),
    // ... other routes
  ];
}
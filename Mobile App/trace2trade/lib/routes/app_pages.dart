import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:trace2trade/routes/app_routes.dart';
import 'package:trace2trade/screens/Inventory/inventory_map_screen.dart';
import 'package:trace2trade/screens/bluetooth/bluetooth_screen.dart';
import 'package:trace2trade/screens/create_contract/create_contract_binding.dart';
import 'package:trace2trade/screens/create_contract/create_contract_screen.dart';
import 'package:trace2trade/screens/dashboard/dashboard_binding.dart';
import 'package:trace2trade/screens/dashboard/dashboard_screen.dart';
import 'package:trace2trade/screens/login/login_binding.dart';
import 'package:trace2trade/screens/login/login_screen.dart';
import 'package:trace2trade/screens/welcome/welcome_screen.dart';
import 'package:trace2trade/screens/bluetooth/bluetooth_binding.dart';
import 'package:trace2trade/screens/qrgenerator/qr_generate_binding.dart';
import 'package:trace2trade/screens/qrgenerator/qr_generate_screen.dart';
import 'package:trace2trade/screens/qrscan/qr_scan_binding.dart';
import 'package:trace2trade/screens/qrscan/qr_scan_screen.dart';

class AppPages {
  static final routes = [
    GetPage(
      name: Routes.WELCOME,
      page: () => const WelcomeScreen(),
    ),
    GetPage(
      name: Routes.LOGIN,
      page: () => const LoginScreen(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: Routes.BLUETOOTH,
      page: () => const BluetoothScreen(),
      binding: BluetoothBinding(),
    ),
    GetPage(
      name: Routes.DASHBOARD,
      page: () => const DashboardScreen(),
      binding: DashboardBinding(),
    ),
    GetPage(
      name: Routes.CREATE_CONTRACT,
      page: () => const CreateContractScreen(),
      binding: CreateContractBinding(),
    ),
    GetPage(
      name: Routes.QR_GENERATE,
      page: () => const QrGenerateScreen(),
      binding: QrGenerateBinding(),
    ),
    GetPage(
      name: Routes.QR_SCAN,
      page: () => const QrScanScreen(),
      binding: QrScanBinding(),
    ),
     GetPage(
      name: Routes.INVENTORY_MAP,
      page: () => const InventoryMapScreen(),
    ),
  ];
}
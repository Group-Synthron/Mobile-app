import 'package:get/get.dart';
import 'package:trace2trade/screens/bluetooth/bluetooth_screen.dart';
import 'package:trace2trade/screens/create_contract/create_contract_screen.dart';
import 'package:trace2trade/screens/dashboard/dashboard_screen.dart';
import 'package:trace2trade/screens/login/login_screen.dart';
import 'package:trace2trade/screens/welcome/welcome_screen.dart';
import 'package:trace2trade/screens/welcome/welcome_binding.dart';

// Import the route names
import './routes/app_routes.dart';

class AppPages {
  // This is the first route that will be shown when the app starts.
  static const INITIAL = Routes.WELCOME;

  // This is the list of all pages/routes used by GetMaterialApp.
  static final routes = [
    GetPage(
      name: Routes.WELCOME,
      page: () => const WelcomeScreen(),
      binding: WelcomeBinding(), // Manages the WelcomeController's lifecycle
    ),
    GetPage(
      name: Routes.LOGIN,
      page: () => const LoginScreen(),
      // It's recommended to create a LoginBinding for the LoginScreen as well
      // binding: LoginBinding(),
    ),
    GetPage(
      name: Routes.DASHBOARD,
      page: () => const DashboardScreen(),
      // binding: DashboardBinding(), 
    ),
    GetPage(
      name: Routes.BLUETOOTH,
      page: () => const BluetoothScreen(),
      // binding: BluetoothBinding(),
    ),
    GetPage(
      name: Routes.CREATE_CONTRACT,
      page: () => const CreateContractScreen(),
      // binding: CreateContractBinding(),
    ),
  ];
}
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trace2trade/constants/colors.dart';
import 'package:trace2trade/routes/app_pages.dart';
import 'package:trace2trade/routes/app_routes.dart';
import 'package:trace2trade/permission_handler/PermissionsWrapper.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    await Firebase.initializeApp();
    print("Firebase initialized successfully");
  } catch (e) {
    print("Firebase initialization error: $e");
  }
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return PermissionsWrapper(
      child: GetMaterialApp(
        title: 'Trace2Trade',
        initialRoute: Routes.WELCOME,
        getPages: AppPages.routes,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: AppColors.darkBg,
          primaryColor: AppColors.primary,
          colorScheme: ColorScheme.fromSeed(
            seedColor: AppColors.primary,
            brightness: Brightness.dark,
          ),
          appBarTheme: AppBarTheme(
            backgroundColor: AppColors.primaryGreen,
            elevation: 0,
            titleTextStyle: const TextStyle(
              color: AppColors.textLight,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
            iconTheme: const IconThemeData(color: AppColors.textLight),
          ),
          useMaterial3: true,
        ),
      ),
    );
  }
}
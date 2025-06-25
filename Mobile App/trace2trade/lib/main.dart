import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trace2trade/app.dart';
import 'package:trace2trade/routes/app_routes.dart';
import 'package:trace2trade/constants/colors.dart';

void main() async {
  // Ensure that Flutter bindings are initialized before running the app.
  WidgetsFlutterBinding.ensureInitialized();
  
  // If you were using Firebase, you would initialize it here.
  // await Firebase.initializeApp();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Fish Inventory Tracker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // Setting a consistent theme based on your color palette
        scaffoldBackgroundColor: AppColors.darkBg,
        primaryColor: AppColors.primaryGreen,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.primaryGreen,
          elevation: 0,
          titleTextStyle: TextStyle(
            color: AppColors.textLight,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
          iconTheme: IconThemeData(color: AppColors.textLight),
        ),
      ),
      // The first route to be displayed when the app starts
      initialRoute: AppPages.INITIAL,
      // The list of all pages and their bindings for navigation
      getPages: AppPages.routes,
    );
  }
}
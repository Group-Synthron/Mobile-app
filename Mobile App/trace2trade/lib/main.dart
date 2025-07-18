import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trace2trade/constants/colors.dart';
import 'package:trace2trade/routes/app_pages.dart';
import 'package:trace2trade/routes/app_routes.dart';

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
      title: 'Trace2Trade',
      initialRoute: Routes.WELCOME, // Start with welcome screen
      getPages: AppPages.routes,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // Setting a consistent theme based on your color palette
        scaffoldBackgroundColor: AppColors.darkBg,
        primaryColor: const Color.fromARGB(255, 81, 95, 221),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color.fromARGB(255, 34, 57, 190),
          elevation: 0,
          titleTextStyle: TextStyle(
            color: Color.fromARGB(255, 84, 119, 236),
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
          iconTheme: IconThemeData(color: AppColors.textLight),
        ),
      ),
    );
  }
}
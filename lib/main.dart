import 'package:blacklist/controllers/auth_controller.dart';
import 'package:blacklist/controllers/employee_controller.dart';
import 'package:blacklist/core/theme/theme_controller.dart';
import 'package:blacklist/screens/emploees_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('settings');

  // Initialize controllers
  Get.put(ThemeController());
  Get.put(AuthController());
  Get.put(EmployeeController());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find();

    return Obx(() {
      return GetMaterialApp(
        title: 'BlackList',
        theme: themeController.themeData.value,
        debugShowCheckedModeBanner: false,
        home: const EmployeesScreen(),
      );
    });
  }
}

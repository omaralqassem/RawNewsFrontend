import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:rawnes/core/theme/app_theme.dart';
import 'package:rawnes/core/theme/initial_binding.dart';
import 'package:rawnes/routes/app_pages.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'RawNews',
      debugShowCheckedModeBanner: false,

      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,

      initialBinding: InitialBinding(),

      initialRoute: AppPages.HOME,
      getPages: AppPages.routes,
    );
  }
}

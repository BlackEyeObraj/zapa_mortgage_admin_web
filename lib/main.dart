import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:zapa_mortgage_admin_web/res/app_colors.dart';
import 'package:zapa_mortgage_admin_web/utils/routes/route_inits.dart';
import 'package:zapa_mortgage_admin_web/utils/routes/route_name.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
  );
  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Zapa Mortgage Admin',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primaryColor),
        useMaterial3: false,
      ),
      initialRoute: RouteName.signIn,
      getPages: RouteInits.appRoutes(),
    );
  }
}



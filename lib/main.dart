import 'package:cocktail/data/data.dart';
import 'package:cocktail/pages/home.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sizer/sizer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final controller = Get.put(DataLocal());

  // Init data
  await GetStorage.init();
  controller.localDataRead();

  // MAIN
  runApp(GetBuilder<DataLocal>(
    builder: (_) => Sizer(
        builder: (context, _, __) => MaterialApp(
              home: Home(),
              debugShowCheckedModeBanner: false,
              debugShowMaterialGrid: false,
              theme: controller.darkMode.value
                  ? ThemeData.dark()
                  : ThemeData.light(),
            )),
  ));
}

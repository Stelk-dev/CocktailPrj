import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class DataLocal extends GetxController {
  var darkMode = false.obs;
  var cocktailsSaved = [].obs;

  void changeDarkMode(dynamic newValue) {
    darkMode = (!darkMode.value).obs;
    update();

    localDataWrite(newValue);
  }

  void localDataWrite(var newValue) {
    GetStorage().write("LOCALDATA", newValue);
    print(GetStorage().read("LOCALDATA"));
  }

  void localDataRead() {
    if (GetStorage().read("LOCALDATA") == null)
      GetStorage()
          .write("LOCALDATA", {'darkMode': false, 'cocktailsSaved': []});
    print(GetStorage().read("LOCALDATA"));
    initData();
  }

  void initData() {
    if (GetStorage().read("LOCALDATA")['darkMode'])
      darkMode = true.obs;
    else
      darkMode = false.obs;

    for (var i in GetStorage().read("LOCALDATA")['cocktailsSaved'])
      cocktailsSaved.add(i);

    update();
  }
}

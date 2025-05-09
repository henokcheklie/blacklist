import 'package:blacklist/core/theme/theme_data.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

class ThemeController extends GetxController {
  var themeData = lightMode.obs;

  bool get isDarkMode => themeData.value == darkMode;

  @override
  void onInit() {
    super.onInit();
    _loadTheme();
  }

  void toggleTheme() {
    themeData.value = isDarkMode ? lightMode : darkMode;
    _saveTheme();
  }

  void _loadTheme() {
    final box = Hive.box('settings');
    final savedTheme = box.get('theme', defaultValue: 'light');
    themeData.value = savedTheme == 'dark' ? darkMode : lightMode;
  }

  void _saveTheme() {
    final box = Hive.box('settings');
    box.put('theme', isDarkMode ? 'dark' : 'light');
  }
}

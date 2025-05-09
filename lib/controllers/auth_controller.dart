import 'package:get/get.dart';

class AuthController extends GetxController {
  var isLoggedIn = false.obs;
  var user = Rx<Map<String, dynamic>>({});

  // TODO: Add authentication methods here
  void login(String username, String password) {
    // Implement login logic
    isLoggedIn.value = true;
    user.value = {'username': username};
  }

  void logout() {
    isLoggedIn.value = false;
    user.value = {};
  }
}

import 'dart:async';
import 'package:get/get.dart';
import 'package:blacklist/services/api_services.dart';

class EmployeeController extends GetxController {
  var isLoading = false.obs;
  var employeesList = Rx<List<dynamic>>([]);
  var searchField = 'fullNameEnglish'.obs;
  var searchQuery = ''.obs;
  late Timer timer;

  @override
  void onInit() {
    super.onInit();
    getEmployeesList();
    timer = Timer.periodic(const Duration(seconds: 10), (t) {
      getEmployeesList();
    });
  }

  @override
  void onClose() {
    timer.cancel();
    super.onClose();
  }

  void getEmployeesList({bool isUserSearched = false}) async {
    if (isUserSearched) {
      isLoading.value = true;
    }

    try {
      var responseData = await APIService.getEmployeesList();
      if (responseData != null) {
        employeesList.value = responseData;
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Please check your internet connection",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
      );
    } finally {
      if (isUserSearched) {
        isLoading.value = false;
      }
    }
  }

  List<dynamic> get filteredEmployees {
    if (employeesList.value.isEmpty) return [];

    if (searchQuery.value.isEmpty) return employeesList.value;

    final query = searchQuery.value.toLowerCase();

    return employeesList.value.where((employee) {
      final value =
          (searchField.value.contains('.')
                  ? deepLookup(employee, searchField.value)
                  : employee[searchField.value])
              ?.toString()
              .toLowerCase() ??
          '';
      return value.contains(query);
    }).toList();
  }

  dynamic deepLookup(Map obj, String path) {
    final keys = path.split('.');
    dynamic value = obj;
    for (final key in keys) {
      if (value is Map && value.containsKey(key)) {
        value = value[key];
      } else {
        return null;
      }
    }
    return value;
  }

  void setSearchField(String field) {
    searchField.value = field;
  }

  void setSearchQuery(String query) {
    searchQuery.value = query;
  }
}

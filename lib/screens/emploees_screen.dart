import 'package:blacklist/core/theme/theme_controller.dart';
import 'package:blacklist/widgets/custom_search_bar.dart';
import 'package:blacklist/widgets/custom_switch_tile.dart';
import 'package:blacklist/widgets/info_row.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:blacklist/services/services.dart';
import 'package:blacklist/core/constants.dart';
import 'package:blacklist/controllers/employee_controller.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class EmployeesScreen extends StatelessWidget {
  const EmployeesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find();
    final controller = Get.find<EmployeeController>();
    final searchController = TextEditingController();

    // listener to update the search query in the controller
    searchController.addListener(() {
      controller.setSearchQuery(searchController.text);
    });

    return Scaffold(
      body: Obx(
        () => GestureDetector(
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
          },

          child: ModalProgressHUD(
            color: Theme.of(context).colorScheme.inversePrimary,
            inAsyncCall: controller.isLoading.value,
            progressIndicator: Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(kDefaultPadding),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              Service.getGreeting(),
                              style: TextStyle(
                                fontSize: 22,
                                color:
                                    Theme.of(
                                      context,
                                    ).colorScheme.inversePrimary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              "Simplify Your Day.",
                              style: TextStyle(
                                fontSize: 14,
                                color:
                                    Theme.of(
                                      context,
                                    ).colorScheme.inversePrimary,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                        Expanded(
                          child: Obx(
                            () => CustomSwitchTile(
                              title: "Dark Mode",
                              value: themeController.isDarkMode,
                              onChanged:
                                  (value) => themeController.toggleTheme(),
                              margin: kDefaultPadding,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(kDefaultPadding),
                    child: CustomSearchBar(
                      controller: searchController,
                      onChanged: (value) => controller.setSearchQuery(value),
                      trailing: [
                        PopupMenuButton<String>(
                          icon: const Icon(Icons.tune),
                          color: Theme.of(context).colorScheme.secondary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              kDefaultPadding,
                            ),
                          ),
                          onSelected: (value) {
                            controller.setSearchField(value);
                          },
                          itemBuilder:
                              (context) => [
                                const PopupMenuItem(
                                  value: 'fullNameEnglish',
                                  child: Text('Search by Name'),
                                ),
                                const PopupMenuItem(
                                  value: 'idNo',
                                  child: Text('Search by ID Number'),
                                ),
                                const PopupMenuItem(
                                  value: 'position.name',
                                  child: Text('Search by Position'),
                                ),
                              ],
                        ),
                        IconButton(
                          icon: const Icon(Icons.search),
                          onPressed: () {
                            // Refresh is automatic with GetX
                          },
                        ),
                        if (searchController.text.isNotEmpty)
                          IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              searchController.clear();
                              controller.setSearchQuery('');
                            },
                          ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Obx(() {
                      final employees = controller.filteredEmployees;

                      if (controller.employeesList.value.isEmpty) {
                        return Center(
                          child: CircularProgressIndicator(
                            color: Theme.of(context).colorScheme.inversePrimary,
                          ),
                        );
                      }

                      return ListView.builder(
                        itemCount: employees.length,
                        itemBuilder: (context, index) {
                          final employee =
                              employees[index] as Map<String, dynamic>;

                          final fullNameEnglish =
                              employee['fullNameEnglish'] ?? 'Unknown';
                          final fullNameAmharic =
                              employee['fullNameAmharic'] ?? 'Unknown';
                          final idNo = employee['idNo'] ?? 'N/A';
                          final position =
                              employee['position'] as Map<String, dynamic>?;
                          final positionName = position?['name'] ?? 'Unknown';
                          final status = employee['status'] ?? 'Unknown';

                          return Card(
                            color: Theme.of(context).colorScheme.secondary,
                            margin: const EdgeInsets.symmetric(
                              horizontal: kDefaultPadding,
                              vertical: kDefaultPadding / 4,
                            ),
                            child: ListTile(
                              onTap:
                                  () => _showEmployeeDetailDialog(
                                    context,
                                    employee,
                                  ),
                              leading: Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Service.getStatusColor(status),
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    Service.getInitials(fullNameEnglish),
                                    style: TextStyle(
                                      color:
                                          Theme.of(context).colorScheme.shadow,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              title: Text(
                                Service.capitalizeFirstLetters(fullNameEnglish),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (fullNameEnglish != fullNameAmharic)
                                    Text(
                                      Service.capitalizeFirstLetters(
                                        fullNameAmharic,
                                      ),
                                    ),
                                  Text('ID: $idNo'),
                                  Text('Position: $positionName'),
                                ],
                              ),
                              trailing: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Service.getStatusColor(status),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  status,
                                  style: TextStyle(
                                    color: Theme.of(context).colorScheme.shadow,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    }),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showEmployeeDetailDialog(
    BuildContext context,
    Map<String, dynamic> employee,
  ) {
    final position = employee['position'] as Map<String, dynamic>?;

    Get.dialog(
      barrierDismissible: true,
      Dialog(
        alignment: Alignment.center,
        insetPadding: EdgeInsets.all(kDefaultPadding * 2),
        backgroundColor: Theme.of(context).colorScheme.secondary,
        child: Padding(
          padding: EdgeInsets.all(kDefaultPadding),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Column(
                  spacing: kDefaultPadding / 4,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Theme.of(context).colorScheme.surface,
                          width: 1.0,
                        ),
                      ),
                      child: CircleAvatar(
                        radius: 25,
                        backgroundColor: Theme.of(context).colorScheme.shadow,
                        backgroundImage: AssetImage('assets/person.png'),
                      ),
                    ),
                    Text(
                      Service.capitalizeFirstLetters(
                        employee['fullNameEnglish'],
                      ),
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              ),
              SizedBox(height: kDefaultPadding),
              if (employee['fullNameEnglish'] != employee['fullNameAmharic'])
                InfoRow(
                  label: '👤 Name (Amharic)',
                  value: Service.capitalizeFirstLetters(
                    employee['fullNameAmharic'],
                  ),
                ),
              if (employee['fullNameEnglish'] != employee['fullNameAmharic'])
                const Divider(),

              InfoRow(label: '🆔 ID Number', value: employee['idNo'] ?? 'N/A'),
              InfoRow(
                label: '📅 Date of Birth',
                value: Service.formatDate(employee['dateOfBirth']),
              ),
              InfoRow(label: '⚧ Gender', value: employee['gender'] ?? 'N/A'),
              InfoRow(
                label: '🌍 Nationality',
                value: employee['nationality'] ?? 'N/A',
              ),
              const Divider(),
              InfoRow(
                label: '📅 Start Date',
                value: Service.formatDate(employee['startDate']),
              ),
              InfoRow(label: '🚦 Status', value: employee['status'] ?? 'N/A'),
              const Divider(),
              InfoRow(label: '💼 Position', value: position?['name'] ?? 'N/A'),
              InfoRow(
                label: '🏢 Department ID',
                value: position?['departmentId'] ?? 'N/A',
              ),
              const Divider(),
              InfoRow(
                label: '📝 Created At',
                value: Service.formatDate(employee['createdAt']),
              ),
              InfoRow(
                label: '🔄 Updated At',
                value: Service.formatDate(employee['updatedAt']),
              ),

              // Dialog actions
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  child: Text(
                    'Close',
                    style: TextStyle(
                      color: Get.theme.colorScheme.inversePrimary,
                    ),
                  ),
                  onPressed: () => Get.back(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

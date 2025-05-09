import 'package:flutter/material.dart';

class Service {
  static String getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning ☀️';
    if (hour < 18) return 'Good Afternoon 🌤️';
    return 'Good Evening 🌙';
  }

  static String formatDate(dynamic dateString) {
    if (dateString == null) return 'N/A';
    try {
      final date = DateTime.parse(dateString.toString());
      return '${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}';
    } catch (e) {
      return dateString.toString();
    }
  }

  static String getInitials(String fullName) {
    if (fullName.isEmpty) return '';

    List<String> nameParts = fullName.split(' ');
    if (nameParts.length > 1) {
      return '${nameParts[0][0]}${nameParts[1][0]}'.toUpperCase();
    } else if (nameParts.length == 1) {
      return nameParts[0][0].toUpperCase();
    }
    return '';
  }

  static Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return Colors.green;
      case 'inactive':
        return Colors.red;
      case 'suspended':
        return Colors.orange;
      case 'pending':
        return Colors.blue;
      default:
        return Colors.green;
    }
  }

  static String capitalizeFirstLetters(String input) {
    input = input.toLowerCase();
    if (input.contains('[') && input.contains(']')) {
      input = input.replaceAll('[', '').replaceAll(']', '');
    }
    //// Split by commas, preserving spaces within each part
    List<String> parts = input.split(',');

    // Capitalize each part and preserve commas and spaces
    String result = parts
        .map((part) {
          List<String> words = part.trim().split(RegExp(r'\s+'));
          return words
              .map(
                (word) =>
                    word.trim().isEmpty
                        ? word.trim()
                        : word.trim().substring(0, 1).toUpperCase() +
                            word.trim().substring(1),
              )
              .join(' ');
        })
        .join(', ');

    // Remove any duplicated values
    result = result.trim().replaceAll(RegExp(r'\s*,+\s*'), ', ');
    List<String> capitalizedWords = result.split(',');
    Set<String> uniqueWords = {};
    for (var word in capitalizedWords) {
      uniqueWords.add(word.trim());
    }
    return uniqueWords.join(', ');
  }
}

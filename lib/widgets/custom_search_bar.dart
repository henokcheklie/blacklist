import 'package:blacklist/core/constants.dart';
import 'package:flutter/material.dart';

class CustomSearchBar extends StatelessWidget {
  final TextEditingController? controller;
  final void Function(String)? onChanged;
  final Iterable<Widget>? trailing;
  final String? hintText;
  const CustomSearchBar({
    super.key,
    this.controller,
    this.onChanged,
    this.trailing,
    this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return SearchBar(
      hintText: hintText ?? "Search...",
      controller: controller,
      onChanged: onChanged,
      trailing: trailing,
      elevation: WidgetStateProperty.all(2),
      textStyle: WidgetStateProperty.all<TextStyle>(
        TextStyle(color: Theme.of(context).colorScheme.inversePrimary),
      ),
      hintStyle: WidgetStateProperty.all<TextStyle>(
        TextStyle(color: Theme.of(context).colorScheme.inversePrimary),
      ),
      backgroundColor: WidgetStateProperty.all(
        Theme.of(context).colorScheme.secondary,
      ),
      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(kDefaultPadding),
        ),
      ),
    );
  }
}

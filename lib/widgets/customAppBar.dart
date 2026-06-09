import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget title;
  final Color? backgroundColor;

  const CustomAppBar({
    Key? key,
    required this.title,
    this.backgroundColor,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: title,
      backgroundColor: backgroundColor,
    );
  }
}

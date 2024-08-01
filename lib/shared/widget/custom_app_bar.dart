import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Color? backgroundColor;
  final double elevation;
  final double borderRadius;
  Widget? widget;

  CustomAppBar({
    super.key,
    required this.title,
    this.backgroundColor,
    this.elevation = 2,
    this.borderRadius = 24,
    this.widget,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: elevation,
      backgroundColor: backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(borderRadius),
          bottomRight: Radius.circular(borderRadius),
        ),
      ),
      title: Text(
        title,
      ),
      actions: [widget ?? const SizedBox()],
    );
  }
}

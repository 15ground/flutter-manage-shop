import 'package:flutter/material.dart';

class BaseAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Text title;
  final AppBar appBar;
  final List<Widget> widgets;
  BaseAppBar(
      {required this.appBar, required this.title, required this.widgets});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: title,
      actions: widgets,
    );
  }

  @override
  Size get preferredSize => new Size.fromHeight(appBar.preferredSize.height);
}

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class NavBtn extends StatelessWidget {
  final IconData icon;
  final bool sel;
  const NavBtn({super.key, required this.icon, required this.sel});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Icon(
            icon,
            size: 30,
            color: sel
                ? CupertinoTheme.of(context).primaryColor
                : Color(0xFF999999),
          )
        ],
      ),
    );
  }
}

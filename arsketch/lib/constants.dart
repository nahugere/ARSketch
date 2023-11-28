import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

const kTheme2 = CupertinoThemeData(
    brightness: Brightness.dark,
    primaryColor: Color(0xFFAE37AE),
    primaryContrastingColor: Color(0xFF5F257E),
    scaffoldBackgroundColor: Color(0xFF131421),
    barBackgroundColor: Color(0xFF20213F));

const kSecondaryScaffoldBackground = Color(0xFF20213F);
const kDebugHost = "YOUR IP ADDRESS";
const kLocalHost = "http://127.0.0.1:8000/";
const kHost = kDebugHost;

class CustomButton extends StatelessWidget {
  final IconData icon;
  final String text;
  final Function action;
  final bool iconFirst;
  final bool fullWidth;
  const CustomButton(
      {Key? key,
      required this.icon,
      required this.iconFirst,
      required this.text,
      required this.fullWidth,
      required this.action})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        action();
      },
      child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.only(
              left: iconFirst ? 0 : 20, right: iconFirst ? 10 : 0),
          height: 46,
          width: fullWidth ? MediaQuery.of(context).size.width - 40 : 130,
          decoration: BoxDecoration(
              color: kTheme2.primaryColor,
              borderRadius: BorderRadius.all(Radius.circular(9))),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (iconFirst) Icon(icon),
              if (!iconFirst) Text(text),
              const SizedBox(
                width: 5,
              ),
              if (!iconFirst) Icon(icon),
              if (iconFirst) Text(text),
            ],
          )),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:schoolar/config/config.dart';

AppBar header(contex,
    {bool isAppTitle, String strTitle, disappearedBackButton = false}) {
  return AppBar(
    iconTheme: IconThemeData(
      color: secondaryColor,
    ),
    elevation: 0,
    automaticallyImplyLeading: disappearedBackButton ? false : true,
    title: Text(
      isAppTitle ? "SCHOOLAR" : strTitle,
      style: TextStyle(
        color: Colors.pink,
      ),
      overflow: TextOverflow.ellipsis,
    ),
    centerTitle: true,
    backgroundColor: primaryColor,
  );
}

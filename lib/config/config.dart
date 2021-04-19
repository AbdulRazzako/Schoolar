import 'package:flutter/material.dart';

final Color primaryColor = Colors.white;
final Color secondaryColor = Color(0xFFFF7A86);
final Color secondaryDarkColor = Color(0xFF4491DE);

Container button(BuildContext context, title) {
  return Container(
    height: 50,
    width: MediaQuery.of(context).size.width - 180,
    child: Center(
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 16, color: Colors.white),
      ),
    ),
    decoration: BoxDecoration(
      color: Colors.blue,
      borderRadius: BorderRadius.circular(22),
    ),
  );
}

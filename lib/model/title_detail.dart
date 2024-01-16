import 'package:flutter/material.dart';

class TileDetails {
  const TileDetails(
      {required this.title, required this.icon, required this.navigationPage});
  final String title;
  final IconData icon;
  final Widget navigationPage;
}

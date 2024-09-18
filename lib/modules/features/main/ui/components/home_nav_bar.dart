import 'package:flutter/material.dart';
import 'package:guest_allow/configs/themes/main_color.dart';

class HomeNavbar extends StatelessWidget {
  const HomeNavbar({
    super.key,
    required this.destination,
    required this.currentIndex,
    required this.onTap,
  });

  final List<BottomNavigationBarItem> destination;
  final int currentIndex;
  final Function(int) onTap;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      elevation: 0,
      currentIndex: currentIndex,
      backgroundColor: Colors.white,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: MainColor.primaryDarker,
      items: destination,
      onTap: onTap,
    );
  }
}

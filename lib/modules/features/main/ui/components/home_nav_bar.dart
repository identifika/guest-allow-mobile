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

    // return BottomAppBar(
    //   color: Colors.white,
    //   height: 70,
    //   shape: const CircularNotchedRectangle(),
    //   child: Row(
    //     mainAxisAlignment: MainAxisAlignment.spaceAround,
    //     children: destination.map((item) {
    //       var index = destination.indexOf(item);
    //       return InkWell(
    //         onTap: () {
    //           onTap(index);
    //         },
    //         child: Container(
    //           padding: const EdgeInsets.symmetric(vertical: 8),
    //           child: Column(
    //             mainAxisSize: MainAxisSize.min,
    //             children: [
    //               item.icon,
    //             ],
    //           ),
    //         ),
    //       );
    //     }).toList(),
    //   ),
    // );
  }
}

// import 'package:flutter/material.dart';
// import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
// import 'package:guest_allow/configs/themes/main_color.dart';

// class CustomFloatingActionButton extends StatefulWidget {
//   const CustomFloatingActionButton({super.key});

//   @override
//   State<CustomFloatingActionButton> createState() =>
//       _CustomFloatingActionButtonState();
// }

// class _CustomFloatingActionButtonState
//     extends State<CustomFloatingActionButton> {
//   bool isExpand = false;

//   void _toggleExpand() {
//     setState(() {
//       isExpand = !isExpand;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return FloatingActionButton(
//       onPressed: () {
//         _toggleExpand();
//       },
//       backgroundColor: MainColor.primary,
//       clipBehavior: Clip.antiAlias,
//       child: Stack(
//         children: [
//           ExpandableFab(
//             openButtonBuilder: RotateFloatingActionButtonBuilder(
//               backgroundColor: MainColor.primary,
//               foregroundColor: Colors.white,
//               child: const Icon(Icons.add),
//             ),
//             closeButtonBuilder: RotateFloatingActionButtonBuilder(
//               backgroundColor: MainColor.primary,
//               foregroundColor: Colors.white,
//               child: const Icon(Icons.close),
//             ),
//             children: [
//               FloatingActionButton(
//                 onPressed: () {
//                   // Get.toNamed(MainRoute.createEvent);
//                 },
//                 backgroundColor: MainColor.primary,
//                 child: const Icon(Icons.add),
//               ),
//               FloatingActionButton(
//                 onPressed: () {
//                   // Get.toNamed(MainRoute.createEvent);
//                 },
//                 backgroundColor: MainColor.primary,
//                 child: const Icon(Icons.add),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:guest_allow/configs/themes/main_color.dart';

// https://stackoverflow.com/questions/46480221/flutter-floating-action-button-with-speed-dail
class CustomFloatingActionButton extends StatefulWidget {
  const CustomFloatingActionButton(
      {required this.icons, required this.onIconTapped, super.key});
  final List<IconData> icons;
  final ValueChanged<int> onIconTapped;
  @override
  State createState() => FabWithIconsState();
}

class FabWithIconsState extends State<CustomFloatingActionButton>
    with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: List.generate(widget.icons.length, (int index) {
        return _buildChild(index);
      }).toList()
        ..add(
          _buildFab(),
        ),
    );
  }

  Widget _buildChild(int index) {
    Color backgroundColor = MainColor.primary;
    Color foregroundColor = Colors.white;
    return Container(
      height: 70.0,
      width: 56.0,
      alignment: FractionalOffset.topCenter,
      child: ScaleTransition(
        scale: CurvedAnimation(
          parent: _controller,
          curve: Interval(0.0, 1.0 - index / widget.icons.length / 2.0,
              curve: Curves.easeOut),
        ),
        child: FloatingActionButton(
          backgroundColor: backgroundColor,
          mini: true,
          child: Icon(widget.icons[index], color: foregroundColor),
          onPressed: () => _onTapped(index),
        ),
      ),
    );
  }

  Widget _buildFab() {
    return FloatingActionButton(
      onPressed: () {
        if (_controller.isDismissed) {
          _controller.forward();
        } else {
          _controller.reverse();
        }
      },
      tooltip: 'Increment',
      elevation: 2.0,
      child: const Icon(Icons.add),
    );
  }

  void _onTapped(int index) {
    _controller.reverse();
    widget.onIconTapped(index);
  }
}

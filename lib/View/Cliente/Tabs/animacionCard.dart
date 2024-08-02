import 'package:flutter/material.dart';

class AnimarTabTodos extends StatelessWidget {
  final bool isFlipped;
  final Widget frontWidget;
  final Widget backWidget;
  final VoidCallback onFlip;

  const AnimarTabTodos({
    Key? key,
    required this.isFlipped,
    required this.frontWidget,
    required this.backWidget,
    required this.onFlip,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onFlip,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        transform: Matrix4.rotationY(isFlipped ? 3.14159 : 0),
        transformAlignment: Alignment.center,
        child: isFlipped 
          ? Transform(
              transform: Matrix4.rotationY(3.14159),
              alignment: Alignment.center,
              child: backWidget,
            )
          : frontWidget,
      ),
    );
  }
}

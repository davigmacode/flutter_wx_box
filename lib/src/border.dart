import 'package:flutter/widgets.dart';

class WxBorder extends StatelessWidget {
  const WxBorder({
    super.key,
    this.textDirection,
    this.isForeground = true,
    required this.shape,
    this.child,
  });

  final TextDirection? textDirection;
  final bool isForeground;
  final OutlinedBorder shape;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final painter = WxBorderPainter(shape, textDirection);
    return CustomPaint(
      painter: isForeground ? null : painter,
      foregroundPainter: isForeground ? painter : null,
      child: child,
    );
  }
}

class WxBorderPainter extends CustomPainter {
  WxBorderPainter(
    this.shape,
    this.textDirection,
  );
  final OutlinedBorder shape;
  final TextDirection? textDirection;

  @override
  void paint(Canvas canvas, Size size) {
    shape.paint(
      canvas,
      Offset.zero & size,
      textDirection: textDirection,
    );
  }

  @override
  bool shouldRepaint(WxBorderPainter oldDelegate) {
    return oldDelegate.shape != shape;
  }
}

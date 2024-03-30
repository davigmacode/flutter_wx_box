import 'package:flutter/widgets.dart';

class WxBorder extends StatelessWidget {
  const WxBorder({
    super.key,
    this.textDirection,
    this.isForeground = true,
    this.inflate,
    required this.shape,
    this.child,
  });

  final TextDirection? textDirection;
  final bool isForeground;
  final double? inflate;
  final OutlinedBorder shape;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final painter = WxBorderPainter(shape, textDirection, inflate);
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
    this.inflate,
  );
  final OutlinedBorder shape;
  final TextDirection? textDirection;
  final double? inflate;

  double get defaultInflate => shape.side.width / 5;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    shape.paint(
      canvas,
      rect.inflate(inflate ?? defaultInflate),
      textDirection: textDirection,
    );
  }

  @override
  bool shouldRepaint(WxBorderPainter oldDelegate) {
    return oldDelegate.shape != shape;
  }
}

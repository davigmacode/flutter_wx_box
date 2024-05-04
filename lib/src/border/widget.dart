import 'package:flutter/material.dart';

class WxBorder extends StatelessWidget {
  const WxBorder({
    super.key,
    this.isBackground = false,
    this.clipBehavior = Clip.none,
    this.textDirection,
    required this.shape,
    this.child,
  });

  final bool isBackground;
  final Clip clipBehavior;
  final TextDirection? textDirection;
  final ShapeBorder shape;
  final Widget? child;

  bool get isForeground => !isBackground;

  @override
  Widget build(BuildContext context) {
    final effectiveTextDirection =
        textDirection ?? Directionality.maybeOf(context);
    final painter = WxBorderPainter(shape, effectiveTextDirection);
    return CustomPaint(
      painter: isBackground ? null : painter,
      foregroundPainter: isForeground ? painter : null,
      child: clipBehavior != Clip.none
          ? ClipPath(
              clipBehavior: clipBehavior,
              clipper: ShapeBorderClipper(
                shape: shape,
                textDirection: effectiveTextDirection,
              ),
              child: child,
            )
          : child,
    );
  }
}

class WxBorderPainter extends CustomPainter {
  WxBorderPainter(
    this.shape,
    this.textDirection,
  );
  final ShapeBorder shape;
  final TextDirection? textDirection;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    shape.paint(canvas, rect, textDirection: textDirection);
  }

  @override
  bool shouldRepaint(WxBorderPainter oldDelegate) {
    return oldDelegate.shape != shape;
  }
}

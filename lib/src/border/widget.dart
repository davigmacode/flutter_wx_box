import 'package:flutter/widgets.dart';
import 'shape/outlined.dart';
import 'clipper.dart';

enum WxBorderPosition {
  foreground,
  background;

  bool get isForeground => name == 'foreground';

  bool get isBackground => name == 'background';
}

class WxBorder extends StatelessWidget {
  const WxBorder({
    super.key,
    this.position = WxBorderPosition.foreground,
    this.clipBehavior = Clip.none,
    this.textDirection,
    required this.shape,
    this.child,
  });

  final WxBorderPosition position;
  final Clip clipBehavior;
  final TextDirection? textDirection;
  final WxOutlinedBorder shape;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final effectiveTextDirection =
        textDirection ?? Directionality.maybeOf(context);
    final painter = WxBorderPainter(shape, effectiveTextDirection);
    return CustomPaint(
      painter: position.isBackground ? null : painter,
      foregroundPainter: position.isForeground ? painter : null,
      child: clipBehavior != Clip.none
          ? ClipPath(
              clipBehavior: clipBehavior,
              clipper: WxShapeBorderClipper(
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
  final WxOutlinedBorder shape;
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

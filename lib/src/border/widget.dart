import 'package:flutter/material.dart';

/// A customizable border widget for Flutter that supports both background and foreground decoration.
///
/// This widget allows you to draw a border around its child widget, optionally filling the background
/// or outlining the foreground. You can configure the shape of the border using a `ShapeBorder` object,
/// and optionally specify the clipping behavior for the child content.
///
/// By default, the border is drawn in the foreground. Set the `isBackground` property to `true` to
/// fill the background area instead.
class WxBorder extends StatelessWidget {
  /// Creates a new [WxBorder] widget.
  ///
  /// [shape] is required.
  const WxBorder({
    super.key,
    this.isBackground = false,
    this.clipBehavior = Clip.none,
    this.textDirection,
    required this.shape,
    this.child,
  });

  /// Whether to draw the border in the background or foreground. Defaults to `false` (foreground).
  final bool isBackground;

  /// The clip behavior to apply to the child widget. Defaults to `Clip.none`.
  final Clip clipBehavior;

  /// The text direction to use for drawing the border.
  final TextDirection? textDirection;

  /// The shape of the border to draw. This is required.
  final ShapeBorder shape;

  /// The child widget to be placed inside the border.
  final Widget? child;

  /// Whether the border is drawn in the foreground. This is a getter for convenience.
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

/// A custom painter class that draws a border based on a provided `ShapeBorder` object.
///
/// This class is used internally by the [WxBorder] widget. It takes a `ShapeBorder` and an optional
/// `textDirection` as parameters, and draws the border shape on the canvas.
class WxBorderPainter extends CustomPainter {
  /// Creates a new [WxBorderPainter] instance.
  ///
  /// [shape] is required.
  WxBorderPainter(
    this.shape,
    this.textDirection,
  );

  /// The shape of the border to draw. This is required.
  final ShapeBorder shape;

  /// The text direction to use for drawing the border.
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

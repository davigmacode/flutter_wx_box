import 'package:flutter/rendering.dart';
import 'shape/basic.dart';

/// A [CustomClipper] that clips to the outer path of a [WxShapeBorder].
class WxShapeBorderClipper extends CustomClipper<Path> {
  /// Creates a [WxShapeBorder] clipper.
  ///
  /// The [shape] argument must not be null.
  ///
  /// The [textDirection] argument must be provided non-null if [shape]
  /// has a text direction dependency (for example if it is expressed in terms
  /// of "start" and "end" instead of "left" and "right"). It may be null if
  /// the border will not need the text direction to paint itself.
  const WxShapeBorderClipper({
    required this.shape,
    this.textDirection,
  });

  /// The shape border whose outer path this clipper clips to.
  final WxShapeBorder shape;

  /// The text direction to use for getting the outer path for [shape].
  ///
  /// [WxShapeBorder]s can depend on the text direction (e.g having a "dent"
  /// towards the start of the shape).
  final TextDirection? textDirection;

  /// Returns the outer path of [shape] as the clip.
  @override
  Path getClip(Size size) {
    return shape.getOuterPath(Offset.zero & size, textDirection: textDirection);
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    if (oldClipper.runtimeType != WxShapeBorderClipper) {
      return true;
    }
    final WxShapeBorderClipper typedOldClipper =
        oldClipper as WxShapeBorderClipper;
    return typedOldClipper.shape != shape ||
        typedOldClipper.textDirection != textDirection;
  }
}

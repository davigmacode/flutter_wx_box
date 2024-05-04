import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';

import 'outlined.dart';
import '../side.dart';
import '../style.dart';

/// A rectangular border with rounded corners.
///
/// This shape can interpolate to and from [CircleBorder].
///
/// See also:
///
///  * [WxBorderSide], which is used to describe each side of the box.
///  * [Border], which, when used with [BoxDecoration], can also
///    describe a rounded rectangle.
class WxRoundedRectangleBorder extends WxOutlinedBorder {
  /// Creates a rounded rectangle border.
  ///
  /// The arguments must not be null.
  const WxRoundedRectangleBorder({
    super.side,
    super.color,
    super.gradient,
    super.offset,
    super.style,
    super.width,
    this.corners = BorderRadius.zero,
  });

  /// The radii for each corner.
  final BorderRadiusGeometry corners;

  @override
  ShapeBorder scale(double t) {
    return copyWith(
      side: effectiveSide.scale(t),
      corners: corners * t,
    );
  }

  /// Returns a copy of this WxRoundedRectangleBorder with the given fields
  /// replaced with the new values.
  @override
  WxRoundedRectangleBorder copyWith({
    WxBorderSide? side,
    WxBorderStyle? style,
    Color? color,
    Gradient? gradient,
    double? width,
    double? offset,
    BorderRadiusGeometry? corners,
  }) {
    return WxRoundedRectangleBorder(
      side: side ?? this.side,
      style: style ?? this.style,
      color: color ?? this.color,
      gradient: gradient ?? this.gradient,
      width: width ?? this.width,
      offset: offset ?? this.offset,
      corners: corners ?? this.corners,
    );
  }

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    final RRect borderRect = corners.resolve(textDirection).toRRect(rect);
    final RRect adjustedRect = borderRect.deflate(effectiveSide.strokeInset);
    return Path()..addRRect(adjustedRect);
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    return Path()..addRRect(corners.resolve(textDirection).toRRect(rect));
  }

  @override
  void paintInterior(
    Canvas canvas,
    Rect rect,
    Paint paint, {
    TextDirection? textDirection,
  }) {
    if (corners == BorderRadius.zero) {
      canvas.drawRect(rect, paint);
    } else {
      canvas.drawRRect(corners.resolve(textDirection).toRRect(rect), paint);
    }
  }

  @override
  bool get preferPaintInterior => true;

  @override
  void paint(
    Canvas canvas,
    Rect rect, {
    TextDirection? textDirection,
  }) {
    final actualSide = effectiveSide;
    final sideWidth = actualSide.effectiveWidth;
    if (sideWidth == 0) return;

    final Paint paint = actualSide.toPaint(rect);
    final RRect borderRect = corners.resolve(textDirection).toRRect(rect);
    final RRect outer = borderRect.inflate(actualSide.strokeOutset);
    if (actualSide.effectiveStyle.isSolid) {
      final RRect inner = borderRect.deflate(actualSide.strokeInset);
      canvas.drawDRRect(outer, inner, paint);
    } else {
      final borderPath = getNonSolidPath(
        Path()..addRRect(outer),
        textDirection: textDirection,
      );
      canvas.drawPath(
        borderPath,
        paint
          ..strokeWidth = sideWidth
          ..style = PaintingStyle.stroke,
      );
    }
  }

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is WxRoundedRectangleBorder &&
        other.side == side &&
        other.style == style &&
        other.color == color &&
        other.gradient == gradient &&
        other.width == width &&
        other.offset == offset &&
        other.corners == corners;
  }

  @override
  int get hashCode =>
      Object.hash(side, style, color, gradient, width, offset, corners);

  @override
  String toString() {
    return '${objectRuntimeType(this, 'WxRoundedRectangleBorder')}($side, $corners)';
  }
}

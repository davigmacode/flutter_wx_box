import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';

import 'outlined.dart';
import 'rectangle.dart';
import 'circle.dart';
import 'stadium_lerp.dart';
import '../side.dart';
import '../style.dart';

/// A border that fits a stadium-shaped border (a box with semicircles on the ends)
/// within the rectangle of the widget it is applied to.
///
/// If the rectangle is taller than it is wide, then the semicircles will be on the
/// top and bottom, and on the left and right otherwise.
///
/// See also:
///
///  * [WxBorderSide], which is used to describe the border of the stadium.
class WxStadiumBorder extends WxOutlinedBorder {
  /// Create a stadium border.
  ///
  /// The [side] argument must not be null.
  const WxStadiumBorder({
    super.side,
    super.color,
    super.gradient,
    super.offset,
    super.style,
    super.width,
  });

  @override
  ShapeBorder scale(double t) => WxStadiumBorder(side: effectiveSide.scale(t));

  @override
  ShapeBorder? lerpFrom(ShapeBorder? a, double t) {
    if (a is WxStadiumBorder) {
      return WxStadiumBorder(
        side: WxBorderSide.lerp(a.effectiveSide, effectiveSide, t),
      );
    }
    if (a is WxCircleBorder) {
      return WxStadiumToCircleBorder(
        side: WxBorderSide.lerp(a.effectiveSide, effectiveSide, t),
        circularity: 1.0 - t,
        eccentricity: a.eccentricity,
      );
    }
    if (a is WxRectangleBorder) {
      return WxStadiumToRectangleBorder(
        side: WxBorderSide.lerp(a.effectiveSide, effectiveSide, t),
        corners: a.corners,
        rectilinearity: 1.0 - t,
      );
    }
    return super.lerpFrom(a, t);
  }

  @override
  ShapeBorder? lerpTo(ShapeBorder? b, double t) {
    if (b is WxStadiumBorder) {
      return WxStadiumBorder(
        side: WxBorderSide.lerp(effectiveSide, b.effectiveSide, t),
      );
    }
    if (b is WxCircleBorder) {
      return WxStadiumToCircleBorder(
        side: WxBorderSide.lerp(effectiveSide, b.effectiveSide, t),
        circularity: t,
        eccentricity: b.eccentricity,
      );
    }
    if (b is WxRectangleBorder) {
      return WxStadiumToRectangleBorder(
        side: WxBorderSide.lerp(effectiveSide, b.effectiveSide, t),
        corners: b.corners,
        rectilinearity: t,
      );
    }
    return super.lerpTo(b, t);
  }

  @override
  WxStadiumBorder copyWith({
    WxBorderSide? side,
    WxBorderStyle? style,
    Color? color,
    Gradient? gradient,
    double? width,
    double? offset,
    double? eccentricity,
  }) {
    return WxStadiumBorder(
      side: side ?? this.side,
      style: style ?? this.style,
      color: color ?? this.color,
      gradient: gradient ?? this.gradient,
      width: width ?? this.width,
      offset: offset ?? this.offset,
    );
  }

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    final Radius radius = Radius.circular(rect.shortestSide / 2.0);
    final RRect borderRect = RRect.fromRectAndRadius(rect, radius);
    final RRect adjustedRect = borderRect.deflate(effectiveSide.strokeInset);
    return Path()..addRRect(adjustedRect);
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    final Radius radius = Radius.circular(rect.shortestSide / 2.0);
    return Path()..addRRect(RRect.fromRectAndRadius(rect, radius));
  }

  @override
  void paintInterior(Canvas canvas, Rect rect, Paint paint,
      {TextDirection? textDirection}) {
    final Radius radius = Radius.circular(rect.shortestSide / 2.0);
    canvas.drawRRect(RRect.fromRectAndRadius(rect, radius), paint);
  }

  @override
  bool get preferPaintInterior => true;

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    final actualSide = effectiveSide;
    final sideWidth = actualSide.effectiveWidth;
    if (sideWidth == 0) return;

    final paint = actualSide.toPaint(rect)
      ..strokeWidth = sideWidth
      ..style = PaintingStyle.stroke;
    final Radius radius = Radius.circular(rect.shortestSide / 2);
    final RRect borderRect = RRect.fromRectAndRadius(rect, radius);
    final outer = borderRect.inflate(actualSide.strokeOffset / 2);
    if (actualSide.effectiveStyle.isSolid) {
      canvas.drawRRect(outer, paint);
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
    return other is WxStadiumBorder &&
        other.side == side &&
        other.style == style &&
        other.color == color &&
        other.gradient == gradient &&
        other.width == width &&
        other.offset == offset;
  }

  @override
  int get hashCode => Object.hash(side, style, color, gradient, width, offset);

  @override
  String toString() {
    return '${objectRuntimeType(this, 'WxStadiumBorder')}($side)';
  }
}

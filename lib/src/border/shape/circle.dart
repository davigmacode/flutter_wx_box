import 'dart:ui' as ui show lerpDouble;

import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';

import 'outlined.dart';
import '../side.dart';
import '../style.dart';

/// A border that fits a circle within the available space.
///
/// Typically used with [ShapeDecoration] to draw a circle.
///
/// The [dimensions] assume that the border is being used in a square space.
/// When applied to a rectangular space, the border paints in the center of the
/// rectangle.
///
/// The [eccentricity] parameter describes how much a circle will deform to
/// fit the rectangle it is a border for. A value of zero implies no
/// deformation (a circle touching at least two sides of the rectangle), a
/// value of one implies full deformation (an oval touching all sides of the
/// rectangle).
///
/// See also:
///
///  * [OvalBorder], which draws a Circle touching all the edges of the box.
///  * [WxBorderSide], which is used to describe each side of the box.
class WxCircleBorder extends WxOutlinedBorder {
  /// Create a circle border.
  ///
  /// The [side] argument must not be null.
  const WxCircleBorder({
    super.side,
    super.color,
    super.gradient,
    super.offset,
    super.style,
    super.width,
    this.eccentricity = 0.0,
  })  : assert(eccentricity >= 0.0,
            'The eccentricity argument $eccentricity is not greater than or equal to zero.'),
        assert(eccentricity <= 1.0,
            'The eccentricity argument $eccentricity is not less than or equal to one.');

  /// Defines the ratio (0.0-1.0) from which the border will deform
  /// to fit a rectangle.
  /// When 0.0, it draws a circle touching at least two sides of the rectangle.
  /// When 1.0, it draws an oval touching all sides of the rectangle.
  final double eccentricity;

  @override
  ShapeBorder scale(double t) => WxCircleBorder(
        side: effectiveSide.scale(t),
        eccentricity: eccentricity,
      );

  @override
  ShapeBorder? lerpFrom(ShapeBorder? a, double t) {
    if (a is WxCircleBorder) {
      return WxCircleBorder(
        side: WxBorderSide.lerp(a.side, side, t),
        eccentricity: clampDouble(
            ui.lerpDouble(a.eccentricity, eccentricity, t)!, 0.0, 1.0),
      );
    }
    return super.lerpFrom(a, t);
  }

  @override
  ShapeBorder? lerpTo(ShapeBorder? b, double t) {
    if (b is WxCircleBorder) {
      return WxCircleBorder(
        side: WxBorderSide.lerp(side, b.side, t),
        eccentricity: clampDouble(
            ui.lerpDouble(eccentricity, b.eccentricity, t)!, 0.0, 1.0),
      );
    }
    return super.lerpTo(b, t);
  }

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return Path()
      ..addOval(_adjustRect(rect).deflate(effectiveSide.strokeInset));
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    return Path()..addOval(_adjustRect(rect));
  }

  @override
  void paintInterior(
    Canvas canvas,
    Rect rect,
    Paint paint, {
    TextDirection? textDirection,
  }) {
    if (eccentricity == 0.0) {
      canvas.drawCircle(rect.center, rect.shortestSide / 2.0, paint);
    } else {
      canvas.drawOval(_adjustRect(rect), paint);
    }
  }

  @override
  bool get preferPaintInterior => true;

  @override
  WxCircleBorder copyWith({
    WxBorderSide? side,
    WxBorderStyle? style,
    Color? color,
    Gradient? gradient,
    double? width,
    double? offset,
    double? eccentricity,
  }) {
    return WxCircleBorder(
      side: side ?? this.side,
      style: style ?? this.style,
      color: color ?? this.color,
      gradient: gradient ?? this.gradient,
      width: width ?? this.width,
      offset: offset ?? this.offset,
      eccentricity: eccentricity ?? this.eccentricity,
    );
  }

  @override
  void paint(
    Canvas canvas,
    Rect rect, {
    TextDirection? textDirection,
  }) {
    final sideWidth = effectiveSide.effectiveWidth;
    final paint = effectiveSide.toPaint(rect)
      ..strokeWidth = sideWidth
      ..style = PaintingStyle.stroke;
    if (sideWidth > 0) {
      final offset = effectiveSide.strokeOffset / 2;
      final borderRect = _adjustRect(rect).inflate(offset);
      if (effectiveSide.effectiveStyle.isSolid) {
        canvas.drawOval(borderRect, paint);
      } else {
        final borderPath = getNonSolidPath(
          getOuterPath(borderRect),
          textDirection: textDirection,
        );
        canvas.drawPath(borderPath, paint);
      }
    }
  }

  Rect _adjustRect(Rect rect) {
    if (eccentricity == 0.0 || rect.width == rect.height) {
      return Rect.fromCircle(
        center: rect.center,
        radius: rect.shortestSide / 2.0,
      );
    }
    if (rect.width < rect.height) {
      final double delta =
          (1.0 - eccentricity) * (rect.height - rect.width) / 2.0;
      return Rect.fromLTRB(
        rect.left,
        rect.top + delta,
        rect.right,
        rect.bottom - delta,
      );
    } else {
      final double delta =
          (1.0 - eccentricity) * (rect.width - rect.height) / 2.0;
      return Rect.fromLTRB(
        rect.left + delta,
        rect.top,
        rect.right - delta,
        rect.bottom,
      );
    }
  }

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is WxCircleBorder &&
        other.side == side &&
        other.style == style &&
        other.color == color &&
        other.gradient == gradient &&
        other.width == width &&
        other.offset == offset &&
        other.eccentricity == eccentricity;
  }

  @override
  int get hashCode =>
      Object.hash(side, style, color, gradient, width, offset, eccentricity);

  @override
  String toString() {
    if (eccentricity != 0.0) {
      return '${objectRuntimeType(this, 'WxCircleBorder')}($side, eccentricity: $eccentricity)';
    }
    return '${objectRuntimeType(this, 'WxCircleBorder')}($side)';
  }
}

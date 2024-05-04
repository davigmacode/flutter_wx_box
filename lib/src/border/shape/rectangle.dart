import 'dart:ui' show lerpDouble;

import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';

import 'outlined.dart';
import 'circle.dart';
import 'rectangle_lerp.dart';
import '../side.dart';
import '../style.dart';

class WxRectangleBorder extends WxOutlinedBorder {
  /// Creates a rectangle border.
  ///
  /// The arguments must not be null.
  const WxRectangleBorder({
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
  bool get preferPaintInterior => true;

  @override
  ShapeBorder scale(double t) {
    return copyWith(
      side: effectiveSide.scale(t),
      corners: corners * t,
    );
  }

  @override
  ShapeBorder? lerpFrom(ShapeBorder? a, double t) {
    if (a is WxRectangleBorder) {
      return WxRectangleBorder(
        side: WxBorderSide.lerp(a.side, side, t),
        style: WxBorderStyle.lerp(a.style, style, t),
        color: Color.lerp(a.color, color, t),
        gradient: Gradient.lerp(a.gradient, gradient, t),
        width: lerpDouble(a.width, width, t),
        offset: lerpDouble(a.offset, offset, t),
        corners: BorderRadiusGeometry.lerp(a.corners, corners, t)!,
      );
    }
    if (a is WxCircleBorder) {
      return WxRectangleToCircleBorder(
        side: WxBorderSide.lerp(a.effectiveSide, effectiveSide, t),
        corners: corners,
        circularity: 1.0 - t,
        eccentricity: a.eccentricity,
      );
    }
    return super.lerpFrom(a, t);
  }

  @override
  ShapeBorder? lerpTo(ShapeBorder? b, double t) {
    if (b is WxRectangleBorder) {
      return b.copyWith(
        side: WxBorderSide.lerp(side, b.side, t),
        style: WxBorderStyle.lerp(style, b.style, t),
        color: Color.lerp(color, b.color, t),
        gradient: Gradient.lerp(gradient, b.gradient, t),
        width: lerpDouble(width, b.width, t),
        offset: lerpDouble(offset, b.offset, t),
        corners: BorderRadiusGeometry.lerp(corners, b.corners, t)!,
      );
    }
    if (b is WxCircleBorder) {
      return WxRectangleToCircleBorder(
        side: WxBorderSide.lerp(effectiveSide, b.effectiveSide, t),
        corners: corners,
        circularity: t,
        eccentricity: b.eccentricity,
      );
    }
    return super.lerpTo(b, t);
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

  /// Returns a copy of this WxRoundedRectangleBorder with the given fields
  /// replaced with the new values.
  @override
  WxRectangleBorder copyWith({
    WxBorderSide? side,
    WxBorderStyle? style,
    Color? color,
    Gradient? gradient,
    double? width,
    double? offset,
    BorderRadiusGeometry? corners,
  }) {
    return WxRectangleBorder(
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
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is WxRectangleBorder &&
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
    return '${objectRuntimeType(this, 'WxRectangleBorder')}($effectiveSide, $corners)';
  }
}

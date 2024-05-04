import 'dart:ui' as ui show lerpDouble;
import 'package:flutter/painting.dart';

import 'outlined.dart';
import 'circle.dart';
import 'rectangle.dart';
import '../side.dart';
import '../style.dart';

class WxRectangleToCircleBorder extends WxOutlinedBorder {
  const WxRectangleToCircleBorder({
    super.side,
    this.corners = BorderRadius.zero,
    required this.circularity,
    required this.eccentricity,
  });

  final BorderRadiusGeometry corners;
  final double circularity;
  final double eccentricity;

  @override
  ShapeBorder scale(double t) {
    return copyWith(
      side: effectiveSide.scale(t),
      corners: corners * t,
      circularity: t,
      eccentricity: eccentricity,
    );
  }

  @override
  ShapeBorder? lerpFrom(ShapeBorder? a, double t) {
    if (a is WxRectangleBorder) {
      return WxRectangleToCircleBorder(
        side: WxBorderSide.lerp(a.effectiveSide, effectiveSide, t),
        corners: BorderRadiusGeometry.lerp(a.corners, corners, t)!,
        circularity: circularity * t,
        eccentricity: eccentricity,
      );
    }
    if (a is WxCircleBorder) {
      return WxRectangleToCircleBorder(
        side: WxBorderSide.lerp(a.effectiveSide, effectiveSide, t),
        corners: corners,
        circularity: circularity + (1.0 - circularity) * (1.0 - t),
        eccentricity: a.eccentricity,
      );
    }
    if (a is WxRectangleToCircleBorder) {
      return WxRectangleToCircleBorder(
        side: WxBorderSide.lerp(a.effectiveSide, effectiveSide, t),
        corners: BorderRadiusGeometry.lerp(a.corners, corners, t)!,
        circularity: ui.lerpDouble(a.circularity, circularity, t)!,
        eccentricity: eccentricity,
      );
    }
    return super.lerpFrom(a, t);
  }

  @override
  ShapeBorder? lerpTo(ShapeBorder? b, double t) {
    if (b is WxRectangleBorder) {
      return WxRectangleToCircleBorder(
        side: WxBorderSide.lerp(effectiveSide, b.effectiveSide, t),
        corners: BorderRadiusGeometry.lerp(corners, b.corners, t)!,
        circularity: circularity * (1.0 - t),
        eccentricity: eccentricity,
      );
    }
    if (b is WxCircleBorder) {
      return WxRectangleToCircleBorder(
        side: WxBorderSide.lerp(effectiveSide, b.effectiveSide, t),
        corners: corners,
        circularity: circularity + (1.0 - circularity) * t,
        eccentricity: b.eccentricity,
      );
    }
    if (b is WxRectangleToCircleBorder) {
      return WxRectangleToCircleBorder(
        side: WxBorderSide.lerp(effectiveSide, b.effectiveSide, t),
        corners: BorderRadiusGeometry.lerp(corners, b.corners, t)!,
        circularity: ui.lerpDouble(circularity, b.circularity, t)!,
        eccentricity: eccentricity,
      );
    }
    return super.lerpTo(b, t);
  }

  Rect _adjustRect(Rect rect) {
    if (circularity == 0.0 || rect.width == rect.height) {
      return rect;
    }
    if (rect.width < rect.height) {
      final double partialDelta = (rect.height - rect.width) / 2;
      final double delta = circularity * partialDelta * (1.0 - eccentricity);
      return Rect.fromLTRB(
        rect.left,
        rect.top + delta,
        rect.right,
        rect.bottom - delta,
      );
    } else {
      final double partialDelta = (rect.width - rect.height) / 2;
      final double delta = circularity * partialDelta * (1.0 - eccentricity);
      return Rect.fromLTRB(
        rect.left + delta,
        rect.top,
        rect.right - delta,
        rect.bottom,
      );
    }
  }

  BorderRadius? _adjustBorderRadius(Rect rect, TextDirection? textDirection) {
    final BorderRadius resolvedRadius = corners.resolve(textDirection);
    if (circularity == 0.0) {
      return resolvedRadius;
    }
    if (eccentricity != 0.0) {
      if (rect.width < rect.height) {
        return BorderRadius.lerp(
          resolvedRadius,
          BorderRadius.all(Radius.elliptical(
              rect.width / 2, (0.5 + eccentricity / 2) * rect.height / 2)),
          circularity,
        )!;
      } else {
        return BorderRadius.lerp(
          resolvedRadius,
          BorderRadius.all(Radius.elliptical(
              (0.5 + eccentricity / 2) * rect.width / 2, rect.height / 2)),
          circularity,
        )!;
      }
    }
    return BorderRadius.lerp(resolvedRadius,
        BorderRadius.circular(rect.shortestSide / 2), circularity);
  }

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    final actualSide = effectiveSide;
    final RRect borderRect =
        _adjustBorderRadius(rect, textDirection)!.toRRect(_adjustRect(rect));
    final RRect adjustedRect = borderRect.deflate(
      ui.lerpDouble(
        actualSide.effectiveWidth,
        0,
        actualSide.effectiveOffset,
      )!,
    );
    return Path()..addRRect(adjustedRect);
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    return Path()
      ..addRRect(
          _adjustBorderRadius(rect, textDirection)!.toRRect(_adjustRect(rect)));
  }

  @override
  void paintInterior(
    Canvas canvas,
    Rect rect,
    Paint paint, {
    TextDirection? textDirection,
  }) {
    final BorderRadius adjustedBorderRadius =
        _adjustBorderRadius(rect, textDirection)!;
    if (adjustedBorderRadius == BorderRadius.zero) {
      canvas.drawRect(_adjustRect(rect), paint);
    } else {
      canvas.drawRRect(adjustedBorderRadius.toRRect(_adjustRect(rect)), paint);
    }
  }

  @override
  bool get preferPaintInterior => true;

  @override
  WxRectangleToCircleBorder copyWith({
    WxBorderSide? side,
    WxBorderStyle? style,
    Color? color,
    Gradient? gradient,
    double? width,
    double? offset,
    BorderRadiusGeometry? corners,
    double? circularity,
    double? eccentricity,
  }) {
    return WxRectangleToCircleBorder(
      side: side ?? this.side,
      corners: corners ?? this.corners,
      circularity: circularity ?? this.circularity,
      eccentricity: eccentricity ?? this.eccentricity,
    );
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    final actualSide = effectiveSide;
    if (actualSide.effectiveWidth > 0) {
      final BorderRadius adjustedBorderRadius =
          _adjustBorderRadius(rect, textDirection)!;
      final RRect borderRect = adjustedBorderRadius.toRRect(_adjustRect(rect));
      canvas.drawRRect(borderRect.inflate(effectiveSide.strokeOffset / 2),
          effectiveSide.toPaint(rect));
    }
  }

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is WxRectangleToCircleBorder &&
        other.side == side &&
        other.style == style &&
        other.color == color &&
        other.gradient == gradient &&
        other.width == width &&
        other.offset == offset &&
        other.corners == corners &&
        other.eccentricity == eccentricity &&
        other.circularity == circularity;
  }

  @override
  int get hashCode => Object.hash(side, style, color, gradient, width, offset,
      corners, eccentricity, circularity);

  @override
  String toString() {
    if (eccentricity != 0.0) {
      return 'WxRectangleBorder($side, $corners, ${(circularity * 100).toStringAsFixed(1)}% of the way to being a WxCircleBorder that is ${(eccentricity * 100).toStringAsFixed(1)}% oval)';
    }
    return 'WxRectangleBorder($side, $corners, ${(circularity * 100).toStringAsFixed(1)}% of the way to being a WxCircleBorder)';
  }
}

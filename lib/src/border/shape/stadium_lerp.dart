import 'dart:ui' as ui show lerpDouble;
import 'package:flutter/painting.dart';

import 'outlined.dart';
import 'stadium.dart';
import 'circle.dart';
import 'rectangle.dart';
import '../side.dart';
import '../style.dart';

class WxStadiumToCircleBorder extends WxOutlinedBorder {
  const WxStadiumToCircleBorder({
    super.side,
    this.circularity = 0.0,
    required this.eccentricity,
  });

  final double circularity;
  final double eccentricity;

  @override
  ShapeBorder scale(double t) {
    return WxStadiumToCircleBorder(
      side: effectiveSide.scale(t),
      circularity: t,
      eccentricity: eccentricity,
    );
  }

  @override
  ShapeBorder? lerpFrom(ShapeBorder? a, double t) {
    if (a is WxStadiumBorder) {
      return WxStadiumToCircleBorder(
        side: WxBorderSide.lerp(a.effectiveSide, effectiveSide, t),
        circularity: circularity * t,
        eccentricity: eccentricity,
      );
    }
    if (a is WxCircleBorder) {
      return WxStadiumToCircleBorder(
        side: WxBorderSide.lerp(a.effectiveSide, effectiveSide, t),
        circularity: circularity + (1.0 - circularity) * (1.0 - t),
        eccentricity: a.eccentricity,
      );
    }
    if (a is WxStadiumToCircleBorder) {
      return WxStadiumToCircleBorder(
        side: WxBorderSide.lerp(a.effectiveSide, effectiveSide, t),
        circularity: ui.lerpDouble(a.circularity, circularity, t)!,
        eccentricity: ui.lerpDouble(a.eccentricity, eccentricity, t)!,
      );
    }
    return super.lerpFrom(a, t);
  }

  @override
  ShapeBorder? lerpTo(ShapeBorder? b, double t) {
    if (b is WxStadiumBorder) {
      return WxStadiumToCircleBorder(
        side: WxBorderSide.lerp(effectiveSide, b.effectiveSide, t),
        circularity: circularity * (1.0 - t),
        eccentricity: eccentricity,
      );
    }
    if (b is WxCircleBorder) {
      return WxStadiumToCircleBorder(
        side: WxBorderSide.lerp(effectiveSide, b.effectiveSide, t),
        circularity: circularity + (1.0 - circularity) * t,
        eccentricity: b.eccentricity,
      );
    }
    if (b is WxStadiumToCircleBorder) {
      return WxStadiumToCircleBorder(
        side: WxBorderSide.lerp(effectiveSide, b.effectiveSide, t),
        circularity: ui.lerpDouble(circularity, b.circularity, t)!,
        eccentricity: ui.lerpDouble(eccentricity, b.eccentricity, t)!,
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

  BorderRadius _adjustBorderRadius(Rect rect) {
    final BorderRadius circleRadius =
        BorderRadius.circular(rect.shortestSide / 2);
    if (eccentricity != 0.0) {
      if (rect.width < rect.height) {
        return BorderRadius.lerp(
          circleRadius,
          BorderRadius.all(Radius.elliptical(
              rect.width / 2, (0.5 + eccentricity / 2) * rect.height / 2)),
          circularity,
        )!;
      } else {
        return BorderRadius.lerp(
          circleRadius,
          BorderRadius.all(Radius.elliptical(
              (0.5 + eccentricity / 2) * rect.width / 2, rect.height / 2)),
          circularity,
        )!;
      }
    }
    return circleRadius;
  }

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return Path()
      ..addRRect(_adjustBorderRadius(rect)
          .toRRect(_adjustRect(rect))
          .deflate(effectiveSide.strokeInset));
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    return Path()
      ..addRRect(_adjustBorderRadius(rect).toRRect(_adjustRect(rect)));
  }

  @override
  void paintInterior(Canvas canvas, Rect rect, Paint paint,
      {TextDirection? textDirection}) {
    canvas.drawRRect(
        _adjustBorderRadius(rect).toRRect(_adjustRect(rect)), paint);
  }

  @override
  bool get preferPaintInterior => true;

  @override
  WxStadiumToCircleBorder copyWith({
    WxBorderSide? side,
    WxBorderStyle? style,
    Color? color,
    Gradient? gradient,
    double? width,
    double? offset,
    double? circularity,
    double? eccentricity,
  }) {
    return WxStadiumToCircleBorder(
      side: side ?? this.side,
      circularity: circularity ?? this.circularity,
      eccentricity: eccentricity ?? this.eccentricity,
    );
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    final actualSide = effectiveSide;
    if (actualSide.effectiveWidth > 0) {
      final RRect borderRect =
          _adjustBorderRadius(rect).toRRect(_adjustRect(rect));
      canvas.drawRRect(borderRect.inflate(actualSide.strokeOffset / 2),
          actualSide.toPaint(rect));
    }
  }

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is WxStadiumToCircleBorder &&
        other.side == side &&
        other.circularity == circularity;
  }

  @override
  int get hashCode => Object.hash(side, circularity);

  @override
  String toString() {
    if (eccentricity != 0.0) {
      return 'StadiumBorder($side, ${(circularity * 100).toStringAsFixed(1)}% of the way to being a CircleBorder that is ${(eccentricity * 100).toStringAsFixed(1)}% oval)';
    }
    return 'StadiumBorder($side, ${(circularity * 100).toStringAsFixed(1)}% of the way to being a CircleBorder)';
  }
}

// Class to help with transitioning to/from a RoundedRectBorder.
class WxStadiumToRectangleBorder extends WxOutlinedBorder {
  const WxStadiumToRectangleBorder({
    super.side,
    this.corners = BorderRadius.zero,
    this.rectilinearity = 0.0,
  });

  final BorderRadiusGeometry corners;

  final double rectilinearity;

  @override
  ShapeBorder scale(double t) {
    return WxStadiumToRectangleBorder(
      side: effectiveSide.scale(t),
      corners: corners * t,
      rectilinearity: t,
    );
  }

  @override
  ShapeBorder? lerpFrom(ShapeBorder? a, double t) {
    if (a is WxStadiumBorder) {
      return WxStadiumToRectangleBorder(
        side: WxBorderSide.lerp(a.effectiveSide, effectiveSide, t),
        corners: corners,
        rectilinearity: rectilinearity * t,
      );
    }
    if (a is WxRectangleBorder) {
      return WxStadiumToRectangleBorder(
        side: WxBorderSide.lerp(a.effectiveSide, effectiveSide, t),
        corners: corners,
        rectilinearity: rectilinearity + (1.0 - rectilinearity) * (1.0 - t),
      );
    }
    if (a is WxStadiumToRectangleBorder) {
      return WxStadiumToRectangleBorder(
        side: WxBorderSide.lerp(a.effectiveSide, effectiveSide, t),
        corners: BorderRadiusGeometry.lerp(a.corners, corners, t)!,
        rectilinearity: ui.lerpDouble(a.rectilinearity, rectilinearity, t)!,
      );
    }
    return super.lerpFrom(a, t);
  }

  @override
  ShapeBorder? lerpTo(ShapeBorder? b, double t) {
    if (b is WxStadiumBorder) {
      return WxStadiumToRectangleBorder(
        side: WxBorderSide.lerp(effectiveSide, b.effectiveSide, t),
        corners: corners,
        rectilinearity: rectilinearity * (1.0 - t),
      );
    }
    if (b is WxRectangleBorder) {
      return WxStadiumToRectangleBorder(
        side: WxBorderSide.lerp(effectiveSide, b.effectiveSide, t),
        corners: corners,
        rectilinearity: rectilinearity + (1.0 - rectilinearity) * t,
      );
    }
    if (b is WxStadiumToRectangleBorder) {
      return WxStadiumToRectangleBorder(
        side: WxBorderSide.lerp(effectiveSide, b.effectiveSide, t),
        corners: BorderRadiusGeometry.lerp(corners, b.corners, t)!,
        rectilinearity: ui.lerpDouble(rectilinearity, b.rectilinearity, t)!,
      );
    }
    return super.lerpTo(b, t);
  }

  BorderRadiusGeometry _adjustBorderRadius(Rect rect) {
    return BorderRadiusGeometry.lerp(
      corners,
      BorderRadius.all(Radius.circular(rect.shortestSide / 2.0)),
      1.0 - rectilinearity,
    )!;
  }

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    final RRect borderRect =
        _adjustBorderRadius(rect).resolve(textDirection).toRRect(rect);
    final RRect adjustedRect = borderRect.deflate(
        ui.lerpDouble(effectiveSide.width, 0, effectiveSide.effectiveOffset)!);
    return Path()..addRRect(adjustedRect);
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    return Path()
      ..addRRect(
          _adjustBorderRadius(rect).resolve(textDirection).toRRect(rect));
  }

  @override
  void paintInterior(Canvas canvas, Rect rect, Paint paint,
      {TextDirection? textDirection}) {
    final BorderRadiusGeometry adjustedBorderRadius = _adjustBorderRadius(rect);
    if (adjustedBorderRadius == BorderRadius.zero) {
      canvas.drawRect(rect, paint);
    } else {
      canvas.drawRRect(
          adjustedBorderRadius.resolve(textDirection).toRRect(rect), paint);
    }
  }

  @override
  bool get preferPaintInterior => true;

  @override
  WxStadiumToRectangleBorder copyWith({
    WxBorderSide? side,
    WxBorderStyle? style,
    Color? color,
    Gradient? gradient,
    double? width,
    double? offset,
    BorderRadiusGeometry? corners,
    double? rectilinearity,
  }) {
    return WxStadiumToRectangleBorder(
      side: side ?? this.side,
      corners: corners ?? this.corners,
      rectilinearity: rectilinearity ?? this.rectilinearity,
    );
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    final actualSide = effectiveSide;
    if (actualSide.effectiveWidth > 0) {
      final BorderRadiusGeometry adjustedBorderRadius =
          _adjustBorderRadius(rect);
      final RRect borderRect =
          adjustedBorderRadius.resolve(textDirection).toRRect(rect);
      canvas.drawRRect(borderRect.inflate(actualSide.strokeOffset / 2),
          actualSide.toPaint(rect));
    }
  }

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is WxStadiumToRectangleBorder &&
        other.side == side &&
        other.corners == corners &&
        other.rectilinearity == rectilinearity;
  }

  @override
  int get hashCode => Object.hash(side, corners, rectilinearity);

  @override
  String toString() {
    return 'WxStadiumBorder($side, $corners, '
        '${(rectilinearity * 100).toStringAsFixed(1)}% of the way to being a '
        'WxRoundedRectangleBorder)';
  }
}

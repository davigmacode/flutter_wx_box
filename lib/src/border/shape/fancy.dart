// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:ui' show PathMetric;
import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';
import '../style.dart';

/// A WxShapeBorder that draws an outline with the width and color specified
/// by [side].
@immutable
class WxFancyBorder extends ShapeBorder {
  /// Abstract const constructor. This constructor enables subclasses to provide
  /// const constructors so that they can be used in const expressions.
  ///
  /// The value of [side] must not be null.
  const WxFancyBorder({
    this.shape,
    this.style = WxBorderStyle.solid,
    this.color,
    this.gradient,
    this.width,
    this.offset,
  }) : assert(width == null || width >= 0);

  final OutlinedBorder? shape;

  final WxBorderStyle style;

  /// The color of this side of the border.
  final Color? color;

  final Gradient? gradient;

  final double? width;

  final double? offset;

  OutlinedBorder get effectiveShape {
    final actualShape = shape ?? const RoundedRectangleBorder();
    return actualShape.copyWith(
      side: actualShape.side.copyWith(
        style:
            style == WxBorderStyle.solid ? BorderStyle.solid : BorderStyle.none,
        color: color,
        width: width,
        strokeAlign: offset,
      ),
    );
  }

  @override
  EdgeInsetsGeometry get dimensions => effectiveShape.dimensions;

  @override
  bool get preferPaintInterior => effectiveShape.preferPaintInterior;

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return effectiveShape.getInnerPath(rect, textDirection: textDirection);
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    return effectiveShape.getOuterPath(rect, textDirection: textDirection);
  }

  @override
  void paintInterior(
    Canvas canvas,
    Rect rect,
    Paint paint, {
    TextDirection? textDirection,
  }) {
    effectiveShape.paintInterior(canvas, rect, paint,
        textDirection: textDirection);
  }

  @override
  void paint(
    Canvas canvas,
    Rect rect, {
    TextDirection? textDirection,
  }) {
    final side = effectiveShape.side;
    final paint = Paint()
      ..color = side.color
      ..strokeWidth = side.width
      ..style = PaintingStyle.stroke
      ..shader = gradient?.createShader(rect);

    final offset = side.strokeOffset / 2;
    final borderRect = rect.inflate(offset);
    Path path = getOuterPath(borderRect);

    if (style != WxBorderStyle.solid) {
      path = getNonSolidPath(
        path,
        textDirection: textDirection,
      );
    }
    canvas.drawPath(path, paint);

    // if (preferPaintInterior) {
    //   paintInterior(canvas, rect, paint);
    //   return;
    // }

    // effectiveShape.paint(canvas, rect);
  }

  /// Returns a copy of this OutlinedBorder that draws its outline with the
  /// specified [side], if [side] is non-null.
  WxFancyBorder copyWith({
    OutlinedBorder? shape,
    WxBorderStyle? style,
    Color? color,
    Gradient? gradient,
    double? width,
    double? offset,
  }) {
    return WxFancyBorder(
      shape: shape ?? this.shape,
      style: style ?? this.style,
      color: color ?? this.color,
      gradient: gradient ?? this.gradient,
      width: width ?? this.width,
      offset: offset ?? this.offset,
    );
  }

  Path getNonSolidPath(Path source, {TextDirection? textDirection}) {
    final Path dest = Path();
    final sideWidth = effectiveShape.side.width;
    for (final PathMetric metric in source.computeMetrics()) {
      int index = 0;
      double distance = style.offset * metric.length;
      bool draw = true;
      while (distance < metric.length) {
        if (index >= style.pattern.length) {
          index = 0;
        }
        final double mul = style.absolute ? 1 : sideWidth;
        final double len = style.pattern[index++] * mul;
        if (draw) {
          dest.addPath(
            metric.extractPath(distance, distance + len),
            Offset.zero,
          );
        }
        distance += len;
        draw = !draw;
      }
    }
    return dest;
  }

  @override
  ShapeBorder scale(double t) {
    return copyWith(
      shape: effectiveShape.scale(t) as OutlinedBorder,
    );
  }

  @override
  ShapeBorder? lerpFrom(ShapeBorder? a, double t) {
    if (a is WxFancyBorder) {
      return WxFancyBorder(
        shape: effectiveShape.lerpFrom(a.effectiveShape, t) as OutlinedBorder?,
        style: WxBorderStyle.lerp(a.style, style, t)!,
        gradient: Gradient.lerp(a.gradient, gradient, t),
      );
    }
    return super.lerpFrom(a, t);
  }

  @override
  ShapeBorder? lerpTo(ShapeBorder? b, double t) {
    if (b is WxFancyBorder) {
      return WxFancyBorder(
        shape: effectiveShape.lerpTo(b.effectiveShape, t) as OutlinedBorder?,
        style: WxBorderStyle.lerp(style, b.style, t)!,
        gradient: Gradient.lerp(gradient, b.gradient, t),
      );
    }
    return super.lerpTo(b, t);
  }

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is WxFancyBorder &&
        other.shape == shape &&
        other.style == style &&
        other.color == color &&
        other.gradient == gradient &&
        other.width == width &&
        other.offset == offset;
  }

  @override
  int get hashCode => Object.hash(shape, style, color, gradient, width, offset);

  @override
  String toString() {
    return '${objectRuntimeType(this, 'WxFancyBorder')}($shape)';
  }
}

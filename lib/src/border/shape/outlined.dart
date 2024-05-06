// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:math' as math;
import 'dart:ui' show PathMetric;

import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';

import '../side.dart';
import '../style.dart';

/// A WxShapeBorder that draws an outline with the width and color specified
/// by [side].
@immutable
abstract class WxOutlinedBorder extends ShapeBorder {
  /// Abstract const constructor. This constructor enables subclasses to provide
  /// const constructors so that they can be used in const expressions.
  ///
  /// The value of [side] must not be null.
  const WxOutlinedBorder({
    this.side,
    this.style,
    this.color,
    this.gradient,
    this.width,
    this.offset,
  }) : assert(width == null || width >= 0);

  @override
  EdgeInsetsGeometry get dimensions =>
      EdgeInsets.all(math.max(effectiveSide.strokeInset, 0));

  /// The border outline's color and weight.
  ///
  /// If [side] is [WxBorderSide.none], which is the default, an outline is not drawn.
  /// Otherwise the outline is centered over the shape's boundary.
  final WxBorderSide? side;

  final WxBorderStyle? style;

  /// The color of this side of the border.
  final Color? color;

  final Gradient? gradient;

  final double? width;

  final double? offset;

  WxBorderSide get effectiveSide => (side ?? WxBorderSide.none).copyWith(
        style: style,
        color: color,
        gradient: gradient,
        width: width,
        offset: offset,
      );

  /// Returns a copy of this OutlinedBorder that draws its outline with the
  /// specified [side], if [side] is non-null.
  WxOutlinedBorder copyWith({
    WxBorderSide? side,
    WxBorderStyle? style,
    Color? color,
    Gradient? gradient,
    double? width,
    double? offset,
  });

  Path getNonSolidPath(Path source, {TextDirection? textDirection}) {
    final Path dest = Path();
    final sideStyle = effectiveSide.effectiveStyle;
    final sideWidth = effectiveSide.effectiveWidth;
    for (final PathMetric metric in source.computeMetrics()) {
      int index = 0;
      double distance = 0;
      bool draw = true;
      while (distance < metric.length) {
        if (index >= sideStyle.pattern.length) {
          index = 0;
        }
        final double mul = sideStyle.absolute ? 1 : sideWidth;
        final double len = sideStyle.pattern[index++] * mul;
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
  ShapeBorder scale(double t);

  @override
  ShapeBorder? lerpFrom(ShapeBorder? a, double t) {
    if (a == null) {
      return scale(t);
    }
    return null;
  }

  @override
  ShapeBorder? lerpTo(ShapeBorder? b, double t) {
    if (b == null) {
      return scale(1.0 - t);
    }
    return null;
  }

  /// Linearly interpolates between two [WxOutlinedBorder]s.
  ///
  /// This defers to `b`'s [lerpTo] function if `b` is not null. If `b` is
  /// null or if its [lerpTo] returns null, it uses `a`'s [lerpFrom]
  /// function instead. If both return null, it returns `a` before `t=0.5`
  /// and `b` after `t=0.5`.
  ///
  /// {@macro dart.ui.shadow.lerp}
  static WxOutlinedBorder? lerp(
    WxOutlinedBorder? a,
    WxOutlinedBorder? b,
    double t,
  ) {
    if (identical(a, b)) {
      return a;
    }
    ShapeBorder? result;
    if (b != null) {
      result = b.lerpFrom(a, t);
    }
    if (result == null && a != null) {
      result = a.lerpTo(b, t);
    }
    return result as WxOutlinedBorder? ?? (t < 0.5 ? a : b);
  }
}

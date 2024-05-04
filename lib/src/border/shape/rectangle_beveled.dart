// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';

import 'rectangle.dart';
import '../side.dart';
import '../style.dart';

/// A rectangular border with flattened or "beveled" corners.
///
/// The line segments that connect the rectangle's four sides will
/// begin and at locations offset by the corresponding border radius,
/// but not farther than the side's center. If all the border radii
/// exceed the sides' half widths/heights the resulting shape is
/// diamond made by connecting the centers of the sides.
class WxBeveledRectangleBorder extends WxRectangleBorder {
  /// Creates a border like a [RoundedRectangleBorder] except that the corners
  /// are joined by straight lines instead of arcs.
  const WxBeveledRectangleBorder({
    super.side,
    super.color,
    super.gradient,
    super.offset,
    super.style,
    super.width,
    super.corners,
  });

  @override
  bool get preferPaintInterior => false;

  /// Returns a copy of this WxRoundedRectangleBorder with the given fields
  /// replaced with the new values.
  @override
  WxBeveledRectangleBorder copyWith({
    WxBorderSide? side,
    WxBorderStyle? style,
    Color? color,
    Gradient? gradient,
    double? width,
    double? offset,
    BorderRadiusGeometry? corners,
  }) {
    return WxBeveledRectangleBorder(
      side: side ?? this.side,
      style: style ?? this.style,
      color: color ?? this.color,
      gradient: gradient ?? this.gradient,
      width: width ?? this.width,
      offset: offset ?? this.offset,
      corners: corners ?? this.corners,
    );
  }

  Path _getPath(RRect rrect) {
    final Offset centerLeft = Offset(rrect.left, rrect.center.dy);
    final Offset centerRight = Offset(rrect.right, rrect.center.dy);
    final Offset centerTop = Offset(rrect.center.dx, rrect.top);
    final Offset centerBottom = Offset(rrect.center.dx, rrect.bottom);

    final double tlRadiusX = math.max(0.0, rrect.tlRadiusX);
    final double tlRadiusY = math.max(0.0, rrect.tlRadiusY);
    final double trRadiusX = math.max(0.0, rrect.trRadiusX);
    final double trRadiusY = math.max(0.0, rrect.trRadiusY);
    final double blRadiusX = math.max(0.0, rrect.blRadiusX);
    final double blRadiusY = math.max(0.0, rrect.blRadiusY);
    final double brRadiusX = math.max(0.0, rrect.brRadiusX);
    final double brRadiusY = math.max(0.0, rrect.brRadiusY);

    final List<Offset> vertices = <Offset>[
      Offset(rrect.left, math.min(centerLeft.dy, rrect.top + tlRadiusY)),
      Offset(math.min(centerTop.dx, rrect.left + tlRadiusX), rrect.top),
      Offset(math.max(centerTop.dx, rrect.right - trRadiusX), rrect.top),
      Offset(rrect.right, math.min(centerRight.dy, rrect.top + trRadiusY)),
      Offset(rrect.right, math.max(centerRight.dy, rrect.bottom - brRadiusY)),
      Offset(math.max(centerBottom.dx, rrect.right - brRadiusX), rrect.bottom),
      Offset(math.min(centerBottom.dx, rrect.left + blRadiusX), rrect.bottom),
      Offset(rrect.left, math.max(centerLeft.dy, rrect.bottom - blRadiusY)),
    ];

    return Path()..addPolygon(vertices, true);
  }

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return _getPath(corners
        .resolve(textDirection)
        .toRRect(rect)
        .deflate(effectiveSide.strokeInset));
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    return _getPath(corners.resolve(textDirection).toRRect(rect));
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    if (rect.isEmpty) return;

    final actualSide = effectiveSide;
    final sideWidth = actualSide.effectiveWidth;
    if (sideWidth == 0) return;

    final paint = actualSide.toPaint(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = sideWidth;
    final RRect borderRect = corners.resolve(textDirection).toRRect(rect);
    final RRect adjustedRect = borderRect.inflate(actualSide.strokeOutset);
    final innerPath = getInnerPath(rect, textDirection: textDirection);
    final Path path = _getPath(adjustedRect)..addPath(innerPath, Offset.zero);
    canvas.drawPath(path, paint);
  }

  @override
  String toString() {
    return '${objectRuntimeType(this, 'WxBeveledRectangleBorder')}($side, $corners)';
  }
}

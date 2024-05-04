import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';

import 'rectangle.dart';
import '../side.dart';
import '../style.dart';

/// A rectangular border with smooth continuous transitions between the straight
/// sides and the rounded corners.
///
/// {@tool snippet}
/// ```dart
/// Widget build(BuildContext context) {
///   return Material(
///     shape: ContinuousRectangleBorder(
///       borderRadius: BorderRadius.circular(28.0),
///     ),
///   );
/// }
/// ```
/// {@end-tool}
///
/// See also:
///
///  * [RoundedRectangleBorder] Which creates rectangles with rounded corners,
///    however its straight sides change into a rounded corner with a circular
///    radius in a step function instead of gradually like the
///    [ContinuousRectangleBorder].
class WxContinuousRectangleBorder extends WxRectangleBorder {
  /// Creates a [ContinuousRectangleBorder].
  const WxContinuousRectangleBorder({
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
  WxContinuousRectangleBorder copyWith({
    WxBorderSide? side,
    WxBorderStyle? style,
    Color? color,
    Gradient? gradient,
    double? width,
    double? offset,
    BorderRadiusGeometry? corners,
  }) {
    return WxContinuousRectangleBorder(
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
  EdgeInsetsGeometry get dimensions =>
      EdgeInsets.all(effectiveSide.effectiveWidth);

  double _clampToShortest(RRect rrect, double value) {
    return value > rrect.shortestSide ? rrect.shortestSide : value;
  }

  Path _getPath(RRect rrect) {
    final double left = rrect.left;
    final double right = rrect.right;
    final double top = rrect.top;
    final double bottom = rrect.bottom;
    //  Radii will be clamped to the value of the shortest side
    // of rrect to avoid strange tie-fighter shapes.
    final double tlRadiusX =
        math.max(0.0, _clampToShortest(rrect, rrect.tlRadiusX));
    final double tlRadiusY =
        math.max(0.0, _clampToShortest(rrect, rrect.tlRadiusY));
    final double trRadiusX =
        math.max(0.0, _clampToShortest(rrect, rrect.trRadiusX));
    final double trRadiusY =
        math.max(0.0, _clampToShortest(rrect, rrect.trRadiusY));
    final double blRadiusX =
        math.max(0.0, _clampToShortest(rrect, rrect.blRadiusX));
    final double blRadiusY =
        math.max(0.0, _clampToShortest(rrect, rrect.blRadiusY));
    final double brRadiusX =
        math.max(0.0, _clampToShortest(rrect, rrect.brRadiusX));
    final double brRadiusY =
        math.max(0.0, _clampToShortest(rrect, rrect.brRadiusY));

    return Path()
      ..moveTo(left, top + tlRadiusX)
      ..cubicTo(left, top, left, top, left + tlRadiusY, top)
      ..lineTo(right - trRadiusX, top)
      ..cubicTo(right, top, right, top, right, top + trRadiusY)
      ..lineTo(right, bottom - brRadiusX)
      ..cubicTo(right, bottom, right, bottom, right - brRadiusY, bottom)
      ..lineTo(left + blRadiusX, bottom)
      ..cubicTo(left, bottom, left, bottom, left, bottom - blRadiusY)
      ..close();
  }

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return _getPath(corners
        .resolve(textDirection)
        .toRRect(rect)
        .deflate(effectiveSide.effectiveWidth));
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
    final path = getOuterPath(rect, textDirection: textDirection);
    canvas.drawPath(path, paint);
  }

  @override
  String toString() {
    return '${objectRuntimeType(this, 'WxContinuousRectangleBorder')}($side, $corners)';
  }
}

import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';

import 'basic.dart';

/// Represents the addition of two otherwise-incompatible borders.
///
/// The borders are listed from the outside to the inside.
class WxCompoundBorder extends WxShapeBorder {
  WxCompoundBorder(this.borders)
      : assert(borders.length >= 2),
        assert(
            !borders.any((WxShapeBorder border) => border is WxCompoundBorder));

  final List<WxShapeBorder> borders;

  @override
  EdgeInsetsGeometry get dimensions {
    return borders.fold<EdgeInsetsGeometry>(
      EdgeInsets.zero,
      (EdgeInsetsGeometry previousValue, WxShapeBorder border) {
        return previousValue.add(border.dimensions);
      },
    );
  }

  @override
  WxShapeBorder add(WxShapeBorder other, {bool reversed = false}) {
    // This wraps the list of borders with "other", or, if "reversed" is true,
    // wraps "other" with the list of borders.
    // If "reversed" is false, "other" should end up being at the start of the
    // list, otherwise, if "reversed" is true, it should end up at the end.
    // First, see if we can merge the new adjacent borders.
    if (other is! WxCompoundBorder) {
      // Here, "ours" is the border at the side where we're adding the new
      // border, and "merged" is the result of attempting to merge it with the
      // new border. If it's null, it couldn't be merged.
      final WxShapeBorder ours = reversed ? borders.last : borders.first;
      final WxShapeBorder? merged = ours.add(other, reversed: reversed) ??
          other.add(ours, reversed: !reversed);
      if (merged != null) {
        final List<WxShapeBorder> result = <WxShapeBorder>[...borders];
        result[reversed ? result.length - 1 : 0] = merged;
        return WxCompoundBorder(result);
      }
    }
    // We can't, so fall back to just adding the new border to the list.
    final List<WxShapeBorder> mergedBorders = <WxShapeBorder>[
      if (reversed) ...borders,
      if (other is WxCompoundBorder) ...other.borders else other,
      if (!reversed) ...borders,
    ];
    return WxCompoundBorder(mergedBorders);
  }

  @override
  WxShapeBorder scale(double t) {
    return WxCompoundBorder(
      borders
          .map<WxShapeBorder>((WxShapeBorder border) => border.scale(t))
          .toList(),
    );
  }

  @override
  WxShapeBorder? lerpFrom(WxShapeBorder? a, double t) {
    return WxCompoundBorder.lerp(a, this, t);
  }

  @override
  WxShapeBorder? lerpTo(WxShapeBorder? b, double t) {
    return WxCompoundBorder.lerp(this, b, t);
  }

  static WxCompoundBorder lerp(WxShapeBorder? a, WxShapeBorder? b, double t) {
    assert(a is WxCompoundBorder ||
        b is WxCompoundBorder); // Not really necessary, but all call sites currently intend this.
    final List<WxShapeBorder?> aList =
        a is WxCompoundBorder ? a.borders : <WxShapeBorder?>[a];
    final List<WxShapeBorder?> bList =
        b is WxCompoundBorder ? b.borders : <WxShapeBorder?>[b];
    final List<WxShapeBorder> results = <WxShapeBorder>[];
    final int length = math.max(aList.length, bList.length);
    for (int index = 0; index < length; index += 1) {
      final WxShapeBorder? localA = index < aList.length ? aList[index] : null;
      final WxShapeBorder? localB = index < bList.length ? bList[index] : null;
      if (localA != null && localB != null) {
        final WxShapeBorder? localResult =
            localA.lerpTo(localB, t) ?? localB.lerpFrom(localA, t);
        if (localResult != null) {
          results.add(localResult);
          continue;
        }
      }
      // If we're changing from one shape to another, make sure the shape that is coming in
      // is inserted before the shape that is going away, so that the outer path changes to
      // the new border earlier rather than later. (This affects, among other things, where
      // the ShapeDecoration class puts its background.)
      if (localB != null) {
        results.add(localB.scale(t));
      }
      if (localA != null) {
        results.add(localA.scale(1.0 - t));
      }
    }
    return WxCompoundBorder(results);
  }

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    for (int index = 0; index < borders.length - 1; index += 1) {
      rect = borders[index].dimensions.resolve(textDirection).deflateRect(rect);
    }
    return borders.last.getInnerPath(rect, textDirection: textDirection);
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    return borders.first.getOuterPath(rect, textDirection: textDirection);
  }

  @override
  void paintInterior(Canvas canvas, Rect rect, Paint paint,
      {TextDirection? textDirection}) {
    borders.first
        .paintInterior(canvas, rect, paint, textDirection: textDirection);
  }

  @override
  bool get preferPaintInterior => true;

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    for (final WxShapeBorder border in borders) {
      border.paint(canvas, rect, textDirection: textDirection);
      rect = border.dimensions.resolve(textDirection).deflateRect(rect);
    }
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is WxCompoundBorder &&
        listEquals<WxShapeBorder>(other.borders, borders);
  }

  @override
  int get hashCode => Object.hashAll(borders);

  @override
  String toString() {
    // We list them in reverse order because when adding two borders they end up
    // in the list in the opposite order of what the source looks like: a + b =>
    // [b, a]. We do this to make the painting code more optimal, and most of
    // the rest of the code doesn't care, except toString() (for debugging).
    return borders.reversed
        .map<String>((WxShapeBorder border) => border.toString())
        .join(' + ');
  }
}

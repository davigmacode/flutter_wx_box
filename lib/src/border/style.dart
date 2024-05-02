import 'dart:ui' show lerpDouble;
import 'package:flutter/foundation.dart' show listEquals;

class WxBorderStyle {
  const WxBorderStyle(
    this.pattern, {
    this.offset = 0,
    this.absolute = false,
  });

  static const solid = WxBorderStyle([]);
  static const dotted = WxBorderStyle([1]);
  static const dashed = WxBorderStyle([3, 2]);
  static const morse = WxBorderStyle([3, 2, 1, 2]);

  final List<double> pattern;
  final double offset;
  final bool absolute;

  bool get isSolid => pattern.isEmpty;

  bool get isNonSolid => !isSolid;

  static WxBorderStyle? lerp(WxBorderStyle? a, WxBorderStyle? b, double t) {
    if (a == null) return b;
    if (b == null) return a;
    final lowestMultiple = a.pattern.length * b.pattern.length;

    return WxBorderStyle(
      [
        for (int i = 0; i < lowestMultiple; i++)
          lerpDouble(
                a.pattern[i % a.pattern.length],
                b.pattern[i % b.pattern.length],
                t,
              ) ??
              0,
      ],
      offset: lerpDouble(a.offset, b.offset, t) ?? 0,
      absolute: t < 0.5 ? a.absolute : b.absolute,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is WxBorderStyle &&
        listEquals(other.pattern, pattern) &&
        other.offset == offset &&
        other.absolute == absolute;
  }

  @override
  int get hashCode => Object.hash(pattern, offset, absolute);
}

import 'dart:ui' show lerpDouble;
import 'package:flutter/foundation.dart';

/// A class representing a border style for widgets.
///
/// You can create custom border styles using the constructor or
/// use the built-in constant styles like `solid`, `dotted`, `dashed`,
/// and `morse`.
@immutable
class WxBorderStyle with Diagnosticable {
  /// Creates a new `WxBorderStyle` with the specified pattern,
  /// and flag to determine the pattern should relative to border width or not.
  ///
  /// * `pattern`: A list of doubles representing the on/off durations of the
  ///   border pattern. A value of `1` represents "on," and other values
  ///   represent "off."
  /// * `absolute` (default: `false`): Whether the pattern's position is
  ///   relative to the border width (false) or absolute value (true).
  const WxBorderStyle(
    this.pattern, {
    this.absolute = false,
  });

  /// A constant representing a solid border style.
  static const solid = WxBorderStyle([1, 0]);

  /// A constant representing a dotted border style.
  static const dotted = WxBorderStyle([1]);

  /// A constant representing a dashed border style.
  static const dashed = WxBorderStyle([3, 2]);

  /// A constant representing a Morse code-like border style.
  static const morse = WxBorderStyle([3, 2, 1, 2]);

  /// The list of doubles defining the on/off durations of the border pattern.
  final List<double> pattern;

  /// Whether the pattern's value is relative to border width value or absolute value.
  final bool absolute;

  /// Checks if the border style is solid (pattern is equal to `WxBorderStyle.solid.pattern`).
  bool get isSolid => listEquals(pattern, WxBorderStyle.solid.pattern);

  /// Checks if the border style is non-solid (not equal to `WxBorderStyle.solid.pattern`).
  bool get isNonSolid => !isSolid;

  /// Creates a lerped (linearly interpolated) border style between two
  /// existing styles.
  ///
  /// * `a`: The first `WxBorderStyle` (can be null).
  /// * `b`: The second `WxBorderStyle` (can be null).
  /// * `t`: The interpolation factor (0.0 for `a`, 1.0 for `b`).
  static WxBorderStyle? lerp(
    WxBorderStyle? a,
    WxBorderStyle? b,
    double t,
  ) {
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
        other.absolute == absolute;
  }

  @override
  int get hashCode => Object.hash(pattern, absolute);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IterableProperty('pattern', pattern));
    properties.add(DiagnosticsProperty<bool>('absolute', absolute));
  }
}

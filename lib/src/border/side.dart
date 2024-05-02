import 'dart:math' as math;
import 'dart:ui' show lerpDouble;

import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';

import 'style.dart';

/// A side of a border of a box.
@immutable
class WxBorderSide with Diagnosticable {
  /// Creates the side of a border.
  ///
  /// By default, the border is 1.0 logical pixels wide and solid black.
  const WxBorderSide({
    this.style = WxBorderStyle.solid,
    this.color = const Color(0xFF000000),
    this.gradient,
    this.width = 1.0,
    this.offset = alignInside,
  });

  /// A hairline black border that is not rendered.
  static const WxBorderSide none = WxBorderSide(width: 0.0);

  final WxBorderStyle style;

  /// The color of this side of the border.
  final Color color;

  final Gradient? gradient;

  /// The width of this side of the border, in logical pixels.
  ///
  /// Setting width to 0.0 will result in a hairline border. This means that
  /// the border will have the width of one physical pixel. Hairline
  /// rendering takes shortcuts when the path overlaps a pixel more than once.
  /// This means that it will render faster than otherwise, but it might
  /// double-hit pixels, giving it a slightly darker/lighter result.
  ///
  /// To omit the border entirely, set the [style] to [BorderStyle.none].
  final double width;

  /// The relative position of the stroke on a [WxBorderSide] in an
  /// [OutlinedBorder] or [Border].
  ///
  /// Values typically range from -1.0 ([alignInside], inside border,
  /// default) to 1.0 ([alignOutside], outside border), without any
  /// bound constraints (e.g., a value of -2.0 is not typical, but allowed).
  /// A value of 0 ([alignCenter]) will center the border on the edge
  /// of the widget.
  ///
  /// When set to [alignInside], the stroke is drawn completely inside
  /// the widget. For [alignCenter] and [alignOutside], a property
  /// such as [Container.clipBehavior] can be used in an outside widget to clip
  /// it. If [Container.decoration] has a border, the container may incorporate
  /// [width] as additional padding:
  /// - [alignInside] provides padding with full [width].
  /// - [alignCenter] provides padding with half [width].
  /// - [alignOutside] provides zero padding, as stroke is drawn entirely outside.
  ///
  /// This property is not honored by [toPaint] (because the [Paint] object
  /// cannot represent it); it is intended that classes that use [WxBorderSide]
  /// objects implement this property when painting borders by suitably
  /// inflating or deflating their regions.
  final double offset;

  /// The border is drawn fully inside of the border path.
  ///
  /// This is a constant for use with [offset].
  ///
  /// This is the default value for [offset].
  static const double alignInside = -1.0;

  /// The border is drawn on the center of the border path, with half of the
  /// [WxBorderSide.width] on the inside, and the other half on the outside of
  /// the path.
  ///
  /// This is a constant for use with [offset].
  static const double alignCenter = 0.0;

  /// The border is drawn on the outside of the border path.
  ///
  /// This is a constant for use with [offset].
  static const double alignOutside = 1.0;

  /// Creates a copy of this border but with the given fields replaced with the new values.
  WxBorderSide copyWith({
    WxBorderStyle? style,
    Color? color,
    Gradient? gradient,
    double? width,
    double? offset,
  }) {
    return WxBorderSide(
      style: style ?? this.style,
      color: color ?? this.color,
      gradient: gradient ?? this.gradient,
      width: width ?? this.width,
      offset: offset ?? this.offset,
    );
  }

  /// Creates a copy of this border side description but with the width scaled
  /// by the factor `t`.
  ///
  /// The `t` argument represents the multiplicand, or the position on the
  /// timeline for an interpolation from nothing to `this`, with 0.0 meaning
  /// that the object returned should be the nil variant of this object, 1.0
  /// meaning that no change should be applied, returning `this` (or something
  /// equivalent to `this`), and other values meaning that the object should be
  /// multiplied by `t`. Negative values are treated like zero.
  ///
  /// Since a zero width is normally painted as a hairline width rather than no
  /// border at all, the zero factor is special-cased to instead change the
  /// style to [BorderStyle.none].
  ///
  /// Values for `t` are usually obtained from an [Animation<double>], such as
  /// an [AnimationController].
  WxBorderSide scale(double t) {
    return copyWith(
      width: math.max(0.0, width * t),
    );
  }

  /// Create a [Paint] object that, if used to stroke a line, will draw the line
  /// in this border's style.
  ///
  /// The [offset] property is not reflected in the [Paint]; consumers must
  /// implement that directly by inflating or deflating their region appropriately.
  ///
  /// Not all borders use this method to paint their border sides. For example,
  /// non-uniform rectangular [Border]s have beveled edges and so paint their
  /// border sides as filled shapes rather than using a stroke.
  Paint toPaint(Rect rect) {
    return Paint()
      ..color = color
      ..shader = gradient?.createShader(rect);
  }

  /// Whether the two given [WxBorderSide]s can be merged using
  /// [WxBorderSide.merge].
  ///
  /// Two sides can be merged if one or both are zero-width with
  /// [BorderStyle.none], or if they both have the same color and style.
  ///
  /// The arguments must not be null.
  static bool canMerge(WxBorderSide a, WxBorderSide b) {
    return a.color == b.color;
  }

  /// Creates a [WxBorderSide] that represents the addition of the two given
  /// [WxBorderSide]s.
  ///
  /// It is only valid to call this if [canMerge] returns true for the two
  /// sides.
  ///
  /// If one of the sides is zero-width with [BorderStyle.none], then the other
  /// side is return as-is. If both of the sides are zero-width with
  /// [BorderStyle.none], then [WxBorderSide.none] is returned.
  ///
  /// The arguments must not be null.
  static WxBorderSide merge(WxBorderSide a, WxBorderSide b) {
    assert(a.color == b.color);
    return WxBorderSide(
      color: a.color, // == b.color
      gradient: a.gradient,
      width: a.width + b.width,
      offset: math.max(a.offset, b.offset),
    );
  }

  /// Linearly interpolate between two border sides.
  ///
  /// The arguments must not be null.
  ///
  /// {@macro dart.ui.shadow.lerp}
  static WxBorderSide lerp(WxBorderSide a, WxBorderSide b, double t) {
    if (identical(a, b)) {
      return a;
    }
    if (t == 0.0) {
      return a;
    }
    if (t == 1.0) {
      return b;
    }
    return WxBorderSide(
      style: WxBorderStyle.lerp(a.style, b.style, t)!,
      color: Color.lerp(a.color, b.color, t)!,
      gradient: Gradient.lerp(a.gradient, b.gradient, t),
      width: lerpDouble(a.width, b.width, t)!,
      offset: lerpDouble(a.offset, b.offset, t)!, // == b.strokeAlign
    );
  }

  /// Get the amount of the stroke width that lies inside of the [WxBorderSide].
  ///
  /// For example, this will return the [width] for a [offset] of -1, half
  /// the [width] for a [offset] of 0, and 0 for a [offset] of 1.
  double get strokeInset => width * (1 - (1 + offset) / 2);

  /// Get the amount of the stroke width that lies outside of the [WxBorderSide].
  ///
  /// For example, this will return 0 for a [offset] of -1, half the
  /// [width] for a [offset] of 0, and the [width] for a [offset]
  /// of 1.
  double get strokeOutset => width * (1 + offset) / 2;

  /// The offset of the stroke, taking into account the stroke alignment.
  ///
  /// For example, this will return the negative [width] of the stroke
  /// for a [offset] of -1, 0 for a [offset] of 0, and the
  /// [width] for a [offset] of -1.
  double get strokeOffset => width * offset;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is WxBorderSide &&
        other.color == color &&
        other.gradient == gradient &&
        other.width == width &&
        other.offset == offset;
  }

  @override
  int get hashCode => Object.hash(color, gradient, width, offset);

  @override
  String toStringShort() => 'BorderSide';

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Color>('color', color,
        defaultValue: const Color(0xFF000000)));
    properties.add(DoubleProperty('width', width, defaultValue: 1.0));
    properties.add(DoubleProperty('offset', offset, defaultValue: alignInside));
  }
}

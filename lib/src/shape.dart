/// The shape to use when rendering a [Border] or [BoxDecoration].
///
/// Consider using [ShapeBorder] subclasses directly (with [ShapeDecoration]),
/// instead of using [BoxShape] and [Border], if the shapes will need to be
/// interpolated or animated. The [Border] class cannot interpolate between
/// different shapes.
enum WxBoxShape {
  /// An axis-aligned, 2D rectangle. May have rounded corners (described by a
  /// [BorderRadius]). The edges of the rectangle will match the edges of the box
  /// into which the [Border] or [BoxDecoration] is painted.
  ///
  /// See also:
  ///
  ///  * [RoundedRectangleBorder], the equivalent [ShapeBorder].
  rectangle,

  /// A circle centered in the middle of the box into which the [Border] is painted.
  /// The diameter of the circle is the shortest dimension of the box,
  /// either the width or the height, such that the circle
  /// touches the edges of the box.
  ///
  /// See also:
  ///
  ///  * [CircleBorder], the equivalent [ShapeBorder].
  circle,

  /// A border that fits a stadium-shaped border (a box with semicircles on the ends)
  /// within the rectangle of the widget it is applied to.
  stadium;

  /// Whether or not this is rectangle shape
  bool get isRectangle => this == WxBoxShape.rectangle;

  /// Whether or not this is circle shape
  bool get isCircle => this == WxBoxShape.circle;

  /// Whether or not this is stadium shape
  bool get isStadium => this == WxBoxShape.stadium;
}

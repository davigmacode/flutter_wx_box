import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';

import 'compound.dart';

/// Base class for shape outlines.
///
/// This class handles how to add multiple borders together. Subclasses define
/// various shapes, like circles ([CircleBorder]), rounded rectangles
/// ([RoundedRectangleBorder]), continuous rectangles
/// ([ContinuousRectangleBorder]), or beveled rectangles
/// ([BeveledRectangleBorder]).
///
/// See also:
///
///  * [ShapeDecoration], which can be used with [DecoratedBox] to show a shape.
///  * [Material] (and many other widgets in the Material library), which takes
///    a [WxShapeBorder] to define its shape.
///  * [NotchedShape], which describes a shape with a hole in it.
@immutable
abstract class WxShapeBorder {
  /// Abstract const constructor. This constructor enables subclasses to provide
  /// const constructors so that they can be used in const expressions.
  const WxShapeBorder();

  /// The widths of the sides of this border represented as an [EdgeInsets].
  ///
  /// Specifically, this is the amount by which a rectangle should be inset so
  /// as to avoid painting over any important part of the border. It is the
  /// amount by which additional borders will be inset before they are drawn.
  ///
  /// This can be used, for example, with a [Padding] widget to inset a box by
  /// the size of these borders.
  ///
  /// Shapes that have a fixed ratio regardless of the area on which they are
  /// painted, or that change their rendering based on the size they are given
  /// when painting (for instance [CircleBorder]), will not return valid
  /// [dimensions] information because they cannot know their eventual size when
  /// computing their [dimensions].
  EdgeInsetsGeometry get dimensions;

  /// Attempts to create a new object that represents the amalgamation of `this`
  /// border and the `other` border.
  ///
  /// If the type of the other border isn't known, or the given instance cannot
  /// be reasonably added to this instance, then this should return null.
  ///
  /// This method is used by the [operator +] implementation.
  ///
  /// The `reversed` argument is true if this object was the right operand of
  /// the `+` operator, and false if it was the left operand.
  @protected
  WxShapeBorder? add(WxShapeBorder other, {bool reversed = false}) => null;

  /// Creates a new border consisting of the two borders on either side of the
  /// operator.
  ///
  /// If the borders belong to classes that know how to add themselves, then
  /// this results in a new border that represents the intelligent addition of
  /// those two borders (see [add]). Otherwise, an object is returned that
  /// merely paints the two borders sequentially, with the left hand operand on
  /// the inside and the right hand operand on the outside.
  WxShapeBorder operator +(WxShapeBorder other) {
    return add(other) ??
        other.add(this, reversed: true) ??
        WxCompoundBorder(<WxShapeBorder>[other, this]);
  }

  /// Creates a copy of this border, scaled by the factor `t`.
  ///
  /// Typically this means scaling the width of the border's side, but it can
  /// also include scaling other artifacts of the border, e.g. the border radius
  /// of a [RoundedRectangleBorder].
  ///
  /// The `t` argument represents the multiplicand, or the position on the
  /// timeline for an interpolation from nothing to `this`, with 0.0 meaning
  /// that the object returned should be the nil variant of this object, 1.0
  /// meaning that no change should be applied, returning `this` (or something
  /// equivalent to `this`), and other values meaning that the object should be
  /// multiplied by `t`. Negative values are allowed but may be meaningless
  /// (they correspond to extrapolating the interpolation from this object to
  /// nothing, and going beyond nothing)
  ///
  /// Values for `t` are usually obtained from an [Animation<double>], such as
  /// an [AnimationController].
  ///
  /// See also:
  ///
  ///  * [BorderSide.scale], which most [WxShapeBorder] subclasses defer to for
  ///    the actual computation.
  WxShapeBorder scale(double t);

  /// Linearly interpolates from another [WxShapeBorder] (possibly of another
  /// class) to `this`.
  ///
  /// When implementing this method in subclasses, return null if this class
  /// cannot interpolate from `a`. In that case, [lerp] will try `a`'s [lerpTo]
  /// method instead. If `a` is null, this must not return null.
  ///
  /// The base class implementation handles the case of `a` being null by
  /// deferring to [scale].
  ///
  /// The `t` argument represents position on the timeline, with 0.0 meaning
  /// that the interpolation has not started, returning `a` (or something
  /// equivalent to `a`), 1.0 meaning that the interpolation has finished,
  /// returning `this` (or something equivalent to `this`), and values in
  /// between meaning that the interpolation is at the relevant point on the
  /// timeline between `a` and `this`. The interpolation can be extrapolated
  /// beyond 0.0 and 1.0, so negative values and values greater than 1.0 are
  /// valid (and can easily be generated by curves such as
  /// [Curves.elasticInOut]).
  ///
  /// Values for `t` are usually obtained from an [Animation<double>], such as
  /// an [AnimationController].
  ///
  /// Instead of calling this directly, use [WxShapeBorder.lerp].
  @protected
  WxShapeBorder? lerpFrom(WxShapeBorder? a, double t) {
    if (a == null) {
      return scale(t);
    }
    return null;
  }

  /// Linearly interpolates from `this` to another [WxShapeBorder] (possibly of
  /// another class).
  ///
  /// This is called if `b`'s [lerpTo] did not know how to handle this class.
  ///
  /// When implementing this method in subclasses, return null if this class
  /// cannot interpolate from `b`. In that case, [lerp] will apply a default
  /// behavior instead. If `b` is null, this must not return null.
  ///
  /// The base class implementation handles the case of `b` being null by
  /// deferring to [scale].
  ///
  /// The `t` argument represents position on the timeline, with 0.0 meaning
  /// that the interpolation has not started, returning `this` (or something
  /// equivalent to `this`), 1.0 meaning that the interpolation has finished,
  /// returning `b` (or something equivalent to `b`), and values in between
  /// meaning that the interpolation is at the relevant point on the timeline
  /// between `this` and `b`. The interpolation can be extrapolated beyond 0.0
  /// and 1.0, so negative values and values greater than 1.0 are valid (and can
  /// easily be generated by curves such as [Curves.elasticInOut]).
  ///
  /// Values for `t` are usually obtained from an [Animation<double>], such as
  /// an [AnimationController].
  ///
  /// Instead of calling this directly, use [WxShapeBorder.lerp].
  @protected
  WxShapeBorder? lerpTo(WxShapeBorder? b, double t) {
    if (b == null) {
      return scale(1.0 - t);
    }
    return null;
  }

  /// Linearly interpolates between two [WxShapeBorder]s.
  ///
  /// This defers to `b`'s [lerpTo] function if `b` is not null. If `b` is
  /// null or if its [lerpTo] returns null, it uses `a`'s [lerpFrom]
  /// function instead. If both return null, it returns `a` before `t=0.5`
  /// and `b` after `t=0.5`.
  ///
  /// {@macro dart.ui.shadow.lerp}
  static WxShapeBorder? lerp(WxShapeBorder? a, WxShapeBorder? b, double t) {
    if (identical(a, b)) {
      return a;
    }
    WxShapeBorder? result;
    if (b != null) {
      result = b.lerpFrom(a, t);
    }
    if (result == null && a != null) {
      result = a.lerpTo(b, t);
    }
    return result ?? (t < 0.5 ? a : b);
  }

  /// Create a [Path] that describes the outer edge of the border.
  ///
  /// This path must not cross the path given by [getInnerPath] for the same
  /// [Rect].
  ///
  /// To obtain a [Path] that describes the area of the border itself, set the
  /// [Path.fillType] of the returned object to [PathFillType.evenOdd], and add
  /// to this object the path returned from [getInnerPath] (using
  /// [Path.addPath]).
  ///
  /// The `textDirection` argument must be provided non-null if the border
  /// has a text direction dependency (for example if it is expressed in terms
  /// of "start" and "end" instead of "left" and "right"). It may be null if
  /// the border will not need the text direction to paint itself.
  ///
  /// See also:
  ///
  ///  * [getInnerPath], which creates the path for the inner edge.
  ///  * [Path.contains], which can tell if an [Offset] is within a [Path].
  Path getOuterPath(Rect rect, {TextDirection? textDirection});

  /// Create a [Path] that describes the inner edge of the border.
  ///
  /// This path must not cross the path given by [getOuterPath] for the same
  /// [Rect].
  ///
  /// To obtain a [Path] that describes the area of the border itself, set the
  /// [Path.fillType] of the returned object to [PathFillType.evenOdd], and add
  /// to this object the path returned from [getOuterPath] (using
  /// [Path.addPath]).
  ///
  /// The `textDirection` argument must be provided and non-null if the border
  /// has a text direction dependency (for example if it is expressed in terms
  /// of "start" and "end" instead of "left" and "right"). It may be null if
  /// the border will not need the text direction to paint itself.
  ///
  /// See also:
  ///
  ///  * [getOuterPath], which creates the path for the outer edge.
  ///  * [Path.contains], which can tell if an [Offset] is within a [Path].
  Path getInnerPath(Rect rect, {TextDirection? textDirection});

  /// Paint a canvas with the appropriate shape.
  ///
  /// On [WxShapeBorder] subclasses whose [preferPaintInterior] method returns
  /// true, this should be faster than using [Canvas.drawPath] with the path
  /// provided by [getOuterPath]. (If [preferPaintInterior] returns false,
  /// then this method asserts in debug mode and does nothing in release mode.)
  ///
  /// Subclasses are expected to implement this method when the [Canvas] API
  /// has a dedicated method to draw the relevant shape. For example,
  /// [CircleBorder] uses this to call [Canvas.drawCircle], and
  /// [RoundedRectangleBorder] uses this to call [Canvas.drawRRect].
  ///
  /// Subclasses that implement this must ensure that calling [paintInterior]
  /// is semantically equivalent to (i.e. renders the same pixels as) calling
  /// [Canvas.drawPath] with the same [Paint] and the [Path] returned from
  /// [getOuterPath], and must also override [preferPaintInterior] to
  /// return true.
  ///
  /// For example, a shape that draws a rectangle might implement
  /// [getOuterPath], [paintInterior], and [preferPaintInterior] as follows:
  ///
  /// ```dart
  /// class RectangleBorder extends OutlinedBorder {
  ///   // ...
  ///
  ///   @override
  ///   Path getOuterPath(Rect rect, { TextDirection? textDirection }) {
  ///    return Path()
  ///      ..addRect(rect);
  ///   }
  ///
  ///   @override
  ///   void paintInterior(Canvas canvas, Rect rect, Paint paint, {TextDirection? textDirection}) {
  ///    canvas.drawRect(rect, paint);
  ///   }
  ///
  ///   @override
  ///   bool get preferPaintInterior => true;
  ///
  ///   // ...
  /// }
  /// ```
  ///
  /// When a shape can only be drawn using path, [preferPaintInterior] must
  /// return false. In that case, classes such as [ShapeDecoration] will cache
  /// the path from [getOuterPath] and call [Canvas.drawPath] directly.
  void paintInterior(Canvas canvas, Rect rect, Paint paint,
      {TextDirection? textDirection}) {
    assert(!preferPaintInterior,
        '$runtimeType.preferPaintInterior returns true but $runtimeType.paintInterior is not implemented.');
    assert(false,
        '$runtimeType.preferPaintInterior returns false, so it is an error to call its paintInterior method.');
  }

  /// Reports whether [paintInterior] is implemented.
  ///
  /// Classes such as [ShapeDecoration] prefer to use [paintInterior] if this
  /// getter returns true. This is intended to enable faster painting; instead
  /// of computing a shape using [getOuterPath] and then drawing it using
  /// [Canvas.drawPath], the path can be drawn directly to the [Canvas] using
  /// dedicated methods such as [Canvas.drawRect] or [Canvas.drawCircle].
  ///
  /// By default, this getter returns false.
  ///
  /// Subclasses that implement [paintInterior] should override this to return
  /// true. Subclasses should only override [paintInterior] if doing so enables
  /// faster rendering than is possible with [Canvas.drawPath] (so, in
  /// particular, subclasses should not call [Canvas.drawPath] in
  /// [paintInterior]).
  ///
  /// See also:
  ///
  ///  * [paintInterior], whose API documentation has an example implementation.
  bool get preferPaintInterior => false;

  /// Paints the border within the given [Rect] on the given [Canvas].
  ///
  /// The `textDirection` argument must be provided and non-null if the border
  /// has a text direction dependency (for example if it is expressed in terms
  /// of "start" and "end" instead of "left" and "right"). It may be null if
  /// the border will not need the text direction to paint itself.
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection});

  @override
  String toString() {
    return '${objectRuntimeType(this, 'WxShapeBorder')}()';
  }
}

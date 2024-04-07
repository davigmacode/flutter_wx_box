import 'package:flutter/widgets.dart';
import 'border.dart';
import 'utils.dart';

/// Const widget that provides a box-like layout with customizable elevation
class WxBox extends StatelessWidget {
  /// Create a box widget
  const WxBox({
    super.key,
    this.width,
    this.height,
    this.constraints,
    this.alignment,
    this.padding,
    this.margin,
    this.color,
    this.border,
    this.borderColor,
    this.borderWidth,
    this.borderStyle,
    this.borderAlign,
    this.borderSide,
    this.borderRadius,
    this.shadowColor,
    this.clipBehavior,
    this.elevation,
    this.child,
  });

  /// Create a box widget with square size
  const WxBox.square({
    super.key,
    double? size,
    this.constraints,
    this.alignment,
    this.padding,
    this.margin,
    this.color,
    this.borderColor,
    this.borderWidth,
    this.borderStyle,
    this.borderAlign,
    this.borderSide,
    this.borderRadius,
    this.shadowColor,
    this.clipBehavior,
    this.elevation,
    this.child,
  })  : border = const RoundedRectangleBorder(),
        width = size,
        height = size;

  /// Create a box widget with rectangle shape
  const WxBox.rectangle({
    super.key,
    this.width,
    this.height,
    this.constraints,
    this.alignment,
    this.padding,
    this.margin,
    this.color,
    this.borderColor,
    this.borderWidth,
    this.borderStyle,
    this.borderAlign,
    this.borderSide,
    this.borderRadius,
    this.shadowColor,
    this.clipBehavior,
    this.elevation,
    this.child,
  }) : border = const RoundedRectangleBorder();

  /// Create a box widget with circle shape
  const WxBox.circle({
    super.key,
    double? radius,
    this.constraints,
    this.alignment,
    this.padding,
    this.margin,
    this.color,
    this.borderColor,
    this.borderWidth,
    this.borderStyle,
    this.borderAlign,
    this.borderSide,
    this.borderRadius,
    this.shadowColor,
    this.clipBehavior,
    this.elevation,
    this.child,
  })  : border = const CircleBorder(),
        width = radius != null ? radius * 2 : null,
        height = radius != null ? radius * 2 : null;

  /// Create a box widget with stadium shape
  const WxBox.stadium({
    super.key,
    this.width,
    this.height,
    this.constraints,
    this.alignment,
    this.padding,
    this.margin,
    this.color,
    this.borderColor,
    this.borderWidth,
    this.borderStyle,
    this.borderAlign,
    this.borderSide,
    this.borderRadius,
    this.shadowColor,
    this.clipBehavior,
    this.elevation,
    this.child,
  }) : border = const StadiumBorder();

  /// The widget below this widget in the tree.
  final Widget? child;

  /// If non-null, requires the child to have exactly this width.
  final double? width;

  /// If non-null, requires the child to have exactly this height.
  final double? height;

  /// Additional constraints to apply to the child.
  ///
  /// The constructor `width` and `height` arguments are combined with the
  /// `constraints` argument to set this property.
  ///
  /// The [padding] goes inside the constraints.
  final BoxConstraints? constraints;

  /// Align the [child] within the container.
  ///
  /// If non-null, the container will expand to fill its parent and position its
  /// child within itself according to the given value. If the incoming
  /// constraints are unbounded, then the child will be shrink-wrapped instead.
  ///
  /// Ignored if [child] is null.
  final AlignmentGeometry? alignment;

  /// The amount of space by which to inset the child.
  final EdgeInsetsGeometry? padding;

  /// Outer space around the widget.
  final EdgeInsetsGeometry? margin;

  /// The color to paint behind the [child].
  final Color? color;

  /// When elevation is non zero the color to use for the shadow color.
  final Color? shadowColor;

  /// The z-coordinate relative to the parent at which to place this physical object.
  /// The value is non-negative.
  final double? elevation;

  /// A border to draw above the background [color]
  final OutlinedBorder? border;

  /// The color of this side of the border.
  final Color? borderColor;

  /// The width of this side of the border, in logical pixels.
  ///
  /// Setting width to 0.0 will result in a hairline border. This means that
  /// the border will have the width of one physical pixel. Hairline
  /// rendering takes shortcuts when the path overlaps a pixel more than once.
  /// This means that it will render faster than otherwise, but it might
  /// double-hit pixels, giving it a slightly darker/lighter result.
  ///
  /// To omit the border entirely, set the [borderStyle] to [BorderStyle.none].
  final double? borderWidth;

  /// The style of this side of the border.
  ///
  /// To omit a side, set [style] to [BorderStyle.none]. This skips
  /// painting the border, but the border still has a [width].
  final BorderStyle? borderStyle;

  /// The relative position of the stroke on a [BorderSide] in an
  /// [OutlinedBorder] or [Border].
  final double? borderAlign;

  /// The border outline's color and weight.
  ///
  /// If [side] is [BorderSide.none], which is the default, an outline is not drawn.
  /// Otherwise the outline is centered over the shape's boundary.
  final BorderSide? borderSide;

  /// The border radius of the rounded corners.
  final BorderRadius? borderRadius;

  /// Controls how to clip.
  /// Defaults to [Clip.antiAlias].
  final Clip? clipBehavior;

  /// default value for [elevation]
  static const defaultElevation = 0.0;

  /// default value for [shadowColor]
  static const defaultShadowColor = Color(0xFF000000);

  /// default value for [clipBehavior]
  static const defaultClipBehavior = Clip.none;

  @override
  Widget build(BuildContext context) {
    Widget? result = child;

    final constraints = width != null || height != null
        ? this.constraints?.tighten(width: width, height: height) ??
            BoxConstraints.tightFor(width: width, height: height)
        : this.constraints;

    if (child == null && (constraints == null || !constraints.isTight)) {
      result = LimitedBox(
        maxWidth: 0.0,
        maxHeight: 0.0,
        child: ConstrainedBox(constraints: const BoxConstraints.expand()),
      );
    } else if (alignment != null) {
      result = Align(alignment: alignment!, child: result);
    }

    if (padding != null) {
      result = Padding(padding: padding!, child: result);
    }

    if (constraints != null) {
      result = ConstrainedBox(constraints: constraints, child: result);
    }

    final effectiveBorderShape = buildBorder(
      borderShape: border,
      borderRadius: borderRadius,
      borderSide: borderSide,
      borderColor: borderColor,
      borderWidth: borderWidth,
      borderStyle: borderStyle,
      borderAlign: borderAlign,
    );

    final textDirection = Directionality.maybeOf(context);
    CustomClipper<Path> clipper = ShapeBorderClipper(
      textDirection: textDirection,
      shape: effectiveBorderShape,
    );
    result = WxBorder(
      textDirection: textDirection,
      shape: effectiveBorderShape,
      child: result,
    );

    if (color == null) {
      result = ClipPath(
        clipper: clipper,
        clipBehavior: clipBehavior ?? defaultClipBehavior,
        child: result,
      );
    } else {
      if (border is RoundedRectangleBorder) {
        result = PhysicalModel(
          color: color!,
          elevation: elevation ?? defaultElevation,
          shadowColor: shadowColor ?? defaultShadowColor,
          clipBehavior: clipBehavior ?? defaultClipBehavior,
          borderRadius: borderRadius,
          child: result,
        );
      } else {
        result = PhysicalShape(
          color: color!,
          elevation: elevation ?? defaultElevation,
          shadowColor: shadowColor ?? defaultShadowColor,
          clipBehavior: clipBehavior ?? defaultClipBehavior,
          clipper: clipper,
          child: result,
        );
      }
    }

    if (margin != null) {
      result = Padding(padding: margin!, child: result);
    }

    return result;
  }
}

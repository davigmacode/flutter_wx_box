import 'package:flutter/material.dart';
import 'box.dart';
import 'utils.dart';

class WxAnimatedBox extends ImplicitlyAnimatedWidget {
  /// Create an animated box widget
  const WxAnimatedBox({
    super.key,
    super.duration = const Duration(milliseconds: 200),
    super.curve,
    this.width,
    this.height,
    this.constraints,
    this.padding,
    this.margin,
    this.alignment,
    this.color,
    this.shadowColor,
    this.elevation,
    this.border,
    this.borderColor,
    this.borderWidth,
    this.borderStyle,
    this.borderAlign,
    this.borderSide,
    this.borderRadius,
    this.clipBehavior,
    required this.child,
  });

  /// Create an animated box widget with square size
  const WxAnimatedBox.square({
    super.key,
    super.duration = const Duration(milliseconds: 200),
    super.curve,
    double? size,
    this.constraints,
    this.padding,
    this.margin,
    this.alignment,
    this.color,
    this.shadowColor,
    this.elevation,
    this.borderColor,
    this.borderWidth,
    this.borderStyle,
    this.borderAlign,
    this.borderSide,
    this.borderRadius,
    this.clipBehavior,
    required this.child,
  })  : border = const RoundedRectangleBorder(),
        width = size,
        height = size;

  /// Create an animated box widget with rectangle shape
  const WxAnimatedBox.rectangle({
    super.key,
    super.duration = const Duration(milliseconds: 200),
    super.curve,
    this.width,
    this.height,
    this.constraints,
    this.padding,
    this.margin,
    this.alignment,
    this.color,
    this.shadowColor,
    this.elevation,
    this.borderColor,
    this.borderWidth,
    this.borderStyle,
    this.borderAlign,
    this.borderSide,
    this.borderRadius,
    this.clipBehavior,
    required this.child,
  }) : border = const RoundedRectangleBorder();

  /// Create an animated box widget with circle shape
  const WxAnimatedBox.circle({
    super.key,
    super.duration = const Duration(milliseconds: 200),
    super.curve,
    double? radius,
    this.constraints,
    this.padding,
    this.margin,
    this.alignment,
    this.color,
    this.shadowColor,
    this.elevation,
    this.borderColor,
    this.borderWidth,
    this.borderStyle,
    this.borderAlign,
    this.borderSide,
    this.borderRadius,
    this.clipBehavior,
    required this.child,
  })  : border = const CircleBorder(),
        width = radius != null ? radius * 2 : null,
        height = radius != null ? radius * 2 : null;

  /// Create an animated box widget with stadium shape
  const WxAnimatedBox.stadium({
    super.key,
    super.duration = const Duration(milliseconds: 200),
    super.curve,
    this.width,
    this.height,
    this.constraints,
    this.padding,
    this.margin,
    this.alignment,
    this.color,
    this.shadowColor,
    this.elevation,
    this.borderColor,
    this.borderWidth,
    this.borderStyle,
    this.borderAlign,
    this.borderSide,
    this.borderRadius,
    this.clipBehavior,
    required this.child,
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

  @override
  AnimatedBoxState createState() => AnimatedBoxState();
}

class AnimatedBoxState extends AnimatedWidgetBaseState<WxAnimatedBox> {
  ShapeBorder get borderShape {
    return buildBorder(
      borderShape: widget.border,
      borderRadius: widget.borderRadius,
      borderSide: widget.borderSide,
      borderColor: widget.borderColor,
      borderWidth: widget.borderWidth,
      borderStyle: widget.borderStyle,
      borderAlign: widget.borderAlign,
    );
  }

  Tween<double?>? widthTween;
  Tween<double?>? heightTween;
  BoxConstraintsTween? constraintsTween;
  AlignmentGeometryTween? alignmentTween;
  EdgeInsetsGeometryTween? paddingTween;
  EdgeInsetsGeometryTween? marginTween;
  ColorTween? colorTween;
  ColorTween? shadowColorTween;
  Tween<double?>? elevationTween;
  ShapeBorderTween? borderShapeTween;

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    widthTween = visitor(
      widthTween,
      widget.width,
      (dynamic value) => Tween<double?>(begin: value),
    ) as Tween<double?>?;

    heightTween = visitor(
      heightTween,
      widget.height,
      (dynamic value) => Tween<double?>(begin: value),
    ) as Tween<double?>?;

    constraintsTween = visitor(
      constraintsTween,
      widget.constraints,
      (dynamic value) => BoxConstraintsTween(begin: value),
    ) as BoxConstraintsTween?;

    alignmentTween = visitor(
      alignmentTween,
      widget.alignment,
      (dynamic value) => AlignmentGeometryTween(begin: value),
    ) as AlignmentGeometryTween?;

    paddingTween = visitor(
      paddingTween,
      widget.padding,
      (value) => EdgeInsetsGeometryTween(begin: value),
    ) as EdgeInsetsGeometryTween?;

    marginTween = visitor(
      marginTween,
      widget.margin,
      (value) => EdgeInsetsGeometryTween(begin: value),
    ) as EdgeInsetsGeometryTween?;

    colorTween = visitor(
      colorTween,
      widget.color,
      (dynamic value) => ColorTween(begin: value),
    ) as ColorTween?;

    shadowColorTween = visitor(
      shadowColorTween,
      widget.shadowColor,
      (dynamic value) => ColorTween(begin: value),
    ) as ColorTween?;

    elevationTween = visitor(
      elevationTween,
      widget.elevation,
      (dynamic value) => Tween<double?>(begin: value),
    ) as Tween<double?>?;

    borderShapeTween = visitor(
      borderShapeTween,
      borderShape,
      (dynamic value) => ShapeBorderTween(begin: value),
    ) as ShapeBorderTween?;
  }

  @override
  Widget build(BuildContext context) {
    return WxBox(
      width: widthTween?.evaluate(animation),
      height: heightTween?.evaluate(animation),
      constraints: constraintsTween?.evaluate(animation),
      alignment: alignmentTween?.evaluate(animation),
      padding: paddingTween?.evaluate(animation),
      margin: marginTween?.evaluate(animation),
      color: colorTween?.evaluate(animation),
      shadowColor: shadowColorTween?.evaluate(animation),
      elevation: elevationTween?.evaluate(animation),
      border: borderShapeTween?.evaluate(animation) as OutlinedBorder,
      clipBehavior: widget.clipBehavior,
      child: widget.child,
    );
  }
}

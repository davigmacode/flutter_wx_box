import 'package:flutter/material.dart';
import 'box.dart';

class WxAnimatedBox extends ImplicitlyAnimatedWidget {
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
    this.borderSide,
    this.borderRadius,
    this.clipBehavior,
    this.shape,
    required this.child,
  });

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

  /// The border outline's color and weight.
  ///
  /// If [side] is [BorderSide.none], which is the default, an outline is not drawn.
  /// Otherwise the outline is centered over the shape's boundary.
  final BorderSide? borderSide;

  /// The border radius of the rounded corners.
  final BorderRadius? borderRadius;

  /// The shape to fill the [color] into and to cast as the [shadows].
  final BoxShape? shape;

  /// Controls how to clip.
  /// Defaults to [Clip.antiAlias].
  final Clip? clipBehavior;

  @override
  AnimatedBoxState createState() => AnimatedBoxState();
}

class AnimatedBoxState extends AnimatedWidgetBaseState<WxAnimatedBox> {
  BorderSide get borderSide {
    return (widget.borderSide ?? BorderSide.none).copyWith(
      color: widget.borderColor,
      width: widget.borderWidth,
      style: widget.borderStyle,
    );
  }

  ShapeBorder get borderShape {
    return widget.shape == BoxShape.circle
        ? CircleBorder(side: borderSide)
        : RoundedRectangleBorder(
            side: borderSide,
            borderRadius: widget.borderRadius ?? BorderRadius.zero,
          );
  }

  ShapeBorder get border => widget.border ?? borderShape;

  AlignmentGeometryTween? alignmentTween;
  EdgeInsetsGeometryTween? paddingTween;
  EdgeInsetsGeometryTween? marginTween;
  ColorTween? colorTween;
  ColorTween? shadowColorTween;
  Tween<double?>? elevationTween;
  ShapeBorderTween? borderTween;

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
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
      widget.elevation ?? 0.0,
      (dynamic value) => Tween<double?>(begin: value),
    ) as Tween<double?>?;

    borderTween = visitor(
      borderTween,
      border,
      (dynamic value) => ShapeBorderTween(begin: value),
    ) as ShapeBorderTween?;
  }

  @override
  Widget build(BuildContext context) {
    return WxBox(
      width: widget.width,
      height: widget.height,
      constraints: widget.constraints,
      alignment: alignmentTween?.evaluate(animation),
      padding: paddingTween?.evaluate(animation),
      margin: marginTween?.evaluate(animation),
      color: colorTween?.evaluate(animation),
      shadowColor: shadowColorTween?.evaluate(animation),
      elevation: elevationTween?.evaluate(animation),
      border: borderTween?.evaluate(animation) as OutlinedBorder,
      clipBehavior: widget.clipBehavior,
      child: widget.child,
    );
  }
}

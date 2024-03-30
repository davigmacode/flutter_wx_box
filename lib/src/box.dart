import 'package:flutter/widgets.dart';
import 'border.dart';

class WxBox extends StatelessWidget {
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
    this.borderSide,
    this.borderRadius,
    this.shape,
    this.shadowColor,
    this.clipBehavior,
    this.elevation,
    this.child,
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

  bool get hasCustomShape => border != null;

  BorderSide? get effectiveBorderSide {
    return BorderSide.none
        .copyWith(
          color: borderSide?.color,
          width: borderSide?.width,
          style: borderSide?.style,
        )
        .copyWith(
          color: borderColor,
          width: borderWidth,
          style: borderStyle,
        );
  }

  OutlinedBorder get borderShape {
    switch (shape) {
      case BoxShape.circle:
        return CircleBorder(
          side: effectiveBorderSide ?? BorderSide.none,
        );
      default:
        return RoundedRectangleBorder(
          side: effectiveBorderSide ?? BorderSide.none,
          borderRadius: borderRadius ?? BorderRadius.zero,
        );
    }
  }

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

    final border = this.border ?? borderShape;
    final textDirection = Directionality.maybeOf(context);
    final clipper = ShapeBorderClipper(
      textDirection: textDirection,
      shape: border,
    );

    result = WxBorder(
      textDirection: textDirection,
      shape: border,
      child: result,
    );

    if (color == null) {
      result = ClipPath(
        clipper: clipper,
        clipBehavior: clipBehavior ?? Clip.antiAlias,
        child: result,
      );
    } else {
      if (hasCustomShape) {
        result = PhysicalShape(
          color: color!,
          elevation: elevation ?? 0.0,
          shadowColor: shadowColor ?? const Color(0xFF000000),
          clipBehavior: clipBehavior ?? Clip.antiAlias,
          clipper: clipper,
          child: result,
        );
      } else {
        result = PhysicalModel(
          color: color!,
          elevation: elevation ?? 0.0,
          shadowColor: shadowColor ?? const Color(0xFF000000),
          clipBehavior: clipBehavior ?? Clip.antiAlias,
          borderRadius: borderRadius,
          shape: shape ?? BoxShape.rectangle,
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

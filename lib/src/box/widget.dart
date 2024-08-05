import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'utils.dart';

const colorBlack = Color(0xFF000000);
const colorTransparent = Color(0x00000000);

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
    this.image,
    this.shadows,
    this.gradient,
    this.color,
    this.border,
    this.borderColor,
    this.borderWidth,
    this.borderStyle,
    this.borderOffset,
    this.borderSide,
    this.borderRadius,
    this.clipBehavior,
    this.elevationColor,
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
    this.image,
    this.shadows,
    this.gradient,
    this.color,
    this.borderColor,
    this.borderWidth,
    this.borderStyle,
    this.borderOffset,
    this.borderSide,
    this.borderRadius,
    this.clipBehavior,
    this.elevationColor,
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
    this.image,
    this.shadows,
    this.gradient,
    this.color,
    this.borderColor,
    this.borderWidth,
    this.borderStyle,
    this.borderOffset,
    this.borderSide,
    this.borderRadius,
    this.clipBehavior,
    this.elevationColor,
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
    this.image,
    this.shadows,
    this.gradient,
    this.color,
    this.borderColor,
    this.borderWidth,
    this.borderStyle,
    this.borderOffset,
    this.borderSide,
    this.borderRadius,
    this.clipBehavior,
    this.elevationColor,
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
    this.image,
    this.shadows,
    this.gradient,
    this.color,
    this.borderColor,
    this.borderWidth,
    this.borderStyle,
    this.borderOffset,
    this.borderSide,
    this.borderRadius,
    this.elevationColor,
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
  final Color? elevationColor;

  /// The z-coordinate relative to the parent at which to place this physical object.
  /// The value is non-negative.
  final double? elevation;

  /// An image to paint inside the shape (clipped to its outline).
  ///
  /// The image is drawn over the [color] or [gradient].
  final DecorationImage? image;

  /// A list of shadows cast by the [border].
  final List<BoxShadow>? shadows;

  /// A gradient to use when filling the shape.
  ///
  /// The gradient is under the [image].
  ///
  /// If a [color] is specified, [gradient] must be null.
  final Gradient? gradient;

  /// A border to draw above the background [color]
  final ShapeBorder? border;

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
  final double? borderOffset;

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

  /// Clip Behavior from property with default value `Clip.none`
  Clip get effectiveClipBehavior => clipBehavior ?? Clip.none;

  @override
  Widget build(BuildContext context) {
    Widget? result = child;

    final effectiveBorderShape = buildBorder(
      borderShape: border,
      borderRadius: borderRadius,
      borderSide: borderSide,
      borderColor: borderColor,
      borderWidth: borderWidth,
      borderStyle: borderStyle,
      borderOffset: borderOffset,
    );

    final textDirection = Directionality.maybeOf(context);
    CustomClipper<Path> clipper = ShapeBorderClipper(
      textDirection: textDirection,
      shape: effectiveBorderShape,
    );

    if (effectiveClipBehavior != Clip.none) {
      result = ClipPath(
        clipper: clipper,
        clipBehavior: effectiveClipBehavior,
        child: result,
      );
    }

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

    result = DecoratedBox(
      decoration: ShapeDecoration(
        shape: effectiveBorderShape,
        color: color,
        shadows: shadows,
        gradient: gradient,
        image: image,
      ),
      child: result,
    );

    if (elevation != null) {
      final effectiveElevation = elevation ?? 0;
      final effectiveElevationColor = elevationColor ?? colorBlack;
      if (effectiveBorderShape is RoundedRectangleBorder) {
        result = PhysicalModel(
          color: colorTransparent,
          elevation: effectiveElevation,
          shadowColor: effectiveElevationColor,
          clipBehavior: Clip.none,
          borderRadius:
              effectiveBorderShape.borderRadius.resolve(textDirection),
          child: result,
        );
      } else {
        result = PhysicalShape(
          color: colorTransparent,
          elevation: effectiveElevation,
          shadowColor: effectiveElevationColor,
          clipBehavior: Clip.none,
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

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DoubleProperty('width', width));
    properties.add(DoubleProperty('height', height));
    properties
        .add(DiagnosticsProperty<BoxConstraints?>('constraints', constraints));
    properties
        .add(DiagnosticsProperty<AlignmentGeometry?>('alignment', alignment));
    properties
        .add(DiagnosticsProperty<EdgeInsetsGeometry?>('padding', padding));
    properties.add(DiagnosticsProperty<EdgeInsetsGeometry?>('margin', margin));
    properties.add(ColorProperty('color', color));
    properties.add(ColorProperty('elevationColor', elevationColor));
    properties.add(DoubleProperty('elevation', elevation));
    properties.add(DiagnosticsProperty<ShapeBorder?>('border', border));
    properties.add(ColorProperty('borderColor', borderColor));
    properties.add(DoubleProperty('borderWidth', borderWidth));
    properties.add(EnumProperty<BorderStyle?>('borderStyle', borderStyle));
    properties.add(DoubleProperty('borderOffset', borderOffset));
    properties.add(DiagnosticsProperty<BorderSide?>('borderSide', borderSide));
    properties
        .add(DiagnosticsProperty<BorderRadius?>('borderRadius', borderRadius));
    properties.add(EnumProperty<Clip?>('clipBehavior', clipBehavior));
  }
}

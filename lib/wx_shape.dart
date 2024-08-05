library wx_shape;

import 'package:flutter/painting.dart';
import 'src/border/shape/outlined.dart';
import 'src/border/shape/rectangle.dart';

/// Creates a `ShapeBorder` based on the provided parameters.
///
/// This method constructs a `ShapeBorder` instance by combining and overriding
/// properties from the given parameters. It supports various `ShapeBorder` types
/// and allows customization of their appearance.
///
/// If `borderShape` is not provided, a `RoundedRectangleBorder` is used as the default.
///
/// Parameters:
///   - `borderShape`: The base `ShapeBorder` to modify.
///   - `borderRadius`: The overall border radius.
///   - `borderSide`: The border side properties (color, width, style, stroke align).
///   - `borderColor`: The border color.
///   - `borderWidth`: The border width.
///   - `borderStyle`: The border style.
///   - `borderOffset`: The border offset.
///
/// Returns:
///   The constructed `ShapeBorder` instance.
ShapeBorder createShapeBorder({
  ShapeBorder? borderShape,
  BorderRadius? borderRadius,
  BorderSide? borderSide,
  Color? borderColor,
  double? borderWidth,
  BorderStyle? borderStyle,
  double? borderOffset,
}) {
  borderShape ??= const RoundedRectangleBorder();

  if (borderShape is OutlinedBorder) {
    borderShape = borderShape.copyWith(
      side: borderShape.side
          .copyWith(
            color: borderSide?.color,
            width: borderSide?.width,
            style: borderSide?.style,
            strokeAlign: borderSide?.strokeAlign,
          )
          .copyWith(
            color: borderColor,
            width: borderWidth,
            style: borderStyle,
            strokeAlign: borderOffset,
          ),
    );
  }

  if (borderShape is WxOutlinedBorder) {
    borderShape = borderShape.copyWith(
      color: borderColor,
      width: borderWidth,
      offset: borderOffset,
    );
  }

  if (borderShape is WxRectangleBorder) {
    borderShape = borderShape.copyWith(
      corners: borderRadius,
    );
  }

  if (borderShape is RoundedRectangleBorder) {
    borderShape = borderShape.copyWith(
      borderRadius: borderRadius,
    );
  }

  if (borderShape is BeveledRectangleBorder) {
    borderShape = borderShape.copyWith(
      borderRadius: borderRadius,
    );
  }

  if (borderShape is ContinuousRectangleBorder) {
    borderShape = borderShape.copyWith(
      borderRadius: borderRadius,
    );
  }

  return borderShape;
}

import 'package:flutter/painting.dart';
import '../border/shape/outlined.dart';
import '../border/shape/rectangle.dart';

ShapeBorder buildBorder({
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

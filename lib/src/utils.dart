import 'package:flutter/painting.dart';

OutlinedBorder buildBorder({
  OutlinedBorder? borderShape,
  BorderRadius? borderRadius,
  BorderSide? borderSide,
  Color? borderColor,
  double? borderWidth,
  BorderStyle? borderStyle,
  double? borderAlign,
}) {
  borderShape ??= const RoundedRectangleBorder();
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
          strokeAlign: borderAlign,
        ),
  );

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

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mock_bloc_stream/utils/color.dart';
import 'package:mock_bloc_stream/utils/styles.dart';

class CustomButtonParams {
  CustomButtonParams({
    this.height,
    this.width,
    required this.text,
    this.onPressed,
    this.margin,
    this.padding,
    this.boxShadow,
    this.radius = 10,
    this.textStyle,
    this.backgroundColor,
    this.wrapWidth = false,
  });

  factory CustomButtonParams.primary({
    required String text,
    VoidCallback? onPressed,
    bool hasGradient = true,
    bool wrapWidth = false,
    Color? backgroundColor,
    EdgeInsets? padding,
    TextStyle? textStyle,
  }) {
    return CustomButtonParams(
      text: text,
      padding: padding,
      textStyle: textStyle ?? StylesConstant.ts16w500cWhite,
      onPressed: onPressed,
      backgroundColor: backgroundColor,
      wrapWidth: wrapWidth,
    );
  }

  factory CustomButtonParams.secondary({
    required String text,
    VoidCallback? onPressed,
  }) {
    return CustomButtonParams(
      text: text,
      textStyle: StylesConstant.ts16w500cWhite,
      onPressed: onPressed,
    );
  }

  factory CustomButtonParams.primaryUnselected({
    required String text,
    VoidCallback? onPressed,
  }) {
    return CustomButtonParams(
      text: text,
      onPressed: onPressed,
      textStyle:
          StylesConstant.ts16w500.copyWith(color: ColorConstant.kFF363636),
      backgroundColor: ColorConstant.kFF858585,
    );
  }

  final double? height;
  final double? width;
  final String text;
  final VoidCallback? onPressed;
  final EdgeInsets? margin;
  final EdgeInsets? padding;
  final List<BoxShadow>? boxShadow;
  final double radius;
  final TextStyle? textStyle;
  final Color? backgroundColor;
  final bool wrapWidth;

  CustomButtonParams copyWith({
    double? height,
    double? width,
    String? text,
    VoidCallback? onPressed,
    EdgeInsets? margin,
    EdgeInsets? padding,
    List<BoxShadow>? boxShadow,
    double? radius,
    TextStyle? textStyle,
    Color? backgroundColor,
    bool? wrapWidth,
  }) =>
      CustomButtonParams(
        height: height ?? this.height,
        width: width ?? this.width,
        text: text ?? this.text,
        onPressed: onPressed ?? this.onPressed,
        margin: margin ?? this.margin,
        padding: padding ?? this.padding,
        boxShadow: boxShadow ?? this.boxShadow,
        radius: radius ?? this.radius,
        textStyle: textStyle ?? this.textStyle,
        backgroundColor: backgroundColor ?? this.backgroundColor,
        wrapWidth: wrapWidth ?? this.wrapWidth,
      );
}

class CustomButton extends StatelessWidget {
  const CustomButton({
    Key? key,
    required this.params,
  }) : super(key: key);

  final CustomButtonParams params;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: params.onPressed,
      child: Container(
        margin: params.margin,
        padding: params.padding ??
            const EdgeInsets.symmetric(
              vertical: 15,
              horizontal: 20,
            ),
        height: params.height == null ? null : params.height!,
        width: params.width == null ? null : params.width!,
        decoration: BoxDecoration(
          boxShadow: params.boxShadow,
          borderRadius: BorderRadius.circular(params.radius),
          color: params.backgroundColor ?? ColorConstant.kFF5D5FEF,
        ),
        child: params.wrapWidth
            ? _text()
            : Center(
                child: _text(),
              ),
      ),
    );
  }

  Text _text() {
    return Text(
      params.text,
      style: params.textStyle,
    );
  }
}

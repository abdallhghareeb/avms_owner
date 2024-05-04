import 'package:avms/core/utils/app_color.dart';
import 'package:avms/core/utils/app_conts.dart';
import 'package:avms/core/utils/app_size.dart';
import 'package:avms/core/utils/font_size.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class MainButton extends StatelessWidget {
  final String text;
  final Function()? onPressed;
  final bool isOutline;
  final double? bR;
  final double? w;
  final double? h;
  final Color? color;
  final Decoration? decoration;
  final FontWeight? fontWeight;

  const MainButton(
      {Key? key,
      this.w,
      this.h,
      required this.text,
      required this.onPressed,
      this.isOutline = false,
      this.bR,
      this.color,
      this.fontWeight,
      this.decoration})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: w ?? SizeConfig.screenWidth,
      // width: w ?? SizeConfig.screenWidth * 0.9,
      height: h ?? SizeConfig.screenHeight * 0.042,
      margin: EdgeInsetsDirectional.symmetric(horizontal: smallPadding),
      decoration: decoration ??
          BoxDecoration(
            border: Border.all(
              color: color ?? AppColors.primaryColor,
            ),
            color: color ??
                (isOutline ? AppColors.secondaryColor : AppColors.primaryColor),
            borderRadius: BorderRadius.circular(bR ?? 40.0),
          ),
      child: MaterialButton(
        onPressed: onPressed,
        textColor:
            isOutline ? AppColors.primaryColor : AppColors.secondaryColor,
        child: Text(
          text,
          style: TextStyle(
            fontSize: FontSize.s18,
            fontWeight: fontWeight ?? FontWeight.w500,
          ),
        ).tr(),
      ),
    );
  }
}

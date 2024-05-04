import 'package:avms/core/utils/app_color.dart';
import 'package:avms/core/utils/app_conts.dart';
import 'package:avms/core/utils/app_size.dart';
import 'package:avms/core/utils/app_spaces.dart';
import 'package:avms/core/utils/app_values.dart';
import 'package:avms/core/utils/font_size.dart';
import 'package:avms/features/home/presentation/cubit/home_cubit.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

class CarouselCard extends StatefulWidget {
  final String itemTitle;
  final int itemCount;
  final Color itemColor;
  final IconData itemIcon;

  const CarouselCard({
    super.key,
    required this.itemTitle,
    required this.itemCount,
    required this.itemColor,
    required this.itemIcon,
  });

  @override
  State<CarouselCard> createState() => _CarouselCardState();
}

class _CarouselCardState extends State<CarouselCard> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        return Container(
            width: SizeConfig.screenWidth,
            height: SizeConfig.screenHeight,
            decoration: BoxDecoration(
              color: widget.itemColor,
              borderRadius: BorderRadius.all(
                Radius.circular(
                  borderRadius,
                ),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(mainPadding),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    flex: 3,
                    child: Container(
                      width: double.infinity,
                      height: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColors.offWhite,
                        borderRadius: BorderRadius.all(
                          Radius.circular(
                            borderRadius,
                          ),
                        ),
                      ),
                      child: Icon(
                        widget.itemIcon,
                        size: AppSize.s35,
                      ),
                    ),
                  ),
                  Spacer(
                    flex: 1,
                  ),
                  Expanded(
                    flex: 6,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.itemTitle,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: FontSize.s20,
                            color: AppColors.offWhite,
                          ),
                        ),
                        AppSpaces.vSpace10,
                        Text(
                          widget.itemCount.toString(),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: FontSize.s20,
                            color: AppColors.offWhite,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ));
      },
    );
  }
}

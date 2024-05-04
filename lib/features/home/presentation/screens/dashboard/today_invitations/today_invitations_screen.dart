import 'package:avms/core/utils/app_color.dart';
import 'package:avms/core/utils/app_conts.dart';
import 'package:avms/features/home/presentation/cubit/home_cubit.dart';
import 'package:avms/helpers/Localization.dart';
import 'package:avms/widgets/item_card.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:shimmer/shimmer.dart';

class TodayInvitationsScreen extends StatefulWidget {
  static const route = 'TodayInvitations';

  const TodayInvitationsScreen({super.key});

  @override
  State<TodayInvitationsScreen> createState() => _TodayInvitationsScreenState();
}

class _TodayInvitationsScreenState extends State<TodayInvitationsScreen> {
  @override
  Widget build(BuildContext context) {
    HomeCubit homeCubit = HomeCubit.get(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "todayInvitations",
        ).tr(),
      ),
      body: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          return Padding(
            padding:
                const EdgeInsetsDirectional.symmetric(vertical: smallPadding),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: ConditionalBuilder(
                    condition: state is GetInvitationLoadingState,
                    builder: (BuildContext context) => Shimmer.fromColors(
                      enabled: true,
                      baseColor: Colors.grey.shade400,
                      highlightColor: Colors.grey.shade100,
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: BouncingScrollPhysics(),
                        itemBuilder: (context, index) {},
                        itemCount: 6,
                      ),
                    ),
                    fallback: (BuildContext context) => ConditionalBuilder(
                      condition: homeCubit.todayInvitations.isNotEmpty ||
                          homeCubit.todayInvitations.length != 0,
                      builder: (context) => ListView.builder(
                        shrinkWrap: true,
                        physics: BouncingScrollPhysics(),
                        itemBuilder: (context, index) => ItemCard(
                          inv: homeCubit.todayInvitations[index],
                        ),
                        itemCount: homeCubit.todayInvitations.length,
                      ),
                      fallback: (context) => Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Lottie.asset(
                                "assets/images/animations/no_data.json"),
                            Text(
                              "No Data Found",
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}

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

// Define a screen for displaying upcoming invitations
class UpComingInvitationsScreen extends StatefulWidget {
  // Define a route name for navigation
  static const route = 'UpComingInvitationsScreen';

  // Constructor for the screen
  const UpComingInvitationsScreen({Key? key}) : super(key: key);

  @override
  State<UpComingInvitationsScreen> createState() =>
      _UpComingInvitationsScreenState();
}

// State class for the UpComingInvitationsScreen
class _UpComingInvitationsScreenState extends State<UpComingInvitationsScreen> {
  @override
  Widget build(BuildContext context) {
    // Get the instance of HomeCubit using the context
    HomeCubit homeCubit = HomeCubit.get(context);

    // Scaffold widget is the basic structure of the screen
    return Scaffold(
      // AppBar for the screen with a localized title
      appBar: AppBar(
        title: Text(
          "upcomingInvitations",
        ).tr(),
      ),
      // Body of the screen
      body: BlocBuilder<HomeCubit, HomeState>(
        // Build the UI based on the state of the HomeCubit
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsetsDirectional.symmetric(
                vertical: smallPadding),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                // Expanded widget to take all available vertical space
                Expanded(
                  child: ConditionalBuilder(
                    // Check if the state is loading
                    condition: state is GetInvitationLoadingState,
                    // If loading, show a shimmer effect
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
                    // If not loading, check if there are upcoming invitations to display
                    fallback: (BuildContext context) => ConditionalBuilder(
                      // Check if there are upcoming invitations
                      condition: homeCubit.upcomingInvitations.isNotEmpty ||
                          homeCubit.upcomingInvitations.length != 0,
                      // If there are, display the list of upcoming invitations
                      builder: (context) => ListView.builder(
                        shrinkWrap: true,
                        physics: BouncingScrollPhysics(),
                        itemBuilder: (context, index) => ItemCard(
                          // Pass data to the ItemCard widget
                          inv: homeCubit.upcomingInvitations[index],
                          ),
                        itemCount: homeCubit.upcomingInvitations.length,
                      ),
                      // If there are no upcoming invitations, show a message and animation
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

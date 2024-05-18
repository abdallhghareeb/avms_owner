import 'dart:developer';
import 'package:avms/core/utils/app_color.dart';
import 'package:avms/core/utils/app_conts.dart';
import 'package:avms/core/utils/app_size.dart';
import 'package:avms/core/utils/app_spaces.dart';
import 'package:avms/core/utils/config.dart';
import 'package:avms/core/utils/font_size.dart';
import 'package:avms/features/home/data/models/visit_model.dart';
import 'package:avms/features/home/domain/entities/visit.dart';
import 'package:avms/features/home/presentation/cubit/home_cubit.dart';
import 'package:avms/features/home/presentation/screens/dashboard/expired_invitations/expired_invitations_screen.dart';
import 'package:avms/features/home/presentation/screens/dashboard/today_invitations/today_invitations_screen.dart';
import 'package:avms/features/home/presentation/screens/dashboard/upcoming_invitations/upcoming_invitation_screen.dart';
import 'package:avms/helpers/Localization.dart';
import 'package:avms/widgets/carousel_card.dart';
import 'package:avms/widgets/item_card.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:shimmer/shimmer.dart';

// Define a screen for the dashboard
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

// State class for the DashboardScreen
class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Get the instance of HomeCubit using the context
    HomeCubit homeCubit = HomeCubit.get(context);

    return Scaffold(
      // Body of the screen
      body: BlocConsumer<HomeCubit, HomeState>(
        listener: (context, state) async {
          // Listener for state changes
          if (state is CreateInvitationSuccessState) {
            // Handle success state
            // HomeCubit.get(context).changeNavBar(index: 0);
            setState(() {});
          }
          if (state is GetInvitationByIdLoadingState) {
            // Handle loading state for getting invitation by ID
          }
          if (state is GetInvitationByIdSuccess) {
            // Handle success state for getting invitation by ID
          }
          if (state is GetInvitationByIdError) {
            // Handle error state for getting invitation by ID
          }
        },
        builder: (context, state) {
          // Build the UI based on the state of the HomeCubit
          return SafeArea(
            child: Padding(
              padding: const EdgeInsetsDirectional.symmetric(
                vertical: smallPadding,
              ),
              child: RefreshIndicator(
                displacement: 250,
                backgroundColor: AppColors.offWhite,
                color: AppColors.primaryColor,
                strokeWidth: 3,
                triggerMode: RefreshIndicatorTriggerMode.onEdge,
                onRefresh: () async {
                  // Refresh the data when pulling down
                  HomeCubit.get(context).loadDashData();
                },
                child: Column(
                  children: [
                    // Conditional builder for handling loading state or no data state
                    ConditionalBuilder(
                      condition: state is GetDashInfoLoadingState ||
                          HomeCubit.get(context).info == null,
                      builder: (context) => Shimmer.fromColors(
                        // Shimmer effect for loading state
                        enabled: true,
                        baseColor: Colors.grey.shade400,
                        highlightColor: Colors.grey.shade100,
                        child: CarouselSlider(
                          // Carousel for displaying cards with information
                          options: CarouselOptions(
                            height: SizeConfig.screenHeight * 0.16,
                            viewportFraction: 0.8,
                            initialPage: 0,
                            enableInfiniteScroll: true,
                            reverse: false,
                            autoPlay: true,
                            autoPlayInterval: Duration(seconds: 3),
                            autoPlayAnimationDuration:
                                Duration(milliseconds: 800),
                            autoPlayCurve: Curves.fastOutSlowIn,
                            enlargeCenterPage: true,
                            enlargeFactor: 0.17,
                          ),
                          items: [
                            // Placeholder cards for loading state
                            CarouselCard(
                              itemTitle: "Loading..",
                              itemCount: 0,
                              itemColor: AppColors.appColor,
                              itemIcon: Icons.class_,
                            ),
                            CarouselCard(
                              itemTitle: "Loading..",
                              itemCount: 0,
                              itemColor: AppColors.appColor,
                              itemIcon: Icons.expand,
                            ),
                            CarouselCard(
                              itemTitle: "Loading..",
                              itemCount: 0,
                              itemColor: AppColors.appColor,
                              itemIcon: Icons.access_time_filled_rounded,
                            ),
                          ],
                        ),
                      ),
                      // Fallback for when data is available
                      fallback: (context) => CarouselSlider(
                        // Carousel for displaying cards with information
                        options: CarouselOptions(
                          height: SizeConfig.screenHeight * 0.16,
                          viewportFraction: 0.8,
                          initialPage: 0,
                          enableInfiniteScroll: true,
                          reverse: false,
                          autoPlay: true,
                          autoPlayInterval: Duration(seconds: 3),
                          autoPlayAnimationDuration:
                              Duration(milliseconds: 800),
                          autoPlayCurve: Curves.fastOutSlowIn,
                          enlargeCenterPage: true,
                          enlargeFactor: 0.17,
                        ),
                        items: [
                          // GestureDetector for tapping on the card to navigate to a specific screen
                          GestureDetector(
                            onTap: () =>
                                PersistentNavBarNavigator.pushNewScreen(
                              context,
                              screen: TodayInvitationsScreen(),
                              withNavBar: true,
                              pageTransitionAnimation:
                                  PageTransitionAnimation.cupertino,
                            ),
                            child: CarouselCard(
                              itemTitle: "today Invitations",
                              itemCount:
                                  HomeCubit.get(context).info!.totalTodayVisits,
                              itemColor: AppColors.appColor,
                              itemIcon: Icons.class_,
                            ),
                          ),
                          GestureDetector(
                            onTap: () =>
                                PersistentNavBarNavigator.pushNewScreen(
                              context,
                              screen: UpComingInvitationsScreen(),
                              withNavBar: true,
                              pageTransitionAnimation:
                                  PageTransitionAnimation.cupertino,
                            ),
                            child: CarouselCard(
                              itemTitle: "Upcoming Invitations",
                              itemCount: HomeCubit.get(context)
                                  .info!
                                  .totalUpcomingVisits,
                              itemColor: AppColors.appColor,
                              itemIcon: Icons.scale,
                            ),
                          ),
                          GestureDetector(
                            onTap: () =>
                                PersistentNavBarNavigator.pushNewScreen(
                              context,
                              screen: ExpiredInvitationsScreen(),
                              withNavBar: true,
                              pageTransitionAnimation:
                                  PageTransitionAnimation.cupertino,
                            ),
                            child: CarouselCard(
                              itemTitle: "Expired Invitations",
                              itemCount: HomeCubit.get(context)
                                      .info
                                      ?.totalExpiredVisits ??
                                  0,
                              itemColor: AppColors.appColor,
                              itemIcon: Icons.access_time_filled_rounded,
                            ),
                          ),
                        ],
                      ),
                    ),
                    AppSpaces.vSpace20,
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: midPadding),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                           Config.Localization['recentlyVisits'],
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: FontSize.s20,
                                fontWeight: FontWeight.bold),
                          ),
                          TextButton(
                            onPressed: () {
                              // Navigate to view all recently visited screen
                              HomeCubit.get(context).changeNavBar(index: 2);
                            },
                            child: Text(
                              Config.Localization['viewAll'],
                              style: TextStyle(
                                color: AppColors.appColor,
                                fontSize: FontSize.s20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Expanded widget for taking all available vertical space
                    Expanded(
                      child: ConditionalBuilder(
                        condition: state is GetInvitationLoadingState,
                        builder: (BuildContext context) => Shimmer.fromColors(
                          // Shimmer effect for loading state
                          enabled: true,
                          baseColor: Colors.grey.shade400,
                          highlightColor: Colors.grey.shade100,
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: BouncingScrollPhysics(),
                            itemBuilder: (context, index) => ItemCard(
                              // Placeholder data for loading state
                              inv: VisitModel(
                                id: "id",
                                fullName: "",
                                registrationDate: DateTime.now().toString(),
                                documentId: "",
                                cardNumber: "",
                                areaName: "",
                                expiryDate: "",
                                qrLink: "",
                                accessInDate: "",
                                accessOutDate: "",
                                documentImage: "",
                                isSuccess: true,
                                status: "",
                              ),
                            ),
                            itemCount: 6,
                          ),
                        ),
                        // Fallback for when data is available
                        fallback: (BuildContext context) => ConditionalBuilder(
                          condition: homeCubit.todayInvitations.isNotEmpty,
                          builder: (BuildContext context) => ListView.builder(
                            shrinkWrap: true,
                            physics: BouncingScrollPhysics(),
                            itemBuilder: (context, index) => ItemCard(
                              // Pass data to the ItemCard widget
                              inv: homeCubit.todayInvitations[index],
                            ),
                            itemCount: homeCubit.todayInvitations.length,
                          ),
                          // Fallback for when there is no data
                          fallback: (BuildContext context) => Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
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
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

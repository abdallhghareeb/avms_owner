// import 'package:avms/core/utils/app_color.dart';
// import 'package:avms/core/utils/app_conts.dart';
// import 'package:avms/core/utils/app_values.dart';
// import 'package:avms/features/home/presentation/cubit/home_cubit.dart';
// import 'package:dot_navigation_bar/dot_navigation_bar.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
//
// class AppBottomNavigationBar extends StatelessWidget {
//   const AppBottomNavigationBar({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<HomeCubit, HomeState>(
//       builder: (context, state) {
//         HomeCubit cubit = HomeCubit.get(context);
//         return Padding(
//           padding: EdgeInsets.only(bottom: AppHeight.h10),
//           child: DotNavigationBar(
//             curve: Curves.easeInOutCubicEmphasized,
//             duration: Duration(milliseconds: 300),
//             boxShadow: shadow,
//             currentIndex: cubit.currentNavIndex,
//             onTap: (index) {
//               cubit.changeNavBar(index: index);
//             },
//             marginR: EdgeInsets.symmetric(horizontal: AppWidth.w20)
//                 .add(EdgeInsets.only(bottom: AppHeight.h2,),),
//             dotIndicatorColor: AppColors.appColor,
//             selectedItemColor: AppColors.appColor,
//             unselectedItemColor: AppColors.grey.withOpacity(0.7),
//             backgroundColor: AppColors.offWhite,
//             itemPadding: EdgeInsets.only(
//               left: AppWidth.w10,
//               right: AppWidth.w10,
//               top: AppHeight.h5,
//             ),
//             // enableFloatingNavBar: true,
//             borderRadius: AppSize.s50,
//             items: cubit.navBarListItems,
//           ),
//         );
//       },
//     );
//   }
// }

import 'package:avms/core/utils/app_color.dart';
import 'package:avms/core/utils/app_conts.dart';
import 'package:avms/core/utils/config.dart';
import 'package:avms/features/home/presentation/cubit/home_cubit.dart';
import 'package:avms/features/home/presentation/screens/more_setting/appearance/cubit/lang_cubit.dart';
import 'package:avms/features/home/presentation/screens/more_setting/appearance/cubit/lang_state.dart';
import 'package:avms/helpers/Localization.dart';
import 'package:avms/widgets/item_card.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Define a screen for displaying all invitations
class InvitationsScreen extends StatefulWidget {
  // Define a route name for navigation
  static final route = "Invitations";

  // Constructor for the screen
  const InvitationsScreen({Key? key}) : super(key: key);

  @override
  State<InvitationsScreen> createState() => _InvitationsScreenState();
}

// State class for the InvitationsScreen
class _InvitationsScreenState extends State<InvitationsScreen> {
  @override
  Widget build(BuildContext context) {
    // Scaffold widget is the basic structure of the screen
   return BlocBuilder<LangCubit,LangState>(builder: (context,state){
     return  Scaffold(
       // AppBar for the screen with a title
       appBar: AppBar(
         title: Text(
           Config.Localization['Invitations'],
         ),
         // Uncomment the following line if you want to set a specific toolbar height
         // toolbarHeight: 56,
       ),
       // Body of the screen
       body: BlocBuilder<HomeCubit, HomeState>(
         // Build the UI based on the state of the HomeCubit
         builder: (context, state) {
           // Get the instance of HomeCubit using the context
           HomeCubit homeCubit = HomeCubit.get(context);

           return Padding(
             padding: const EdgeInsetsDirectional.symmetric(
               vertical: smallPadding,
             ),
             child: Column(
               children: [

                 // Expanded widget to take all available vertical space
                 Expanded(
                   child: ListView.builder(
                     shrinkWrap: true,
                     physics: BouncingScrollPhysics(),
                     itemBuilder: (context, index) => ItemCard(
                       // Pass data to the ItemCard widget
                       inv: homeCubit.allInvitations[index],
                     ),
                     itemCount: homeCubit.allInvitations.length,
                   ),
                 )
               ],
             ),
           );
         },
       ),
     );
   });
  }
}

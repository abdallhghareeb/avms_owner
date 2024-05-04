import 'package:avms/core/utils/app_color.dart';
import 'package:avms/core/utils/app_conts.dart';
import 'package:avms/features/home/data/models/visit_model.dart';
import 'package:avms/features/home/domain/entities/visit.dart';
import 'package:avms/features/home/presentation/cubit/home_cubit.dart';
import 'package:avms/helpers/Localization.dart';
import 'package:avms/widgets/alert_dialog.dart';
import 'package:avms/widgets/success_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import '../core/utils/font_size.dart';

const double KIconSize = 20.0;

class ItemCard extends StatefulWidget {
  final Visit inv;

  // final String id, title, date, stateTitle;
  final void Function()? onStateAction;

  // final dynamic qrLink;
  // final Color actionColor;

  const ItemCard({
    required this.inv,
    this.onStateAction,
  });

  @override
  State<ItemCard> createState() => _ItemCardState();
}

class _ItemCardState extends State<ItemCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => widget.inv.status == "Active"
          ? showQrDialog(
              context: context,
              qrImage: widget.inv.qrLink ?? '',
              buttonName: "Cancel Invitation",
              onPressed: () {
                showInformationDialog(
                  context: context,
                  title: "Cancel Invitation",
                  content: "Do You Want to Cancel Invitation?",
                  onOkPressed: () {
                    HomeCubit.get(context).cancelInvitation(
                      canceledId: widget.inv.id!,
                    );
                  },
                );

                Navigator.pop(context);
                // (context as Element).rebuild();
              },
            )
          : null,
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: midPadding,
          vertical: smallPadding,
        ),
        padding: const EdgeInsets.symmetric(
          vertical: mainPadding,
          horizontal: mainPadding,
        ),
        decoration: BoxDecoration(
          color: invitationBackground(),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Banner(
          message: widget.inv.status.toString(),
          // "success",
          // color: ,
          location: BannerLocation.bottomEnd,
          textDirection: ui.TextDirection.rtl,
          layoutDirection: ui.TextDirection.ltr,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.inv.fullName!,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: FontSize.s20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(width: 26),
              Text(
                DateFormat(
                  'dd MMM, yyy h:mm a',
                  Localization.columnLocale(context),
                ).format(
                  DateTime.parse(
                    widget.inv.registrationDate ?? DateTime.now().toString(),
                  ),
                ),
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: FontSize.s16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color invitationBackground() {
    switch (widget.inv.status) {
      case "Active":
        return AppColors.activeStatus;
      case "Success":
        return AppColors.successStatus;
      case "Expired":
        return AppColors.expiredStatus;
      case "Canceld":
        return AppColors.canceledStatus;
      case "Blocked":
        return AppColors.blockedStatus;
      default:
        return AppColors.secondaryColor;
    }
  }
}

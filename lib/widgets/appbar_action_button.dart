import 'package:avms/core/utils/app_color.dart';
import 'package:avms/core/utils/app_conts.dart';
import 'package:flutter/material.dart';


class AppBarActionButton extends StatelessWidget {
  final String imageUrl;
  final VoidCallback? onTap;

  const AppBarActionButton({
    required this.onTap,
    required this.imageUrl,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 38,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(KBorderRadius),
        child: Ink(
          width: 46,
          height: 38,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
              color:
                  onTap == null ? Colors.white.withOpacity(0.5) : Colors.white,
              borderRadius: BorderRadius.circular(KBorderRadius)),
          child: Image.asset(imageUrl),
        ),
      ),
    );
  }
}

class AppBarActionButtonWithBadge extends StatelessWidget {
  final String imageUrl;
  final int? badgeNumber;
  final bool enabled;
  final VoidCallback? onTap;

  const AppBarActionButtonWithBadge(
      {required this.onTap,
      required this.imageUrl,
      Key? key,
      this.badgeNumber,
      enabled})
      : enabled = enabled ?? true,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topRight,
        children: [
          SizedBox(
            height: 38,
            child: InkWell(
              onTap: enabled ? onTap : null,
              borderRadius: BorderRadius.circular(KBorderRadius),
              child: Ink(
                width: 46,
                height: 38,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: onTap == null
                      ? Colors.white.withOpacity(0.5)
                      : Colors.white,
                  borderRadius: BorderRadius.circular(
                    KBorderRadius,
                  ),
                ),
                child: Image.asset(imageUrl),
              ),
            ),
          ),
          if (badgeNumber != null && badgeNumber != 0)
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  margin: const EdgeInsets.fromLTRB(8, 0, 0, 10),
                  padding: const EdgeInsets.all(1),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primaryColor,
                  ),
                  constraints:
                      const BoxConstraints(minWidth: 20, minHeight: 20),
                  child: Text(
                    '$badgeNumber',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            )
        ]);
  }
}

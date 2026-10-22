import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

extension NavigationContext on BuildContext {
  get pop => Navigator.pop(this);

  set popUntil(String page) => Navigator.popUntil(this, (route) {
        return route.settings.name == page;
      });

  set push(Widget page) => PersistentNavBarNavigator.pushNewScreen(
        this,
        screen: page,
        withNavBar: true,
        pageTransitionAnimation: PageTransitionAnimation.cupertino,
      );

  set pushR(String page) => Navigator.pushReplacementNamed(this, page);
}

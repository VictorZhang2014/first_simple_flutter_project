/*
 * Navigate to other page without animation in CupertinoPageRoute
 */

import 'package:flutter/cupertino.dart';

class CupertinoPageRouteWithoutAnimation<T> extends CupertinoPageRoute<T> {
  CupertinoPageRouteWithoutAnimation({
    required WidgetBuilder builder,
    RouteSettings? settings,
    bool maintainState = true,
    bool fullscreenDialog = false,
  }) : super(
            builder: builder,
            maintainState: maintainState,
            settings: settings,
            fullscreenDialog: fullscreenDialog);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return child;
  }
}

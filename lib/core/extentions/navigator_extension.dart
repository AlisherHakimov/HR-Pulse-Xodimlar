import 'package:flutter/cupertino.dart';

extension NavigatorExtension on State {
  Future<dynamic> push(Widget page, {bool? rootNavigator, bool? maintainState}) {
    if (page is StatefulWidget || page is StatelessWidget) {
      return Navigator.of(context, rootNavigator: rootNavigator ?? true).push(
        CupertinoPageRoute(
          builder: (c) => page,
          maintainState: maintainState??false,

          settings: RouteSettings(
            name: "${page.runtimeType}",
          ),
        ),
      );
    } else {
      throw Exception(["Widget is not stfull or stless"]);
    }
  }

  Future<dynamic> pushNoTranzition(Widget page, {bool? rootNavigator}) {
    if (page is StatefulWidget || page is StatelessWidget) {
      return Navigator.of(context, rootNavigator: rootNavigator ?? true).push(
        CupertinoPageRoute(
          builder: (c) => page,
          settings: RouteSettings(
            name: "${page.runtimeType}",
          ),
        ),
      );
    } else {
      throw Exception(["Widget is not stfull or stless"]);
    }
  }

  void pushIfPageNotExist(Widget page, {bool? rootNavigator}) {
    if (page is StatefulWidget || page is StatelessWidget) {
      // ModalRoute.of(context).settings.name
      Navigator.of(context, rootNavigator: rootNavigator ?? true).push(
        CupertinoPageRoute(
          builder: (c) => page,
          settings: RouteSettings(
            name: "${page.runtimeType}",
          ),
        ),
      );
    } else {
      throw Exception(["Widget is not stfull or stless"]);
    }
  }

  void pushReplace(Widget page) {
    if (page is StatefulWidget || page is StatelessWidget) {
      Navigator.pop(context);
      Navigator.push(
        this.context,
        CupertinoPageRoute(
          builder: (c) => page,
          settings: RouteSettings(
            name: "${page.runtimeType}",
          ),
        ),
      );
    } else {
      throw Exception(["Widget is not stfull or stless"]);
    }
  }

  Future pushAndRemoveAll(Widget page) {
    if (page is StatefulWidget || page is StatelessWidget) {
      return Navigator.pushAndRemoveUntil(
        context,
        CupertinoPageRoute(
            builder: (c) => page,
            settings: RouteSettings(name: "${page.runtimeType}")),
        (route) => false,
      );
    } else {
      throw Exception(["Widget is not stfull or stless"]);
    }
  }

  void popUntilWithName(Widget page) {
    if (page is StatefulWidget || page is StatelessWidget) {
      Navigator.popUntil(context, ModalRoute.withName("${page.runtimeType}"));
    } else {
      throw Exception(["Widget is not stfull or stless"]);
    }
  }

  void pop({dynamic result}) => Navigator.pop(context, result);
}

extension ContextExtension on BuildContext {
  Future push(Widget page, {bool? rootNavigator, bool? maintainState}) {
    if (page is StatefulWidget || page is StatelessWidget) {
      return Navigator.of(this, rootNavigator: rootNavigator ?? true).push(
        CupertinoPageRoute(
          builder: (c) => page,
          maintainState: maintainState??true,
          settings: RouteSettings(
            name: "${page.runtimeType}",
          ),
        ),
      );
    } else {
      throw Exception(["Widget is not stfull or stless"]);
    }
  }

  Future pushReplace(Widget page, {bool? rootNavigator}) {
    if (page is StatefulWidget || page is StatelessWidget) {
      Navigator.pop(this);
      return Navigator.of(this, rootNavigator: rootNavigator ?? true).push(
        CupertinoPageRoute(
          builder: (c) => page,
          settings: RouteSettings(
            name: "${page}",
          ),
        ),
      );
    } else {
      throw Exception(["Widget is not stfull or stless"]);
    }
  }

  Future pushAndRemoveAll(Widget page, {bool?rootNavigator}) {
    if (page is StatefulWidget || page is StatelessWidget) {
      return Navigator.of(this, rootNavigator: rootNavigator ?? true).pushAndRemoveUntil(

        CupertinoPageRoute(
            builder: (c) => page,
            settings: RouteSettings(name: "${page.runtimeType}")),
        (route) => false,
      );
    } else {
      throw Exception(["Widget is not stfull or stless"]);
    }
  }

  void popUntilWithName(Widget page) {
    if (page is StatefulWidget || page is StatelessWidget) {
      Navigator.popUntil(this, ModalRoute.withName("${page.runtimeType}"));
    } else {
      throw Exception(["Widget is not stfull or stless"]);
    }
  }

  void pop({dynamic result}) => Navigator.pop(this, result);
}

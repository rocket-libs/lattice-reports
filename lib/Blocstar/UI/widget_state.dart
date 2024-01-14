import 'package:blocstar/BlocstarContextBase.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../logic_base.dart';
import 'blocstar_widget_state.dart';

abstract class WidgetState<TWidget extends StatefulWidget,
        TLogic extends LogicBase<BlocstarContextBase>>
    extends BlocStarWidgetState<TWidget, TLogic> {
  bool isBusy = false;

  @override
  void initState() {
    logic.runWrappedAsync = (fn) async {
      try {
        setState(() {
          isBusy = true;
        });
        return await fn();
      } finally {
        setState(() {
          isBusy = false;
        });
      }
    };
    logic.onInitializedAsync = () async {
      await onLogicInitializedAsync();
    };
    super.initState();
  }

  double get usableHeight {
    final mediaQuery = MediaQuery.of(context);
    const appBarHeight = kToolbarHeight;
    final viewPortHeight = mediaQuery.size.height - mediaQuery.padding.top;
    return viewPortHeight - appBarHeight;
  }

  Future<void> onLogicInitializedAsync() async {}

  Widget buildRootWidget(BuildContext context);

  @override
  Widget get busyContent => Container();

  @override
  Widget get mainContent => buildRootWidget(context);

  Future<void> onFirstBuildAsync() async {}

  popToRoot() {
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  bool get isPotraitMode =>
      MediaQuery.of(context).orientation == Orientation.portrait;

  rotateScreen() {
    if (MediaQuery.of(context).orientation == Orientation.portrait) {
      SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
    } else {
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    }
    setState(() {}); // Force rebuild
  }

  bool get isLargeScreen {
    return MediaQuery.of(context).size.width > 600;
  }

  bool get isLandScapeMode =>
      MediaQuery.of(context).orientation == Orientation.landscape;

  @override
  void onFirstBuild() {
    Future.sync(() => onFirstBuildAsync());
  }
}

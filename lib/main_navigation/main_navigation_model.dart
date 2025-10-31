import '/flutter_flow/flutter_flow_util.dart';
import 'main_navigation_widget.dart' show MainNavigationWidget;
import 'package:flutter/material.dart';

class MainNavigationModel extends FlutterFlowModel<MainNavigationWidget> {
  /// State field for bottom navigation
  int currentPageIndex = 0;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}

  /// Update current page index
  void updatePageIndex(int index) {
    currentPageIndex = index;
  }
}

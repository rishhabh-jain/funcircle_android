import '/flutter_flow/flutter_flow_util.dart';
import 'settings_widget.dart' show SettingsScreenWidget;
import 'package:flutter/material.dart';
import '../../models/user_settings.dart';

class SettingsModel extends FlutterFlowModel<SettingsScreenWidget> {
  ///  Local state fields for this page.

  UserSettings? userSettings;
  bool isLoading = true;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}

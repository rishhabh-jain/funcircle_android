import '/flutter_flow/flutter_flow_util.dart';
import 'my_profile_widget.dart' show MyProfileWidget;
import 'package:flutter/material.dart';
import '/backend/supabase/database/tables/users.dart';
import '../../models/user_stats.dart';

class MyProfileModel extends FlutterFlowModel<MyProfileWidget> {
  ///  Local state fields for this page.

  UsersRow? userProfile;
  UserStats? userStats;
  List<String> userTags = [];
  bool isLoading = true;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}

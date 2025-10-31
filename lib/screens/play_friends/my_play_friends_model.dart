import '/flutter_flow/flutter_flow_util.dart';
import 'my_play_friends_widget.dart' show MyPlayFriendsWidget;
import 'package:flutter/material.dart';
import '../../models/play_friend.dart';

class MyPlayFriendsModel extends FlutterFlowModel<MyPlayFriendsWidget> {
  ///  Local state fields for this page.

  List<PlayFriend> allFriends = [];
  List<PlayFriend> filteredFriends = [];
  bool isLoading = true;
  String searchQuery = '';
  String sportFilter = 'all';
  bool favoritesOnly = false;

  // State field(s) for search TextField.
  FocusNode? searchFocusNode;
  TextEditingController? searchController;

  @override
  void initState(BuildContext context) {
    searchController = TextEditingController();
  }

  @override
  void dispose() {
    searchFocusNode?.dispose();
    searchController?.dispose();
  }
}

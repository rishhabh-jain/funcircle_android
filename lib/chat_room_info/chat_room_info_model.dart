import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'chat_room_info_widget.dart' show ChatRoomInfoWidget;
import 'package:flutter/material.dart';

class ChatRoomInfoModel extends FlutterFlowModel<ChatRoomInfoWidget> {
  ///  State fields for stateful widgets in this page.

  // Room data
  ChatRoomsRow? chatRoom;
  List<Map<String, dynamic>> roomMembers = [];
  bool isLoadingRoom = true;
  bool isLoadingMembers = true;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}

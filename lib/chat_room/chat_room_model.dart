import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'chat_room_widget.dart' show ChatRoomWidget;
import 'package:flutter/material.dart';

class ChatRoomModel extends FlutterFlowModel<ChatRoomWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for message input widget.
  FocusNode? messageFieldFocusNode;
  TextEditingController? messageController;
  String? Function(BuildContext, String?)? messageControllerValidator;

  // Chat data
  ChatRoomsRow? chatRoom;
  List<ChatMessagesRow> messages = [];
  bool isLoadingRoom = true;
  bool isLoadingMessages = true;
  bool isSendingMessage = false;

  // Realtime subscription
  RealtimeChannel? messageSubscription;

  // Scroll controller for auto-scroll to bottom
  ScrollController? scrollController;

  @override
  void initState(BuildContext context) {
    scrollController = ScrollController();
  }

  @override
  void dispose() {
    messageFieldFocusNode?.dispose();
    messageController?.dispose();
    scrollController?.dispose();
    messageSubscription?.unsubscribe();
  }
}

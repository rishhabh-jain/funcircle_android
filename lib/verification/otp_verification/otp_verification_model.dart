import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_timer.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'otp_verification_widget.dart' show OtpVerificationWidget;
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:flutter/material.dart';

class OtpVerificationModel extends FlutterFlowModel<OtpVerificationWidget> {
  ///  Local state fields for this page.

  bool isloading = false;

  ///  State fields for stateful widgets in this page.

  final formKey = GlobalKey<FormState>();
  // State field(s) for otpverification widget.
  TextEditingController? otpverification;
  FocusNode? otpverificationFocusNode;
  String? Function(BuildContext, String?)? otpverificationValidator;
  String? _otpverificationValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return FFLocalizations.of(context).getText(
        's9n7isrd' /* PIN code is required */,
      );
    }
    if (val.length < 6) {
      return 'Requires 6 characters.';
    }
    return null;
  }

  // State field(s) for Timer widget.
  final timerInitialTimeMs = 30000;
  int timerMilliseconds = 30000;
  String timerValue = StopWatchTimer.getDisplayTime(
    30000,
    hours: false,
    milliSecond: false,
  );
  FlutterFlowTimerController timerController =
      FlutterFlowTimerController(StopWatchTimer(mode: StopWatchMode.countDown));

  // Stores action output result for [Backend Call - API (getUserByUid)] action in Button widget.
  ApiCallResponse? getUserbUserId;
  // Stores action output result for [Backend Call - API (getUserByUid)] action in Button widget.
  ApiCallResponse? getUserbUserId2;

  @override
  void initState(BuildContext context) {
    otpverification = TextEditingController();
    otpverificationValidator = _otpverificationValidator;
  }

  @override
  void dispose() {
    otpverificationFocusNode?.dispose();
    otpverification?.dispose();

    timerController.dispose();
  }
}

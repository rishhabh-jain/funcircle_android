import '/auth/firebase_auth/auth_util.dart';
import '/backend/api_requests/api_calls.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_timer.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/index.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:webviewx_plus/webviewx_plus.dart';
import 'otp_verification_model.dart';
export 'otp_verification_model.dart';

class OtpVerificationWidget extends StatefulWidget {
  const OtpVerificationWidget({
    super.key,
    String? mobilenumber,
    String? type,
    this.name,
    this.email,
  })  : this.mobilenumber = mobilenumber ?? '8888888888',
        this.type = type ?? 'signup';

  final String mobilenumber;
  final String type;
  final String? name;
  final String? email;

  static String routeName = 'OtpVerification';
  static String routePath = '/otpVerification';

  @override
  State<OtpVerificationWidget> createState() => _OtpVerificationWidgetState();
}

class _OtpVerificationWidgetState extends State<OtpVerificationWidget> {
  late OtpVerificationModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => OtpVerificationModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      logFirebaseEvent('OtpVerification_timer');
      _model.timerController.onStartTimer();
    });

    _model.otpverificationFocusNode ??= FocusNode();

    authManager.handlePhoneAuthStateChanges(context);
    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).secondary,
        body: SafeArea(
          top: true,
          child: Align(
            alignment: AlignmentDirectional(0.0, 0.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Align(
                  alignment: AlignmentDirectional(0.0, -1.0),
                  child: Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(12.0, 40.0, 12.0, 0.0),
                    child: Container(
                      decoration: BoxDecoration(),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            FFLocalizations.of(context).getText(
                              'vz0u5omb' /* Verify your number */,
                            ),
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  fontFamily: FlutterFlowTheme.of(context)
                                      .bodyMediumFamily,
                                  color: FlutterFlowTheme.of(context).tertiary,
                                  fontSize: 32.0,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.w600,
                                  useGoogleFonts: !FlutterFlowTheme.of(context)
                                      .bodyMediumIsCustom,
                                ),
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 0.0, 0.0, 20.0),
                            child: RichText(
                              textScaler: MediaQuery.of(context).textScaler,
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: FFLocalizations.of(context).getText(
                                      '9ns36e4b' /* Enter the code that we’ve send... */,
                                    ),
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          fontFamily:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMediumFamily,
                                          color: Color(0xFF4B5768),
                                          fontSize: 16.0,
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.w500,
                                          useGoogleFonts:
                                              !FlutterFlowTheme.of(context)
                                                  .bodyMediumIsCustom,
                                        ),
                                  ),
                                  TextSpan(
                                    text: widget.mobilenumber,
                                    style: TextStyle(
                                      color:
                                          FlutterFlowTheme.of(context).tertiary,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16.0,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                  TextSpan(
                                    text: FFLocalizations.of(context).getText(
                                      'c7cinszg' /*  Change */,
                                    ),
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          fontFamily:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMediumFamily,
                                          color: FlutterFlowTheme.of(context)
                                              .primary,
                                          fontSize: 17.0,
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.w600,
                                          decoration: TextDecoration.underline,
                                          useGoogleFonts:
                                              !FlutterFlowTheme.of(context)
                                                  .bodyMediumIsCustom,
                                        ),
                                    mouseCursor: SystemMouseCursors.click,
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () async {
                                        if (widget.type == 'login') {
                                          logFirebaseEvent(
                                              'RichTextSpan_navigate_to');

                                          context.goNamed(
                                              LoginNewWidget.routeName);
                                        } else {
                                          logFirebaseEvent(
                                              'RichTextSpan_navigate_to');

                                          context.goNamed(
                                              SignupNewWidget.routeName);
                                        }
                                      },
                                  )
                                ],
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      fontFamily: FlutterFlowTheme.of(context)
                                          .bodyMediumFamily,
                                      letterSpacing: 0.0,
                                      useGoogleFonts:
                                          !FlutterFlowTheme.of(context)
                                              .bodyMediumIsCustom,
                                    ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 0.0, 0.0, 20.0),
                            child: Container(
                              decoration: BoxDecoration(),
                              child: Form(
                                key: _model.formKey,
                                autovalidateMode: AutovalidateMode.disabled,
                                child: PinCodeTextField(
                                  autoDisposeControllers: false,
                                  appContext: context,
                                  length: 6,
                                  textStyle: FlutterFlowTheme.of(context)
                                      .bodyLarge
                                      .override(
                                        fontFamily: FlutterFlowTheme.of(context)
                                            .bodyLargeFamily,
                                        color: FlutterFlowTheme.of(context)
                                            .tertiary,
                                        letterSpacing: 0.0,
                                        useGoogleFonts:
                                            !FlutterFlowTheme.of(context)
                                                .bodyLargeIsCustom,
                                      ),
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  enableActiveFill: false,
                                  autoFocus: true,
                                  focusNode: _model.otpverificationFocusNode,
                                  enablePinAutofill: false,
                                  errorTextSpace: 16.0,
                                  showCursor: true,
                                  cursorColor:
                                      FlutterFlowTheme.of(context).primary,
                                  obscureText: false,
                                  hintCharacter: '●',
                                  keyboardType: TextInputType.number,
                                  pinTheme: PinTheme(
                                    fieldHeight: 48.0,
                                    fieldWidth: 51.0,
                                    borderWidth: 1.0,
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(4.0),
                                      bottomRight: Radius.circular(4.0),
                                      topLeft: Radius.circular(4.0),
                                      topRight: Radius.circular(4.0),
                                    ),
                                    shape: PinCodeFieldShape.box,
                                    activeColor: Color(0xFFE7EAEE),
                                    inactiveColor: Color(0xFFE7EAEE),
                                    selectedColor:
                                        FlutterFlowTheme.of(context).primary,
                                  ),
                                  controller: _model.otpverification,
                                  onChanged: (_) {},
                                  autovalidateMode: AutovalidateMode.disabled,
                                  validator: _model.otpverificationValidator
                                      .asValidator(context),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsetsDirectional.fromSTEB(12.0, 25.0, 12.0, 0.0),
                  child: Container(
                    decoration: BoxDecoration(),
                    alignment: AlignmentDirectional(0.0, 0.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Align(
                            alignment: AlignmentDirectional(-1.0, 0.0),
                            child: Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  12.0, 0.0, 0.0, 0.0),
                              child: FlutterFlowTimer(
                                initialTime: _model.timerInitialTimeMs,
                                getDisplayTime: (value) =>
                                    StopWatchTimer.getDisplayTime(
                                  value,
                                  hours: false,
                                  milliSecond: false,
                                ),
                                controller: _model.timerController,
                                onChanged: (value, displayTime, shouldUpdate) {
                                  _model.timerMilliseconds = value;
                                  _model.timerValue = displayTime;
                                  if (shouldUpdate) safeSetState(() {});
                                },
                                textAlign: TextAlign.start,
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      fontFamily: FlutterFlowTheme.of(context)
                                          .bodyMediumFamily,
                                      color:
                                          FlutterFlowTheme.of(context).tertiary,
                                      fontSize: 16.0,
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.w500,
                                      useGoogleFonts:
                                          !FlutterFlowTheme.of(context)
                                              .bodyMediumIsCustom,
                                    ),
                              ),
                            ),
                          ),
                        ),
                        if (_model.timerMilliseconds == 00)
                          FFButtonWidget(
                            onPressed: () async {
                              logFirebaseEvent('Button_auth');
                              final phoneNumberVal =
                                  '+91${widget.mobilenumber}';
                              if (phoneNumberVal.isEmpty ||
                                  !phoneNumberVal.startsWith('+')) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        'Phone Number is required and has to start with +.'),
                                  ),
                                );
                                return;
                              }
                              await authManager.beginPhoneAuth(
                                context: context,
                                phoneNumber: phoneNumberVal,
                                onCodeSent: (context) async {
                                  context.goNamedAuth(
                                    OtpVerificationWidget.routeName,
                                    context.mounted,
                                    queryParameters: {
                                      'mobilenumber': serializeParam(
                                        widget.mobilenumber,
                                        ParamType.String,
                                      ),
                                    }.withoutNulls,
                                    ignoreRedirect: true,
                                  );
                                },
                              );

                              logFirebaseEvent('Button_timer');
                              _model.timerController.timer
                                  .setPresetTime(mSec: 30000, add: false);
                              _model.timerController.onResetTimer();

                              logFirebaseEvent('Button_timer');
                              _model.timerController.onStartTimer();
                              logFirebaseEvent('Button_show_snack_bar');
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'OTP sent successfully',
                                    style: GoogleFonts.inter(
                                      color:
                                          FlutterFlowTheme.of(context).success,
                                    ),
                                  ),
                                  duration: Duration(milliseconds: 3050),
                                  backgroundColor:
                                      FlutterFlowTheme.of(context).tertiary,
                                ),
                              );
                            },
                            text: FFLocalizations.of(context).getText(
                              'fo6bk954' /* Resend OTP */,
                            ),
                            options: FFButtonOptions(
                              height: 40.0,
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  24.0, 0.0, 24.0, 0.0),
                              iconPadding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 0.0, 0.0, 0.0),
                              color: Color(0x23249689),
                              textStyle: FlutterFlowTheme.of(context)
                                  .titleSmall
                                  .override(
                                    fontFamily: FlutterFlowTheme.of(context)
                                        .titleSmallFamily,
                                    color:
                                        FlutterFlowTheme.of(context).tertiary,
                                    letterSpacing: 0.0,
                                    useGoogleFonts:
                                        !FlutterFlowTheme.of(context)
                                            .titleSmallIsCustom,
                                  ),
                              elevation: 0.0,
                              borderSide: BorderSide(
                                color: FlutterFlowTheme.of(context).success,
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 60.0, 0.0, 0.0),
                  child: FFButtonWidget(
                    onPressed: () async {
                      logFirebaseEvent('Button_validate_form');
                      if (_model.formKey.currentState == null ||
                          !_model.formKey.currentState!.validate()) {
                        return;
                      }
                      if (widget.type == 'signup') {
                        logFirebaseEvent('Button_auth');
                        GoRouter.of(context).prepareAuthEvent();
                        final smsCodeVal = _model.otpverification!.text;
                        if (smsCodeVal.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Enter SMS verification code.'),
                            ),
                          );
                          return;
                        }
                        final phoneVerifiedUser =
                            await authManager.verifySmsCode(
                          context: context,
                          smsCode: smsCodeVal,
                        );
                        if (phoneVerifiedUser == null) {
                          return;
                        }

                        logFirebaseEvent('Button_backend_call');
                        _model.getUserbUserId = await GetUserByUidCall.call(
                          userId: currentUserUid,
                        );

                        if (GetUserByUidCall.userid(
                                  (_model.getUserbUserId?.jsonBody ?? ''),
                                ) !=
                                null &&
                            GetUserByUidCall.userid(
                                  (_model.getUserbUserId?.jsonBody ?? ''),
                                ) !=
                                '') {
                          logFirebaseEvent('Button_alert_dialog');
                          await showDialog(
                            context: context,
                            builder: (alertDialogContext) {
                              return WebViewAware(
                                child: AlertDialog(
                                  title: Text('User already registered'),
                                  content: Text('Go to login page'),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(alertDialogContext),
                                      child: Text('Ok'),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                          logFirebaseEvent('Button_navigate_to');

                          context.goNamedAuth(
                              LoginNewWidget.routeName, context.mounted);
                        } else {
                          logFirebaseEvent('Button_backend_call');
                          await UsersTable().insert({
                            'first_name': widget.name,
                            'email': widget.email,
                            'user_id': currentUserUid,
                          });
                          logFirebaseEvent('Button_navigate_to');

                          context.goNamedAuth(
                              HomeNewWidget.routeName, context.mounted);
                        }
                      } else {
                        logFirebaseEvent('Button_auth');
                        GoRouter.of(context).prepareAuthEvent();
                        final smsCodeVal = _model.otpverification!.text;
                        if (smsCodeVal.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Enter SMS verification code.'),
                            ),
                          );
                          return;
                        }
                        final phoneVerifiedUser =
                            await authManager.verifySmsCode(
                          context: context,
                          smsCode: smsCodeVal,
                        );
                        if (phoneVerifiedUser == null) {
                          return;
                        }

                        logFirebaseEvent('Button_backend_call');
                        _model.getUserbUserId2 = await GetUserByUidCall.call(
                          userId: currentUserUid,
                        );

                        if (GetUserByUidCall.userid(
                                  (_model.getUserbUserId2?.jsonBody ?? ''),
                                ) ==
                                null ||
                            GetUserByUidCall.userid(
                                  (_model.getUserbUserId2?.jsonBody ?? ''),
                                ) ==
                                '') {
                          logFirebaseEvent('Button_alert_dialog');
                          await showDialog(
                            context: context,
                            builder: (alertDialogContext) {
                              return WebViewAware(
                                child: AlertDialog(
                                  title: Text('User  not registered'),
                                  content: Text('Go to signup page'),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(alertDialogContext),
                                      child: Text('Ok'),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                          logFirebaseEvent('Button_navigate_to');

                          context.goNamedAuth(
                              SignupNewWidget.routeName, context.mounted);
                        } else {
                          logFirebaseEvent('Button_navigate_to');

                          context.goNamedAuth(
                              HomeNewWidget.routeName, context.mounted);
                        }
                      }

                      safeSetState(() {});
                    },
                    text: FFLocalizations.of(context).getText(
                      'xp2hwog5' /* Submit */,
                    ),
                    options: FFButtonOptions(
                      width: 328.0,
                      height: 45.0,
                      padding:
                          EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
                      iconPadding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                      color: FlutterFlowTheme.of(context).primary,
                      textStyle: FlutterFlowTheme.of(context)
                          .titleSmall
                          .override(
                            fontFamily:
                                FlutterFlowTheme.of(context).titleSmallFamily,
                            color: Colors.white,
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.bold,
                            useGoogleFonts: !FlutterFlowTheme.of(context)
                                .titleSmallIsCustom,
                          ),
                      elevation: 3.0,
                      borderSide: BorderSide(
                        color: Colors.transparent,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(51.0),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

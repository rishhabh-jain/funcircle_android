import '/auth/firebase_auth/auth_util.dart';
import '/backend/api_requests/api_calls.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'secretfields_model.dart';
export 'secretfields_model.dart';

class SecretfieldsWidget extends StatefulWidget {
  const SecretfieldsWidget({super.key});

  static String routeName = 'secretfields';
  static String routePath = '/secretfields';

  @override
  State<SecretfieldsWidget> createState() => _SecretfieldsWidgetState();
}

class _SecretfieldsWidgetState extends State<SecretfieldsWidget> {
  late SecretfieldsModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SecretfieldsModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      logFirebaseEvent('secretfields_backend_call');
      _model.apiResultnc6 = await GetSecretFieldsOfUserCall.call(
        userId: currentUserUid,
      );

      if ((_model.apiResultnc6?.succeeded ?? true)) {
        logFirebaseEvent('secretfields_update_page_state');
        _model.secrets = GetSecretFieldsOfUserCall.secrets(
          (_model.apiResultnc6?.jsonBody ?? ''),
        )!
            .toList()
            .cast<String>();
        safeSetState(() {});
      }
    });

    _model.textController ??= TextEditingController(
        text: valueOrDefault<String>(
      _model.secrets.elementAtOrNull(_model.questionnumber),
      'Answer',
    ));
    _model.textFieldFocusNode ??= FocusNode();

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
        body: SafeArea(
          top: true,
          child: Align(
            alignment: AlignmentDirectional(0.0, -1.0),
            child: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0.0, 30.0, 0.0, 0.0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Align(
                    alignment: AlignmentDirectional(-1.0, 0.0),
                    child: Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(30.0, 0.0, 0.0, 0.0),
                      child: Container(
                        decoration: BoxDecoration(),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 0.0, 10.0, 0.0),
                              child: Text(
                                valueOrDefault<String>(
                                  () {
                                    if (_model.questionnumber == 0) {
                                      return 'Secret to My Heart (1/3)';
                                    } else if (_model.questionnumber == 1) {
                                      return 'Private Thoughts (2/3)';
                                    } else {
                                      return 'Exclusive Insights (3/3)';
                                    }
                                  }(),
                                  'Exclusive Insights (3/3)',
                                ),
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      fontFamily: FlutterFlowTheme.of(context)
                                          .bodyMediumFamily,
                                      color:
                                          FlutterFlowTheme.of(context).primary,
                                      fontSize: 30.0,
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.w600,
                                      useGoogleFonts:
                                          !FlutterFlowTheme.of(context)
                                              .bodyMediumIsCustom,
                                    ),
                              ),
                            ),
                            Align(
                              alignment: AlignmentDirectional(-1.0, 0.0),
                              child: Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 15.0, 10.0, 0.0),
                                child: Text(
                                  valueOrDefault<String>(
                                    () {
                                      if (_model.questionnumber == 0) {
                                        return 'Share a unique passion or interest that is close to your heart.';
                                      } else if (_model.questionnumber == 1) {
                                        return 'Describe a personal belief or thought that shapes who you are.';
                                      } else {
                                        return 'Share an interesting or unusual experience that has impacted you.';
                                      }
                                    }(),
                                    'Share an interesting or unusual experience that has impacted you.',
                                  ),
                                  textAlign: TextAlign.start,
                                  style: FlutterFlowTheme.of(context)
                                      .headlineSmall
                                      .override(
                                        font: GoogleFonts.inter(
                                          fontWeight:
                                              FlutterFlowTheme.of(context)
                                                  .headlineSmall
                                                  .fontWeight,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .headlineSmall
                                                  .fontStyle,
                                        ),
                                        color: FlutterFlowTheme.of(context)
                                            .secondary,
                                        fontSize: 18.0,
                                        letterSpacing: 0.0,
                                        fontWeight: FlutterFlowTheme.of(context)
                                            .headlineSmall
                                            .fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .headlineSmall
                                            .fontStyle,
                                      ),
                                ),
                              ),
                            ),
                            Form(
                              key: _model.formKey,
                              autovalidateMode: AutovalidateMode.disabled,
                              child: Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 40.0, 0.0, 0.0),
                                child: Container(
                                  width: 320.0,
                                  child: TextFormField(
                                    controller: _model.textController,
                                    focusNode: _model.textFieldFocusNode,
                                    autofocus: true,
                                    textInputAction: TextInputAction.send,
                                    obscureText: false,
                                    decoration: InputDecoration(
                                      isDense: false,
                                      labelText:
                                          FFLocalizations.of(context).getText(
                                        'rd8bmki6' /* answer here... */,
                                      ),
                                      labelStyle: FlutterFlowTheme.of(context)
                                          .labelMedium
                                          .override(
                                            fontFamily:
                                                FlutterFlowTheme.of(context)
                                                    .labelMediumFamily,
                                            fontSize: 16.0,
                                            letterSpacing: 0.0,
                                            useGoogleFonts:
                                                !FlutterFlowTheme.of(context)
                                                    .labelMediumIsCustom,
                                          ),
                                      alignLabelWithHint: true,
                                      hintStyle: FlutterFlowTheme.of(context)
                                          .labelMedium
                                          .override(
                                            fontFamily:
                                                FlutterFlowTheme.of(context)
                                                    .labelMediumFamily,
                                            fontSize: 16.0,
                                            letterSpacing: 0.0,
                                            useGoogleFonts:
                                                !FlutterFlowTheme.of(context)
                                                    .labelMediumIsCustom,
                                          ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Color(0xFFD0D5DD),
                                          width: 2.0,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: FlutterFlowTheme.of(context)
                                              .primary,
                                          width: 2.0,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: FlutterFlowTheme.of(context)
                                              .error,
                                          width: 2.0,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: FlutterFlowTheme.of(context)
                                              .error,
                                          width: 2.0,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                    ),
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          fontFamily:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMediumFamily,
                                          fontSize: 16.0,
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.w500,
                                          useGoogleFonts:
                                              !FlutterFlowTheme.of(context)
                                                  .bodyMediumIsCustom,
                                        ),
                                    textAlign: TextAlign.start,
                                    maxLines: 10,
                                    validator: _model.textControllerValidator
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
                  Align(
                    alignment: AlignmentDirectional(0.0, 1.0),
                    child: Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 20.0),
                      child: Container(
                        width: 335.0,
                        height: 50.0,
                        decoration: BoxDecoration(),
                        alignment: AlignmentDirectional(0.0, 1.0),
                        child: Align(
                          alignment: AlignmentDirectional(0.0, 0.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Align(
                                alignment: AlignmentDirectional(1.0, 0.0),
                                child: Container(
                                  width: 52.0,
                                  height: 52.0,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100.0),
                                  ),
                                  child: FlutterFlowIconButton(
                                    borderColor: Colors.transparent,
                                    borderRadius: 20.0,
                                    borderWidth: 1.0,
                                    buttonSize: 40.0,
                                    icon: Icon(
                                      FFIcons.karrowLeft,
                                      color: FlutterFlowTheme.of(context)
                                          .primaryText,
                                      size: 32.0,
                                    ),
                                    showLoadingIndicator: true,
                                    onPressed: () async {
                                      if ((_model.questionnumber > 0) &&
                                              (_model.questionnumber < 3)
                                          ? true
                                          : false) {
                                        logFirebaseEvent(
                                            'IconButton_update_page_state');
                                        _model.questionnumber =
                                            _model.questionnumber + -1;
                                        safeSetState(() {});
                                      } else {
                                        logFirebaseEvent(
                                            'IconButton_navigate_back');
                                        context.safePop();
                                      }
                                    },
                                  ),
                                ),
                              ),
                              Align(
                                alignment: AlignmentDirectional(1.0, 0.0),
                                child: Container(
                                  width: 52.0,
                                  height: 52.0,
                                  decoration: BoxDecoration(
                                    color: Color(0xFFFEE6FF),
                                    borderRadius: BorderRadius.circular(100.0),
                                  ),
                                  child: FlutterFlowIconButton(
                                    borderColor: Colors.transparent,
                                    borderRadius: 20.0,
                                    borderWidth: 1.0,
                                    buttonSize: 40.0,
                                    fillColor: Color(0xFFFEE6FF),
                                    icon: Icon(
                                      FFIcons.kcaretRight,
                                      color: FlutterFlowTheme.of(context)
                                          .primaryText,
                                      size: 32.0,
                                    ),
                                    showLoadingIndicator: true,
                                    onPressed: () async {
                                      if (_model.questionnumber <= 2
                                          ? true
                                          : false) {
                                        logFirebaseEvent(
                                            'IconButton_validate_form');
                                        if (_model.formKey.currentState ==
                                                null ||
                                            !_model.formKey.currentState!
                                                .validate()) {
                                          return;
                                        }
                                        logFirebaseEvent(
                                            'IconButton_update_page_state');
                                        _model.updateSecretsAtIndex(
                                          _model.questionnumber,
                                          (_) => _model.textController.text,
                                        );
                                        safeSetState(() {});
                                        logFirebaseEvent(
                                            'IconButton_backend_call');
                                        await UsersTable().update(
                                          data: {
                                            'secrets': _model.secrets,
                                          },
                                          matchingRows: (rows) => rows.eqOrNull(
                                            'user_id',
                                            currentUserUid,
                                          ),
                                        );
                                        logFirebaseEvent(
                                            'IconButton_update_page_state');
                                        _model.questionnumber =
                                            _model.questionnumber + 1;
                                        safeSetState(() {});
                                        logFirebaseEvent(
                                            'IconButton_set_form_field');
                                        safeSetState(() {
                                          _model.textController?.text = ' ';
                                        });
                                        if (_model.questionnumber == 3) {
                                          logFirebaseEvent(
                                              'IconButton_navigate_to');

                                          context.goNamed(
                                              EditProfileWidget.routeName);
                                        }
                                      } else {
                                        logFirebaseEvent(
                                            'IconButton_navigate_to');

                                        context.goNamed(
                                            EditProfileWidget.routeName);
                                      }
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

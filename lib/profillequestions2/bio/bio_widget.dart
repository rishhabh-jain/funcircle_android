import '/auth/firebase_auth/auth_util.dart';
import '/backend/gemini/gemini.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'bio_model.dart';
export 'bio_model.dart';

class BioWidget extends StatefulWidget {
  const BioWidget({
    super.key,
    this.uid,
    this.biotext,
  });

  final String? uid;
  final String? biotext;

  static String routeName = 'bio';
  static String routePath = '/bio';

  @override
  State<BioWidget> createState() => _BioWidgetState();
}

class _BioWidgetState extends State<BioWidget> {
  late BioModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => BioModel());

    _model.textController ??= TextEditingController(text: widget.biotext);
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
        backgroundColor: Color(0xFFFFF5FB),
        body: SafeArea(
          top: true,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                if ((widget.uid == null || widget.uid == '') &&
                    !FFAppConstants.onlysocial)
                  LinearPercentIndicator(
                    percent: 0.99,
                    width: MediaQuery.sizeOf(context).width * 1.0,
                    lineHeight: 12.0,
                    animation: false,
                    animateFromLastPercent: true,
                    progressColor: FlutterFlowTheme.of(context).primary,
                    backgroundColor: FlutterFlowTheme.of(context).accent4,
                    padding: EdgeInsets.zero,
                  ),
                Align(
                  alignment: AlignmentDirectional(0.0, 0.0),
                  child: Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(0.0, 30.0, 0.0, 0.0),
                    child: Container(
                      width: MediaQuery.sizeOf(context).width * 0.9,
                      height: 93.0,
                      decoration: BoxDecoration(),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Align(
                            alignment: AlignmentDirectional(-1.0, 0.0),
                            child: Icon(
                              FFIcons.kpencilSimpleLine,
                              color: Color(0xFFF902FF),
                              size: 32.0,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 12.0, 0.0, 0.0),
                            child: Text(
                              FFLocalizations.of(context).getText(
                                'nitj8dr8' /* Add more about you */,
                              ),
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    fontFamily: FlutterFlowTheme.of(context)
                                        .bodyMediumFamily,
                                    fontSize: 30.0,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.w500,
                                    useGoogleFonts:
                                        !FlutterFlowTheme.of(context)
                                            .bodyMediumIsCustom,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                if (!FFAppConstants.onlysocial)
                  Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(30.0, 15.0, 30.0, 0.0),
                    child: Text(
                      FFLocalizations.of(context).getText(
                        'mkql8g5g' /* Help potential matched underst... */,
                      ),
                      textAlign: TextAlign.start,
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily:
                                FlutterFlowTheme.of(context).bodyMediumFamily,
                            color: Color(0xFF64748B),
                            fontSize: 16.0,
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.w500,
                            useGoogleFonts: !FlutterFlowTheme.of(context)
                                .bodyMediumIsCustom,
                          ),
                    ),
                  ),
                Form(
                  key: _model.formKey,
                  autovalidateMode: AutovalidateMode.disabled,
                  child: Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(0.0, 40.0, 0.0, 0.0),
                    child: Container(
                      width: MediaQuery.sizeOf(context).width * 0.9,
                      child: TextFormField(
                        controller: _model.textController,
                        focusNode: _model.textFieldFocusNode,
                        autofocus: true,
                        textInputAction: TextInputAction.send,
                        obscureText: false,
                        decoration: InputDecoration(
                          isDense: false,
                          labelText: FFLocalizations.of(context).getText(
                            'r07lx0oa' /* Tell us something about yourse... */,
                          ),
                          labelStyle: FlutterFlowTheme.of(context)
                              .labelMedium
                              .override(
                                fontFamily: FlutterFlowTheme.of(context)
                                    .labelMediumFamily,
                                fontSize: 16.0,
                                letterSpacing: 0.0,
                                useGoogleFonts: !FlutterFlowTheme.of(context)
                                    .labelMediumIsCustom,
                              ),
                          alignLabelWithHint: true,
                          hintStyle: FlutterFlowTheme.of(context)
                              .labelMedium
                              .override(
                                fontFamily: FlutterFlowTheme.of(context)
                                    .labelMediumFamily,
                                fontSize: 16.0,
                                letterSpacing: 0.0,
                                useGoogleFonts: !FlutterFlowTheme.of(context)
                                    .labelMediumIsCustom,
                              ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xFFD0D5DD),
                              width: 2.0,
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: FlutterFlowTheme.of(context).primary,
                              width: 2.0,
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: FlutterFlowTheme.of(context).error,
                              width: 2.0,
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: FlutterFlowTheme.of(context).error,
                              width: 2.0,
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily:
                                  FlutterFlowTheme.of(context).bodyMediumFamily,
                              fontSize: 16.0,
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.w500,
                              useGoogleFonts: !FlutterFlowTheme.of(context)
                                  .bodyMediumIsCustom,
                            ),
                        textAlign: TextAlign.start,
                        maxLines: 10,
                        validator:
                            _model.textControllerValidator.asValidator(context),
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: AlignmentDirectional(1.0, 0.0),
                  child: Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(0.0, 10.0, 15.0, 0.0),
                    child: InkWell(
                      splashColor: Colors.transparent,
                      focusColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () async {
                        logFirebaseEvent('Image_gemini');
                        await geminiGenerateText(
                          context,
                          'write a profile bio for me for a dating app - this is something about me -- ${_model.textController.text}Instructions - Limit it to 300 characters and at the end write ',
                        ).then((generatedText) {
                          safeSetState(() => _model.geminibio = generatedText);
                        });

                        logFirebaseEvent('Image_set_form_field');
                        safeSetState(() {
                          _model.textController?.text = _model.geminibio!;
                        });

                        safeSetState(() {});
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(24.0),
                        child: Image.asset(
                          'assets/images/gemini.jpg',
                          height: 38.0,
                          fit: BoxFit.fitHeight,
                          alignment: Alignment(1.0, 0.0),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsetsDirectional.fromSTEB(0.0, 100.0, 0.0, 20.0),
                  child: Container(
                    width: 335.0,
                    height: 50.0,
                    decoration: BoxDecoration(),
                    child: Align(
                      alignment: AlignmentDirectional(0.0, 0.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          if (widget.uid == null || widget.uid == '')
                            InkWell(
                              splashColor: Colors.transparent,
                              focusColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap: () async {
                                logFirebaseEvent('Text_navigate_to');

                                context.pushNamed(
                                  MyProfileWidget.routeName,
                                  extra: <String, dynamic>{
                                    kTransitionInfoKey: TransitionInfo(
                                      hasTransition: true,
                                      transitionType:
                                          PageTransitionType.topToBottom,
                                    ),
                                  },
                                );
                              },
                              child: Text(
                                FFLocalizations.of(context).getText(
                                  'h7a01njs' /* Skip */,
                                ),
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      fontFamily: FlutterFlowTheme.of(context)
                                          .bodyMediumFamily,
                                      fontSize: 16.0,
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.w500,
                                      useGoogleFonts:
                                          !FlutterFlowTheme.of(context)
                                              .bodyMediumIsCustom,
                                    ),
                              ),
                            ),
                          if (widget.uid != null && widget.uid != '')
                            Align(
                              alignment: AlignmentDirectional(1.0, 0.0),
                              child: Container(
                                width: 52.0,
                                height: 52.0,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100.0),
                                ),
                                child: FlutterFlowIconButton(
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
                                    logFirebaseEvent(
                                        'IconButton_navigate_back');
                                    context.safePop();
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
                                  color:
                                      FlutterFlowTheme.of(context).primaryText,
                                  size: 32.0,
                                ),
                                showLoadingIndicator: true,
                                onPressed: () async {
                                  if (widget.uid != null &&
                                      widget.uid != '') {
                                    logFirebaseEvent(
                                        'IconButton_validate_form');
                                    if (_model.formKey.currentState == null ||
                                        !_model.formKey.currentState!
                                            .validate()) {
                                      return;
                                    }
                                    logFirebaseEvent('IconButton_backend_call');
                                    _model.nameOutput2 =
                                        await UsersTable().update(
                                      data: {
                                        'bio': _model.textController.text,
                                      },
                                      matchingRows: (rows) => rows.eqOrNull(
                                        'user_id',
                                        currentUserUid,
                                      ),
                                      returnRows: true,
                                    );
                                    logFirebaseEvent('IconButton_navigate_to');

                                    context.goNamed(
                                      EditProfileWidget.routeName,
                                      extra: <String, dynamic>{
                                        kTransitionInfoKey: TransitionInfo(
                                          hasTransition: true,
                                          transitionType:
                                              PageTransitionType.rightToLeft,
                                        ),
                                      },
                                    );
                                  } else {
                                    logFirebaseEvent(
                                        'IconButton_validate_form');
                                    if (_model.formKey.currentState == null ||
                                        !_model.formKey.currentState!
                                            .validate()) {
                                      return;
                                    }
                                    logFirebaseEvent('IconButton_backend_call');
                                    _model.nameOutput =
                                        await UsersTable().update(
                                      data: {
                                        'bio': _model.textController.text,
                                      },
                                      matchingRows: (rows) => rows.eqOrNull(
                                        'user_id',
                                        currentUserUid,
                                      ),
                                      returnRows: true,
                                    );
                                    logFirebaseEvent('IconButton_navigate_to');

                                    context.goNamed(
                                      MyProfileWidget.routeName,
                                      extra: <String, dynamic>{
                                        kTransitionInfoKey: TransitionInfo(
                                          hasTransition: true,
                                          transitionType:
                                              PageTransitionType.leftToRight,
                                        ),
                                      },
                                    );
                                  }

                                  safeSetState(() {});
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
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

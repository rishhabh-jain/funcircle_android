import '/auth/firebase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'answerprompt_model.dart';
export 'answerprompt_model.dart';

class AnswerpromptWidget extends StatefulWidget {
  const AnswerpromptWidget({
    super.key,
    String? questionText,
    int? promptid,
    String? answertext,
    bool? fromeditProfile,
    bool? questionisset,
  })  : this.questionText = questionText ?? 'questionText',
        this.promptid = promptid ?? 1,
        this.answertext = answertext ?? ' ',
        this.fromeditProfile = fromeditProfile ?? false,
        this.questionisset = questionisset ?? false;

  final String questionText;
  final int promptid;
  final String answertext;
  final bool fromeditProfile;
  final bool questionisset;

  static String routeName = 'answerprompt';
  static String routePath = '/answerprompt';

  @override
  State<AnswerpromptWidget> createState() => _AnswerpromptWidgetState();
}

class _AnswerpromptWidgetState extends State<AnswerpromptWidget> {
  late AnswerpromptModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AnswerpromptModel());

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
                Align(
                  alignment: AlignmentDirectional(-1.0, 0.0),
                  child: Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(33.0, 30.0, 0.0, 0.0),
                    child: Container(
                      width: 147.0,
                      height: 38.0,
                      decoration: BoxDecoration(),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            FFLocalizations.of(context).getText(
                              'giq8az2a' /* Prompts */,
                            ),
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  fontFamily: FlutterFlowTheme.of(context)
                                      .bodyMediumFamily,
                                  fontSize: 30.0,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.w500,
                                  useGoogleFonts: !FlutterFlowTheme.of(context)
                                      .bodyMediumIsCustom,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: AlignmentDirectional(-1.0, 0.0),
                  child: Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(33.0, 15.0, 30.0, 0.0),
                    child: Text(
                      widget.questionText,
                      textAlign: TextAlign.start,
                      style: FlutterFlowTheme.of(context)
                          .headlineSmall
                          .override(
                            fontFamily: FlutterFlowTheme.of(context)
                                .headlineSmallFamily,
                            color: FlutterFlowTheme.of(context).secondaryText,
                            fontSize: 20.0,
                            letterSpacing: 0.0,
                            useGoogleFonts: !FlutterFlowTheme.of(context)
                                .headlineSmallIsCustom,
                          ),
                    ),
                  ),
                ),
                FutureBuilder<List<UserpromptsRow>>(
                  future: UserpromptsTable().querySingleRow(
                    queryFn: (q) => q
                        .eqOrNull(
                          'prompt_id',
                          widget.promptid,
                        )
                        .eqOrNull(
                          'user_id',
                          currentUserUid,
                        ),
                  ),
                  builder: (context, snapshot) {
                    // Customize what your widget looks like when it's loading.
                    if (!snapshot.hasData) {
                      return Center(
                        child: SizedBox(
                          width: 50.0,
                          height: 50.0,
                          child: SpinKitRing(
                            color: FlutterFlowTheme.of(context).primary,
                            size: 50.0,
                          ),
                        ),
                      );
                    }
                    List<UserpromptsRow> formUserpromptsRowList =
                        snapshot.data!;

                    final formUserpromptsRow = formUserpromptsRowList.isNotEmpty
                        ? formUserpromptsRowList.first
                        : null;

                    return Form(
                      key: _model.formKey,
                      autovalidateMode: AutovalidateMode.disabled,
                      child: Padding(
                        padding:
                            EdgeInsetsDirectional.fromSTEB(0.0, 40.0, 0.0, 0.0),
                        child: Container(
                          width: 320.0,
                          child: TextFormField(
                            controller: _model.textController ??=
                                TextEditingController(
                              text: widget.questionisset
                                  ? formUserpromptsRow?.answerText
                                  : ' ',
                            ),
                            focusNode: _model.textFieldFocusNode,
                            autofocus: true,
                            textInputAction: TextInputAction.send,
                            obscureText: false,
                            decoration: InputDecoration(
                              isDense: false,
                              labelText: FFLocalizations.of(context).getText(
                                't9nrd3wt' /* answer here... */,
                              ),
                              labelStyle: FlutterFlowTheme.of(context)
                                  .labelMedium
                                  .override(
                                    fontFamily: FlutterFlowTheme.of(context)
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
                                    fontFamily: FlutterFlowTheme.of(context)
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
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  fontFamily: FlutterFlowTheme.of(context)
                                      .bodyMediumFamily,
                                  fontSize: 16.0,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.w500,
                                  useGoogleFonts: !FlutterFlowTheme.of(context)
                                      .bodyMediumIsCustom,
                                ),
                            textAlign: TextAlign.start,
                            maxLines: 10,
                            validator: _model.textControllerValidator
                                .asValidator(context),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                Padding(
                  padding:
                      EdgeInsetsDirectional.fromSTEB(0.0, 190.0, 0.0, 20.0),
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
                                  color:
                                      FlutterFlowTheme.of(context).primaryText,
                                  size: 32.0,
                                ),
                                showLoadingIndicator: true,
                                onPressed: () async {
                                  logFirebaseEvent('IconButton_navigate_back');
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
                                  if (widget.questionisset == true) {
                                    if (widget.fromeditProfile == true) {
                                      logFirebaseEvent(
                                          'IconButton_validate_form');
                                      if (_model.formKey.currentState == null ||
                                          !_model.formKey.currentState!
                                              .validate()) {
                                        return;
                                      }
                                      logFirebaseEvent(
                                          'IconButton_backend_call');
                                      _model.promptAnswerOutput3 =
                                          await UserpromptsTable().update(
                                        data: {
                                          'answer_text':
                                              _model.textController.text,
                                        },
                                        matchingRows: (rows) => rows
                                            .eqOrNull(
                                              'user_id',
                                              currentUserUid,
                                            )
                                            .eqOrNull(
                                              'prompt_id',
                                              widget.promptid,
                                            ),
                                        returnRows: true,
                                      );
                                      logFirebaseEvent(
                                          'IconButton_navigate_to');

                                      context.goNamed(
                                        EditProfileWidget.routeName,
                                        extra: <String, dynamic>{
                                          kTransitionInfoKey: TransitionInfo(
                                            hasTransition: true,
                                            transitionType:
                                                PageTransitionType.leftToRight,
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
                                      logFirebaseEvent(
                                          'IconButton_backend_call');
                                      _model.promptAnswerOutput2 =
                                          await UserpromptsTable().update(
                                        data: {
                                          'answer_text':
                                              _model.textController.text,
                                        },
                                        matchingRows: (rows) => rows
                                            .eqOrNull(
                                              'user_id',
                                              currentUserUid,
                                            )
                                            .eqOrNull(
                                              'prompt_id',
                                              widget.promptid,
                                            ),
                                        returnRows: true,
                                      );
                                      logFirebaseEvent(
                                          'IconButton_navigate_back');
                                      context.safePop();
                                    }
                                  } else {
                                    logFirebaseEvent(
                                        'IconButton_validate_form');
                                    if (_model.formKey.currentState == null ||
                                        !_model.formKey.currentState!
                                            .validate()) {
                                      return;
                                    }
                                    logFirebaseEvent('IconButton_backend_call');
                                    _model.promptAnswerOutput =
                                        await UserpromptsTable().insert({
                                      'user_id': valueOrDefault<String>(
                                        currentUserUid,
                                        'JiK4SkNUWsT3S1kgYUETPbOFsuH3',
                                      ),
                                      'prompt_id': widget.promptid,
                                      'answer_text': _model.textController.text,
                                    });
                                    logFirebaseEvent(
                                        'IconButton_navigate_back');
                                    context.safePop();
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

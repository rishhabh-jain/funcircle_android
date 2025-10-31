import '/auth/firebase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_choice_chips.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'interests_model.dart';
export 'interests_model.dart';

class InterestsWidget extends StatefulWidget {
  const InterestsWidget({
    super.key,
    this.uid,
    this.filters,
    this.groupid,
    bool? ifonlyfogroups,
  }) : this.ifonlyfogroups = ifonlyfogroups ?? false;

  final String? uid;
  final bool? filters;
  final int? groupid;
  final bool ifonlyfogroups;

  static String routeName = 'interests';
  static String routePath = '/interests';

  @override
  State<InterestsWidget> createState() => _InterestsWidgetState();
}

class _InterestsWidgetState extends State<InterestsWidget> {
  late InterestsModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => InterestsModel());

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
        backgroundColor: Colors.white,
        body: SafeArea(
          top: true,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                if ((widget.uid == null || widget.uid == '') &&
                    (widget.groupid == null))
                  LinearPercentIndicator(
                    percent: 0.12,
                    width: MediaQuery.sizeOf(context).width * 1.0,
                    lineHeight: 12.0,
                    animation: true,
                    animateFromLastPercent: true,
                    progressColor: FlutterFlowTheme.of(context).primary,
                    backgroundColor: FlutterFlowTheme.of(context).accent4,
                    padding: EdgeInsets.zero,
                  ),
                Align(
                  alignment: AlignmentDirectional(-1.0, 0.0),
                  child: Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(33.0, 30.0, 0.0, 0.0),
                    child: Container(
                      width: 294.0,
                      height: 60.0,
                      decoration: BoxDecoration(),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            FFLocalizations.of(context).getText(
                              '54ywcatu' /* Your Interests */,
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
                Padding(
                  padding:
                      EdgeInsetsDirectional.fromSTEB(30.0, 15.0, 30.0, 0.0),
                  child: Text(
                    FFLocalizations.of(context).getText(
                      'sk3km8tg' /* Pick Up-to 7 things you love. ... */,
                    ),
                    textAlign: TextAlign.start,
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontFamily:
                              FlutterFlowTheme.of(context).bodyMediumFamily,
                          color: FlutterFlowTheme.of(context).secondary,
                          fontSize: 16.0,
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.w500,
                          useGoogleFonts:
                              !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                        ),
                  ),
                ),
                Align(
                  alignment: AlignmentDirectional(-1.0, 0.0),
                  child: Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(12.0, 0.0, 12.0, 0.0),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Align(
                            alignment: AlignmentDirectional(-1.0, 0.0),
                            child: Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 25.0, 0.0, 0.0),
                              child: Text(
                                FFLocalizations.of(context).getText(
                                  'm79gqxm1' /* Self Care */,
                                ),
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      fontFamily: FlutterFlowTheme.of(context)
                                          .bodyMediumFamily,
                                      fontSize: 16.0,
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.bold,
                                      useGoogleFonts:
                                          !FlutterFlowTheme.of(context)
                                              .bodyMediumIsCustom,
                                    ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 15.0, 0.0, 0.0),
                            child: FlutterFlowChoiceChips(
                              options: [
                                ChipData(
                                    FFLocalizations.of(context).getText(
                                      '8avwwg2d' /* Running */,
                                    ),
                                    Icons.directions_run_rounded),
                                ChipData(
                                    FFLocalizations.of(context).getText(
                                      '19eyaf1o' /* Gym */,
                                    ),
                                    Icons.fitness_center_sharp),
                                ChipData(
                                    FFLocalizations.of(context).getText(
                                      '994vqmbw' /* Physical fitness */,
                                    ),
                                    Icons.directions_walk_rounded),
                                ChipData(
                                    FFLocalizations.of(context).getText(
                                      'oe8rx67q' /* Hygiene */,
                                    ),
                                    Icons.back_hand_outlined),
                                ChipData(
                                    FFLocalizations.of(context).getText(
                                      'wihdc0mj' /* Muscle relaxation */,
                                    ),
                                    Icons.headset_sharp),
                                ChipData(FFLocalizations.of(context).getText(
                                  'xyrn1a4a' /* Meditation */,
                                )),
                                ChipData(FFLocalizations.of(context).getText(
                                  'v7vzqp65' /* Healthy cooking */,
                                )),
                                ChipData(FFLocalizations.of(context).getText(
                                  'w9llnjir' /* Yoga */,
                                )),
                                ChipData(FFLocalizations.of(context).getText(
                                  'df8kdc51' /* Reading  */,
                                ))
                              ],
                              onChanged: (val) => safeSetState(() =>
                                  _model.selfcareValue = val?.firstOrNull),
                              selectedChipStyle: ChipStyle(
                                backgroundColor: Color(0x00000000),
                                textStyle: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      fontFamily: FlutterFlowTheme.of(context)
                                          .bodyMediumFamily,
                                      color: Color(0xFFF902FF),
                                      letterSpacing: 0.0,
                                      useGoogleFonts:
                                          !FlutterFlowTheme.of(context)
                                              .bodyMediumIsCustom,
                                    ),
                                iconColor: Color(0xFFF902FF),
                                iconSize: 18.0,
                                elevation: 0.0,
                                borderColor: Color(0xFFF902FF),
                                borderRadius: BorderRadius.circular(16.0),
                              ),
                              unselectedChipStyle: ChipStyle(
                                backgroundColor: Color(0x00F902FF),
                                textStyle: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      fontFamily: FlutterFlowTheme.of(context)
                                          .bodyMediumFamily,
                                      color: Color(0xFF323A46),
                                      letterSpacing: 0.0,
                                      useGoogleFonts:
                                          !FlutterFlowTheme.of(context)
                                              .bodyMediumIsCustom,
                                    ),
                                iconColor: Color(0xFF323A46),
                                iconSize: 18.0,
                                elevation: 0.0,
                                borderColor: Color(0xFFE7EAEE),
                                borderRadius: BorderRadius.circular(16.0),
                              ),
                              chipSpacing: 12.0,
                              rowSpacing: 12.0,
                              multiselect: false,
                              alignment: WrapAlignment.start,
                              controller: _model.selfcareValueController ??=
                                  FormFieldController<List<String>>(
                                [],
                              ),
                              wrapped: true,
                            ),
                          ),
                          Align(
                            alignment: AlignmentDirectional(-1.0, 0.0),
                            child: Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 10.0, 0.0, 0.0),
                              child: Text(
                                FFLocalizations.of(context).getText(
                                  'vgtc91ed' /* Sports */,
                                ),
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      fontFamily: FlutterFlowTheme.of(context)
                                          .bodyMediumFamily,
                                      fontSize: 16.0,
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.bold,
                                      useGoogleFonts:
                                          !FlutterFlowTheme.of(context)
                                              .bodyMediumIsCustom,
                                    ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 15.0, 0.0, 0.0),
                            child: FlutterFlowChoiceChips(
                              options: [
                                ChipData(
                                    FFLocalizations.of(context).getText(
                                      'foxbzzce' /* Basketball */,
                                    ),
                                    Icons.sports_basketball_outlined),
                                ChipData(
                                    FFLocalizations.of(context).getText(
                                      '92d52g92' /* Cricket */,
                                    ),
                                    Icons.sports_cricket_outlined),
                                ChipData(
                                    FFLocalizations.of(context).getText(
                                      '9t3qzxal' /* Soccer */,
                                    ),
                                    Icons.sports_soccer_rounded),
                                ChipData(
                                    FFLocalizations.of(context).getText(
                                      '9dr8i1cm' /* Tennis */,
                                    ),
                                    Icons.sports_tennis_rounded),
                                ChipData(FFLocalizations.of(context).getText(
                                  'axd9rg5t' /* Swimming */,
                                )),
                                ChipData(FFLocalizations.of(context).getText(
                                  'tefslta8' /* Volleyball */,
                                )),
                                ChipData(FFLocalizations.of(context).getText(
                                  'shs0jw6u' /* Cycling */,
                                )),
                                ChipData(FFLocalizations.of(context).getText(
                                  'xtv7lpoq' /* Golf */,
                                )),
                                ChipData(FFLocalizations.of(context).getText(
                                  'uq58eemp' /* Baseball */,
                                ))
                              ],
                              onChanged: (val) => safeSetState(
                                  () => _model.sportsValue = val?.firstOrNull),
                              selectedChipStyle: ChipStyle(
                                backgroundColor: Color(0x00000000),
                                textStyle: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      fontFamily: FlutterFlowTheme.of(context)
                                          .bodyMediumFamily,
                                      color:
                                          FlutterFlowTheme.of(context).primary,
                                      letterSpacing: 0.0,
                                      useGoogleFonts:
                                          !FlutterFlowTheme.of(context)
                                              .bodyMediumIsCustom,
                                    ),
                                iconColor: FlutterFlowTheme.of(context).primary,
                                iconSize: 18.0,
                                elevation: 0.0,
                                borderColor:
                                    FlutterFlowTheme.of(context).primary,
                                borderRadius: BorderRadius.circular(16.0),
                              ),
                              unselectedChipStyle: ChipStyle(
                                backgroundColor: Color(0x00F902FF),
                                textStyle: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      fontFamily: FlutterFlowTheme.of(context)
                                          .bodyMediumFamily,
                                      color: Color(0xFF323A46),
                                      letterSpacing: 0.0,
                                      useGoogleFonts:
                                          !FlutterFlowTheme.of(context)
                                              .bodyMediumIsCustom,
                                    ),
                                iconColor: Color(0xFF323A46),
                                iconSize: 18.0,
                                elevation: 0.0,
                                borderColor: Color(0xFFE7EAEE),
                                borderRadius: BorderRadius.circular(16.0),
                              ),
                              chipSpacing: 12.0,
                              rowSpacing: 12.0,
                              multiselect: false,
                              alignment: WrapAlignment.start,
                              controller: _model.sportsValueController ??=
                                  FormFieldController<List<String>>(
                                [],
                              ),
                              wrapped: true,
                            ),
                          ),
                          Align(
                            alignment: AlignmentDirectional(-1.0, 0.0),
                            child: Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 10.0, 0.0, 0.0),
                              child: Text(
                                FFLocalizations.of(context).getText(
                                  'u1tu90vr' /* Music */,
                                ),
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      fontFamily: FlutterFlowTheme.of(context)
                                          .bodyMediumFamily,
                                      fontSize: 16.0,
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.bold,
                                      useGoogleFonts:
                                          !FlutterFlowTheme.of(context)
                                              .bodyMediumIsCustom,
                                    ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 15.0, 0.0, 0.0),
                            child: FlutterFlowChoiceChips(
                              options: [
                                ChipData(
                                    FFLocalizations.of(context).getText(
                                      'pn49fotr' /* Rock */,
                                    ),
                                    Icons.music_note_outlined),
                                ChipData(
                                    FFLocalizations.of(context).getText(
                                      'oupt5mkm' /* Jazz */,
                                    ),
                                    FontAwesomeIcons.headset),
                                ChipData(
                                    FFLocalizations.of(context).getText(
                                      'ii6nfhnj' /* Soft */,
                                    ),
                                    FontAwesomeIcons.music),
                                ChipData(
                                    FFLocalizations.of(context).getText(
                                      'q7dnrh5s' /* Lo-fi */,
                                    ),
                                    Icons.library_music_outlined),
                                ChipData(
                                    FFLocalizations.of(context).getText(
                                      'pp2r2i5u' /* English */,
                                    ),
                                    Icons.language_sharp),
                                ChipData(
                                    FFLocalizations.of(context).getText(
                                      'geuk5x34' /* Hindi */,
                                    ),
                                    Icons.language_sharp),
                                ChipData(FFLocalizations.of(context).getText(
                                  'x2yopog4' /* Playing an instrument */,
                                )),
                                ChipData(FFLocalizations.of(context).getText(
                                  '04a0b8tg' /* Singing */,
                                )),
                                ChipData(FFLocalizations.of(context).getText(
                                  '33o60vyk' /* Hip-hop */,
                                )),
                                ChipData(FFLocalizations.of(context).getText(
                                  'e24ftu0g' /* Electronic music */,
                                )),
                                ChipData(FFLocalizations.of(context).getText(
                                  'ermtbtg9' /* Pop music */,
                                )),
                                ChipData(FFLocalizations.of(context).getText(
                                  '9qgg2mhz' /* Folk music */,
                                ))
                              ],
                              onChanged: (val) => safeSetState(
                                  () => _model.musicValue = val?.firstOrNull),
                              selectedChipStyle: ChipStyle(
                                backgroundColor: Colors.white,
                                textStyle: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      fontFamily: FlutterFlowTheme.of(context)
                                          .bodyMediumFamily,
                                      color:
                                          FlutterFlowTheme.of(context).primary,
                                      letterSpacing: 0.0,
                                      useGoogleFonts:
                                          !FlutterFlowTheme.of(context)
                                              .bodyMediumIsCustom,
                                    ),
                                iconColor: FlutterFlowTheme.of(context).primary,
                                iconSize: 18.0,
                                elevation: 0.0,
                                borderColor:
                                    FlutterFlowTheme.of(context).primary,
                                borderRadius: BorderRadius.circular(16.0),
                              ),
                              unselectedChipStyle: ChipStyle(
                                backgroundColor: Color(0x00F902FF),
                                textStyle: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      fontFamily: FlutterFlowTheme.of(context)
                                          .bodyMediumFamily,
                                      color: Color(0xFF323A46),
                                      letterSpacing: 0.0,
                                      useGoogleFonts:
                                          !FlutterFlowTheme.of(context)
                                              .bodyMediumIsCustom,
                                    ),
                                iconColor: Color(0xFF323A46),
                                iconSize: 18.0,
                                elevation: 0.0,
                                borderColor: Color(0xFFE7EAEE),
                                borderRadius: BorderRadius.circular(16.0),
                              ),
                              chipSpacing: 12.0,
                              rowSpacing: 12.0,
                              multiselect: false,
                              alignment: WrapAlignment.start,
                              controller: _model.musicValueController ??=
                                  FormFieldController<List<String>>(
                                [],
                              ),
                              wrapped: true,
                            ),
                          ),
                          Align(
                            alignment: AlignmentDirectional(-1.0, 0.0),
                            child: Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 10.0, 0.0, 0.0),
                              child: Text(
                                FFLocalizations.of(context).getText(
                                  '2z5va213' /* Art and Creativity */,
                                ),
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      fontFamily: FlutterFlowTheme.of(context)
                                          .bodyMediumFamily,
                                      fontSize: 16.0,
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.bold,
                                      useGoogleFonts:
                                          !FlutterFlowTheme.of(context)
                                              .bodyMediumIsCustom,
                                    ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 15.0, 0.0, 0.0),
                            child: FlutterFlowChoiceChips(
                              options: [
                                ChipData(
                                    FFLocalizations.of(context).getText(
                                      'kx2sy4h2' /* Paint */,
                                    ),
                                    Icons.format_paint_outlined),
                                ChipData(
                                    FFLocalizations.of(context).getText(
                                      'syu2qzwk' /* Photography */,
                                    ),
                                    Icons.camera_enhance_outlined),
                                ChipData(
                                    FFLocalizations.of(context).getText(
                                      'l6h3mlx4' /* Videography */,
                                    ),
                                    Icons.video_camera_back_outlined),
                                ChipData(
                                    FFLocalizations.of(context).getText(
                                      '3r2ybz42' /* Abstact */,
                                    ),
                                    FontAwesomeIcons.tencentWeibo),
                                ChipData(
                                    FFLocalizations.of(context).getText(
                                      'b8t38bax' /* Therater */,
                                    ),
                                    Icons.theater_comedy_outlined),
                                ChipData(FFLocalizations.of(context).getText(
                                  '6gqfnqp3' /* Drawing and sketching */,
                                )),
                                ChipData(FFLocalizations.of(context).getText(
                                  's5axpcpp' /* Graphic design */,
                                )),
                                ChipData(FFLocalizations.of(context).getText(
                                  'hx69m0le' /* Creative writing */,
                                )),
                                ChipData(FFLocalizations.of(context).getText(
                                  'cs88yifk' /* Pottery */,
                                )),
                                ChipData(FFLocalizations.of(context).getText(
                                  'dtvogw83' /* DIY crafts */,
                                ))
                              ],
                              onChanged: (val) => safeSetState(
                                  () => _model.artValue = val?.firstOrNull),
                              selectedChipStyle: ChipStyle(
                                backgroundColor: Colors.white,
                                textStyle: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      fontFamily: FlutterFlowTheme.of(context)
                                          .bodyMediumFamily,
                                      color:
                                          FlutterFlowTheme.of(context).primary,
                                      letterSpacing: 0.0,
                                      useGoogleFonts:
                                          !FlutterFlowTheme.of(context)
                                              .bodyMediumIsCustom,
                                    ),
                                iconColor: FlutterFlowTheme.of(context).primary,
                                iconSize: 18.0,
                                elevation: 0.0,
                                borderColor:
                                    FlutterFlowTheme.of(context).primary,
                                borderRadius: BorderRadius.circular(16.0),
                              ),
                              unselectedChipStyle: ChipStyle(
                                backgroundColor: Color(0x00F902FF),
                                textStyle: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      fontFamily: FlutterFlowTheme.of(context)
                                          .bodyMediumFamily,
                                      color: Color(0xFF323A46),
                                      letterSpacing: 0.0,
                                      useGoogleFonts:
                                          !FlutterFlowTheme.of(context)
                                              .bodyMediumIsCustom,
                                    ),
                                iconColor: Color(0xFF323A46),
                                iconSize: 18.0,
                                elevation: 0.0,
                                borderColor: Color(0xFFE7EAEE),
                                borderRadius: BorderRadius.circular(16.0),
                              ),
                              chipSpacing: 12.0,
                              rowSpacing: 12.0,
                              multiselect: false,
                              alignment: WrapAlignment.start,
                              controller: _model.artValueController ??=
                                  FormFieldController<List<String>>(
                                [],
                              ),
                              wrapped: true,
                            ),
                          ),
                          Align(
                            alignment: AlignmentDirectional(-1.0, 0.0),
                            child: Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 10.0, 0.0, 0.0),
                              child: Text(
                                FFLocalizations.of(context).getText(
                                  '3lg6zub2' /* Pets */,
                                ),
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      fontFamily: FlutterFlowTheme.of(context)
                                          .bodyMediumFamily,
                                      fontSize: 16.0,
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.bold,
                                      useGoogleFonts:
                                          !FlutterFlowTheme.of(context)
                                              .bodyMediumIsCustom,
                                    ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 15.0, 0.0, 0.0),
                            child: FlutterFlowChoiceChips(
                              options: [
                                ChipData(
                                    FFLocalizations.of(context).getText(
                                      'a9y3dw49' /* Dog */,
                                    ),
                                    FontAwesomeIcons.dog),
                                ChipData(
                                    FFLocalizations.of(context).getText(
                                      '95cnwgxo' /* Cat */,
                                    ),
                                    FontAwesomeIcons.cat),
                                ChipData(
                                    FFLocalizations.of(context).getText(
                                      '921yq6uw' /* Bird */,
                                    ),
                                    FontAwesomeIcons.kiwiBird),
                                ChipData(
                                    FFLocalizations.of(context).getText(
                                      'v9qr6uls' /* Fish */,
                                    ),
                                    FontAwesomeIcons.fish),
                                ChipData(FFLocalizations.of(context).getText(
                                  's07phqwv' /* Pet grooming */,
                                )),
                                ChipData(FFLocalizations.of(context).getText(
                                  'nd61luuv' /* Exotic pets */,
                                )),
                                ChipData(FFLocalizations.of(context).getText(
                                  '2ub90jmg' /* Horseback riding */,
                                ))
                              ],
                              onChanged: (val) => safeSetState(
                                  () => _model.petsValue = val?.firstOrNull),
                              selectedChipStyle: ChipStyle(
                                backgroundColor: Colors.white,
                                textStyle: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      fontFamily: FlutterFlowTheme.of(context)
                                          .bodyMediumFamily,
                                      color:
                                          FlutterFlowTheme.of(context).primary,
                                      letterSpacing: 0.0,
                                      useGoogleFonts:
                                          !FlutterFlowTheme.of(context)
                                              .bodyMediumIsCustom,
                                    ),
                                iconColor: FlutterFlowTheme.of(context).primary,
                                iconSize: 18.0,
                                elevation: 0.0,
                                borderColor:
                                    FlutterFlowTheme.of(context).primary,
                                borderRadius: BorderRadius.circular(16.0),
                              ),
                              unselectedChipStyle: ChipStyle(
                                backgroundColor: Color(0x00F902FF),
                                textStyle: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      fontFamily: FlutterFlowTheme.of(context)
                                          .bodyMediumFamily,
                                      color: Color(0xFF323A46),
                                      letterSpacing: 0.0,
                                      useGoogleFonts:
                                          !FlutterFlowTheme.of(context)
                                              .bodyMediumIsCustom,
                                    ),
                                iconColor: Color(0xFF323A46),
                                iconSize: 18.0,
                                elevation: 0.0,
                                borderColor: Color(0xFFE7EAEE),
                                borderRadius: BorderRadius.circular(16.0),
                              ),
                              chipSpacing: 12.0,
                              rowSpacing: 12.0,
                              multiselect: false,
                              alignment: WrapAlignment.start,
                              controller: _model.petsValueController ??=
                                  FormFieldController<List<String>>(
                                [],
                              ),
                              wrapped: true,
                            ),
                          ),
                          Align(
                            alignment: AlignmentDirectional(-1.0, 0.0),
                            child: Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 10.0, 0.0, 0.0),
                              child: Text(
                                FFLocalizations.of(context).getText(
                                  '3jgdvstx' /* Outdoor Activities */,
                                ),
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      fontFamily: FlutterFlowTheme.of(context)
                                          .bodyMediumFamily,
                                      fontSize: 16.0,
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.bold,
                                      useGoogleFonts:
                                          !FlutterFlowTheme.of(context)
                                              .bodyMediumIsCustom,
                                    ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 15.0, 0.0, 0.0),
                            child: FlutterFlowChoiceChips(
                              options: [
                                ChipData(
                                    FFLocalizations.of(context).getText(
                                      'ri3yvnks' /* Hiking */,
                                    ),
                                    Icons.hiking_rounded),
                                ChipData(
                                    FFLocalizations.of(context).getText(
                                      'sd4bb7bv' /* Biking */,
                                    ),
                                    Icons.pedal_bike),
                                ChipData(
                                    FFLocalizations.of(context).getText(
                                      '9d1uc2d2' /* Traveling */,
                                    ),
                                    Icons.directions_car_outlined),
                                ChipData(
                                    FFLocalizations.of(context).getText(
                                      '5gzz2dif' /* Explorer */,
                                    ),
                                    Icons.map_outlined),
                                ChipData(FFLocalizations.of(context).getText(
                                  '93askfg7' /* Camping */,
                                )),
                                ChipData(FFLocalizations.of(context).getText(
                                  'qd9dcvgq' /* Stargazing */,
                                )),
                                ChipData(FFLocalizations.of(context).getText(
                                  '42emhj3z' /* Fishing */,
                                )),
                                ChipData(FFLocalizations.of(context).getText(
                                  'qiq2uhdk' /* Rock climbing */,
                                )),
                                ChipData(FFLocalizations.of(context).getText(
                                  'oulesggj' /* Gardening */,
                                ))
                              ],
                              onChanged: (val) => safeSetState(
                                  () => _model.outdoorValue = val?.firstOrNull),
                              selectedChipStyle: ChipStyle(
                                backgroundColor: Colors.white,
                                textStyle: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      fontFamily: FlutterFlowTheme.of(context)
                                          .bodyMediumFamily,
                                      color:
                                          FlutterFlowTheme.of(context).primary,
                                      letterSpacing: 0.0,
                                      useGoogleFonts:
                                          !FlutterFlowTheme.of(context)
                                              .bodyMediumIsCustom,
                                    ),
                                iconColor: FlutterFlowTheme.of(context).primary,
                                iconSize: 18.0,
                                elevation: 0.0,
                                borderColor:
                                    FlutterFlowTheme.of(context).primary,
                                borderRadius: BorderRadius.circular(16.0),
                              ),
                              unselectedChipStyle: ChipStyle(
                                backgroundColor: Color(0x00F902FF),
                                textStyle: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      fontFamily: FlutterFlowTheme.of(context)
                                          .bodyMediumFamily,
                                      color: Color(0xFF323A46),
                                      letterSpacing: 0.0,
                                      useGoogleFonts:
                                          !FlutterFlowTheme.of(context)
                                              .bodyMediumIsCustom,
                                    ),
                                iconColor: Color(0xFF323A46),
                                iconSize: 18.0,
                                elevation: 0.0,
                                borderColor: Color(0xFFE7EAEE),
                                borderRadius: BorderRadius.circular(16.0),
                              ),
                              chipSpacing: 12.0,
                              rowSpacing: 12.0,
                              multiselect: false,
                              alignment: WrapAlignment.start,
                              controller: _model.outdoorValueController ??=
                                  FormFieldController<List<String>>(
                                [],
                              ),
                              wrapped: true,
                            ),
                          ),
                          Align(
                            alignment: AlignmentDirectional(-1.0, 0.0),
                            child: Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 10.0, 0.0, 0.0),
                              child: Text(
                                FFLocalizations.of(context).getText(
                                  'y9mocp7p' /* Spirituality and Mindfulness */,
                                ),
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      fontFamily: FlutterFlowTheme.of(context)
                                          .bodyMediumFamily,
                                      fontSize: 16.0,
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.bold,
                                      useGoogleFonts:
                                          !FlutterFlowTheme.of(context)
                                              .bodyMediumIsCustom,
                                    ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 15.0, 0.0, 0.0),
                            child: FlutterFlowChoiceChips(
                              options: [
                                ChipData(
                                    FFLocalizations.of(context).getText(
                                      'ohhjs3d2' /* Meditation */,
                                    ),
                                    FontAwesomeIcons.fan),
                                ChipData(
                                    FFLocalizations.of(context).getText(
                                      'mz1847go' /* Yoga */,
                                    ),
                                    FontAwesomeIcons.medkit),
                                ChipData(
                                    FFLocalizations.of(context).getText(
                                      'su1uc9k6' /* Spiritual communities */,
                                    ),
                                    Icons.spa),
                                ChipData(FFLocalizations.of(context).getText(
                                  'jpd3e67d' /* Prayer */,
                                )),
                                ChipData(FFLocalizations.of(context).getText(
                                  'bx1o2h7r' /* Retreats */,
                                )),
                                ChipData(FFLocalizations.of(context).getText(
                                  'rp6s21em' /* Astrology */,
                                )),
                                ChipData(FFLocalizations.of(context).getText(
                                  'uedfczbf' /* Tarot reading */,
                                ))
                              ],
                              onChanged: (val) => safeSetState(() =>
                                  _model.spritualityValue = val?.firstOrNull),
                              selectedChipStyle: ChipStyle(
                                backgroundColor: Colors.white,
                                textStyle: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      fontFamily: FlutterFlowTheme.of(context)
                                          .bodyMediumFamily,
                                      color:
                                          FlutterFlowTheme.of(context).primary,
                                      letterSpacing: 0.0,
                                      useGoogleFonts:
                                          !FlutterFlowTheme.of(context)
                                              .bodyMediumIsCustom,
                                    ),
                                iconColor: FlutterFlowTheme.of(context).primary,
                                iconSize: 18.0,
                                elevation: 0.0,
                                borderColor:
                                    FlutterFlowTheme.of(context).primary,
                                borderRadius: BorderRadius.circular(16.0),
                              ),
                              unselectedChipStyle: ChipStyle(
                                backgroundColor: Color(0x00F902FF),
                                textStyle: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      fontFamily: FlutterFlowTheme.of(context)
                                          .bodyMediumFamily,
                                      color: Color(0xFF323A46),
                                      letterSpacing: 0.0,
                                      useGoogleFonts:
                                          !FlutterFlowTheme.of(context)
                                              .bodyMediumIsCustom,
                                    ),
                                iconColor: Color(0xFF323A46),
                                iconSize: 18.0,
                                elevation: 0.0,
                                borderColor: Color(0xFFE7EAEE),
                                borderRadius: BorderRadius.circular(16.0),
                              ),
                              chipSpacing: 20.0,
                              rowSpacing: 15.0,
                              multiselect: false,
                              alignment: WrapAlignment.start,
                              controller: _model.spritualityValueController ??=
                                  FormFieldController<List<String>>(
                                [],
                              ),
                              wrapped: true,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 80.0, 0.0, 20.0),
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
                          if ((widget.uid == null || widget.uid == '') &&
                              (widget.groupid == null))
                            InkWell(
                              splashColor: Colors.transparent,
                              focusColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap: () async {
                                logFirebaseEvent('Text_navigate_to');

                                context.pushNamed(
                                  WorkoutWidget.routeName,
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
                                  'fx6ctjzb' /* Skip */,
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
                                  if (widget.uid != null &&
                                      widget.uid != '') {
                                    logFirebaseEvent(
                                        'IconButton_update_page_state');
                                    _model
                                        .addToInterests(_model.selfcareValue!);
                                    safeSetState(() {});
                                    logFirebaseEvent(
                                        'IconButton_update_page_state');
                                    _model.addToInterests(_model.sportsValue!);
                                    safeSetState(() {});
                                    logFirebaseEvent(
                                        'IconButton_update_page_state');
                                    _model.addToInterests(_model.musicValue!);
                                    safeSetState(() {});
                                    logFirebaseEvent(
                                        'IconButton_update_page_state');
                                    _model.addToInterests(_model.artValue!);
                                    safeSetState(() {});
                                    logFirebaseEvent(
                                        'IconButton_update_page_state');
                                    _model.addToInterests(_model.petsValue!);
                                    safeSetState(() {});
                                    logFirebaseEvent(
                                        'IconButton_update_page_state');
                                    _model.addToInterests(_model.outdoorValue!);
                                    safeSetState(() {});
                                    logFirebaseEvent(
                                        'IconButton_update_page_state');
                                    _model.addToInterests(
                                        _model.spritualityValue!);
                                    safeSetState(() {});
                                    if (_model.interests.length == 7) {
                                      logFirebaseEvent(
                                          'IconButton_backend_call');
                                      await UsersTable().update(
                                        data: {
                                          'interests': _model.interests,
                                        },
                                        matchingRows: (rows) => rows.eqOrNull(
                                          'user_id',
                                          currentUserUid,
                                        ),
                                      );
                                      logFirebaseEvent(
                                          'IconButton_navigate_back');
                                      context.safePop();
                                    } else {
                                      logFirebaseEvent(
                                          'IconButton_update_page_state');
                                      _model.interests = [];
                                      safeSetState(() {});
                                    }
                                  } else if (widget.groupid != null) {
                                    logFirebaseEvent(
                                        'IconButton_update_page_state');
                                    _model
                                        .addToInterests(_model.selfcareValue!);
                                    safeSetState(() {});
                                    logFirebaseEvent(
                                        'IconButton_update_page_state');
                                    _model.addToInterests(_model.sportsValue!);
                                    safeSetState(() {});
                                    logFirebaseEvent(
                                        'IconButton_update_page_state');
                                    _model.addToInterests(_model.musicValue!);
                                    safeSetState(() {});
                                    logFirebaseEvent(
                                        'IconButton_update_page_state');
                                    _model.addToInterests(_model.artValue!);
                                    safeSetState(() {});
                                    logFirebaseEvent(
                                        'IconButton_update_page_state');
                                    _model.addToInterests(_model.petsValue!);
                                    safeSetState(() {});
                                    logFirebaseEvent(
                                        'IconButton_update_page_state');
                                    _model.addToInterests(_model.outdoorValue!);
                                    safeSetState(() {});
                                    logFirebaseEvent(
                                        'IconButton_update_page_state');
                                    _model.addToInterests(
                                        _model.spritualityValue!);
                                    safeSetState(() {});
                                    if (_model.interests.length == 7) {
                                      logFirebaseEvent(
                                          'IconButton_backend_call');
                                      await GroupsTable().update(
                                        data: {
                                          'interests': _model.interests,
                                        },
                                        matchingRows: (rows) => rows.eqOrNull(
                                          'group_id',
                                          widget.groupid,
                                        ),
                                      );
                                      logFirebaseEvent(
                                          'IconButton_navigate_back');
                                      context.safePop();
                                    } else {
                                      logFirebaseEvent(
                                          'IconButton_update_page_state');
                                      _model.interests = [];
                                      safeSetState(() {});
                                    }
                                  } else {
                                    logFirebaseEvent(
                                        'IconButton_update_page_state');
                                    _model
                                        .addToInterests(_model.selfcareValue!);
                                    safeSetState(() {});
                                    logFirebaseEvent(
                                        'IconButton_update_page_state');
                                    _model.addToInterests(_model.sportsValue!);
                                    safeSetState(() {});
                                    logFirebaseEvent(
                                        'IconButton_update_page_state');
                                    _model.addToInterests(_model.musicValue!);
                                    safeSetState(() {});
                                    logFirebaseEvent(
                                        'IconButton_update_page_state');
                                    _model.addToInterests(_model.artValue!);
                                    safeSetState(() {});
                                    logFirebaseEvent(
                                        'IconButton_update_page_state');
                                    _model.addToInterests(_model.petsValue!);
                                    safeSetState(() {});
                                    logFirebaseEvent(
                                        'IconButton_update_page_state');
                                    _model.addToInterests(_model.outdoorValue!);
                                    safeSetState(() {});
                                    logFirebaseEvent(
                                        'IconButton_update_page_state');
                                    _model.addToInterests(
                                        _model.spritualityValue!);
                                    safeSetState(() {});
                                    if (_model.interests.length == 7) {
                                      logFirebaseEvent(
                                          'IconButton_backend_call');
                                      await UsersTable().update(
                                        data: {
                                          'interests': _model.interests,
                                        },
                                        matchingRows: (rows) => rows.eqOrNull(
                                          'user_id',
                                          currentUserUid,
                                        ),
                                      );
                                      if (widget.ifonlyfogroups) {
                                        logFirebaseEvent(
                                            'IconButton_navigate_to');

                                        context.goNamed(
                                          BioWidget.routeName,
                                          extra: <String, dynamic>{
                                            kTransitionInfoKey: TransitionInfo(
                                              hasTransition: true,
                                              transitionType: PageTransitionType
                                                  .leftToRight,
                                            ),
                                          },
                                        );
                                      } else {
                                        logFirebaseEvent(
                                            'IconButton_navigate_to');

                                        context.goNamed(
                                          WorkoutWidget.routeName,
                                          extra: <String, dynamic>{
                                            kTransitionInfoKey: TransitionInfo(
                                              hasTransition: true,
                                              transitionType: PageTransitionType
                                                  .leftToRight,
                                            ),
                                          },
                                        );
                                      }
                                    } else {
                                      logFirebaseEvent(
                                          'IconButton_update_page_state');
                                      _model.interests = [];
                                      safeSetState(() {});
                                    }
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import '/flutter_flow/flutter_flow_choice_chips.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'groupfilters_model.dart';
export 'groupfilters_model.dart';

class GroupfiltersWidget extends StatefulWidget {
  const GroupfiltersWidget({
    super.key,
    int? tabindex,
  }) : this.tabindex = tabindex ?? 0;

  final int tabindex;

  static String routeName = 'groupfilters';
  static String routePath = '/groupfilters';

  @override
  State<GroupfiltersWidget> createState() => _GroupfiltersWidgetState();
}

class _GroupfiltersWidgetState extends State<GroupfiltersWidget> {
  late GroupfiltersModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => GroupfiltersModel());

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
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(50.0),
          child: AppBar(
            backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
            iconTheme:
                IconThemeData(color: FlutterFlowTheme.of(context).secondary),
            automaticallyImplyLeading: true,
            leading: InkWell(
              splashColor: Colors.transparent,
              focusColor: Colors.transparent,
              hoverColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onTap: () async {
                logFirebaseEvent('Icon_navigate_back');
                context.safePop();
              },
              child: Icon(
                Icons.close,
                color: FlutterFlowTheme.of(context).secondary,
                size: 24.0,
              ),
            ),
            title: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: 247.0,
                  height: 50.0,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding:
                            EdgeInsetsDirectional.fromSTEB(5.0, 0.0, 0.0, 0.0),
                        child: Text(
                          FFLocalizations.of(context).getText(
                            'f2jmgvht' /* Apply Filters */,
                          ),
                          style: FlutterFlowTheme.of(context)
                              .bodyMedium
                              .override(
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                fontSize: 18.0,
                                letterSpacing: 0.0,
                                fontWeight: FontWeight.bold,
                                useGoogleFonts: !FlutterFlowTheme.of(context)
                                    .bodyMediumIsCustom,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            actions: [],
            centerTitle: true,
            toolbarHeight: MediaQuery.sizeOf(context).height * 1.0,
            elevation: 1.0,
          ),
        ),
        body: SafeArea(
          top: true,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  width: MediaQuery.sizeOf(context).width * 1.0,
                  height: 50.0,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                  ),
                  child: Align(
                    alignment: AlignmentDirectional(-1.0, 0.0),
                    child: Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(12.0, 0.0, 12.0, 0.0),
                      child: Text(
                        FFLocalizations.of(context).getText(
                          'qu4h7kmf' /* To change the category type, s... */,
                        ),
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily:
                                  FlutterFlowTheme.of(context).bodyMediumFamily,
                              fontSize: 16.0,
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.w600,
                              useGoogleFonts: !FlutterFlowTheme.of(context)
                                  .bodyMediumIsCustom,
                            ),
                      ),
                    ),
                  ),
                ),
                Material(
                  color: Colors.transparent,
                  child: SwitchListTile.adaptive(
                    value: _model.premiuValue1 ??= false,
                    onChanged: (newValue) async {
                      safeSetState(() => _model.premiuValue1 = newValue);
                    },
                    title: Text(
                      FFLocalizations.of(context).getText(
                        'bgzfw17z' /* Premium */,
                      ),
                      style: FlutterFlowTheme.of(context).titleLarge.override(
                            fontFamily:
                                FlutterFlowTheme.of(context).titleLargeFamily,
                            letterSpacing: 0.0,
                            useGoogleFonts: !FlutterFlowTheme.of(context)
                                .titleLargeIsCustom,
                          ),
                    ),
                    subtitle: Text(
                      FFLocalizations.of(context).getText(
                        'jzvkdvkf' /* Show only premium groups */,
                      ),
                      style: FlutterFlowTheme.of(context).labelMedium.override(
                            fontFamily:
                                FlutterFlowTheme.of(context).labelMediumFamily,
                            letterSpacing: 0.0,
                            useGoogleFonts: !FlutterFlowTheme.of(context)
                                .labelMediumIsCustom,
                          ),
                    ),
                    tileColor: FlutterFlowTheme.of(context).secondaryBackground,
                    activeColor: FlutterFlowTheme.of(context).primary,
                    activeTrackColor: FlutterFlowTheme.of(context).accent1,
                    dense: false,
                    controlAffinity: ListTileControlAffinity.trailing,
                  ),
                ),
                Material(
                  color: Colors.transparent,
                  child: SwitchListTile.adaptive(
                    value: _model.premiuValue2 ??= false,
                    onChanged: (newValue) async {
                      safeSetState(() => _model.premiuValue2 = newValue);
                    },
                    title: Text(
                      FFLocalizations.of(context).getText(
                        'fh025lpi' /* Show near */,
                      ),
                      style: FlutterFlowTheme.of(context).titleLarge.override(
                            fontFamily:
                                FlutterFlowTheme.of(context).titleLargeFamily,
                            letterSpacing: 0.0,
                            useGoogleFonts: !FlutterFlowTheme.of(context)
                                .titleLargeIsCustom,
                          ),
                    ),
                    subtitle: Text(
                      FFLocalizations.of(context).getText(
                        'kuy14017' /* Only nearby groups will be sho... */,
                      ),
                      style: FlutterFlowTheme.of(context).labelMedium.override(
                            fontFamily:
                                FlutterFlowTheme.of(context).labelMediumFamily,
                            letterSpacing: 0.0,
                            useGoogleFonts: !FlutterFlowTheme.of(context)
                                .labelMediumIsCustom,
                          ),
                    ),
                    tileColor: FlutterFlowTheme.of(context).secondaryBackground,
                    activeColor: FlutterFlowTheme.of(context).primary,
                    activeTrackColor: FlutterFlowTheme.of(context).accent1,
                    dense: false,
                    controlAffinity: ListTileControlAffinity.trailing,
                  ),
                ),
                Align(
                  alignment: AlignmentDirectional(-1.0, 0.0),
                  child: Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Text(
                      FFLocalizations.of(context).getText(
                        'gv9cyr0b' /* Choose Interests */,
                      ),
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily:
                                FlutterFlowTheme.of(context).bodyMediumFamily,
                            fontSize: 18.0,
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.w600,
                            useGoogleFonts: !FlutterFlowTheme.of(context)
                                .bodyMediumIsCustom,
                          ),
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.sizeOf(context).width * 1.0,
                  height: 410.0,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                  ),
                  child: Align(
                    alignment: AlignmentDirectional(-1.0, 0.0),
                    child: Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(12.0, 0.0, 12.0, 0.0),
                      child: SingleChildScrollView(
                        primary: false,
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Align(
                              alignment: AlignmentDirectional(-1.0, 0.0),
                              child: Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 5.0, 0.0, 0.0),
                                child: Text(
                                  FFLocalizations.of(context).getText(
                                    't1z5qj6k' /* Self Care */,
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
                                        'gt4eopon' /* Running */,
                                      ),
                                      Icons.directions_run_rounded),
                                  ChipData(
                                      FFLocalizations.of(context).getText(
                                        '6db2glbu' /* Gym */,
                                      ),
                                      Icons.fitness_center_sharp),
                                  ChipData(
                                      FFLocalizations.of(context).getText(
                                        'ab8sjpjv' /* Physical fitness */,
                                      ),
                                      Icons.directions_walk_rounded),
                                  ChipData(
                                      FFLocalizations.of(context).getText(
                                        '35odajek' /* Hygiene */,
                                      ),
                                      Icons.back_hand_outlined),
                                  ChipData(
                                      FFLocalizations.of(context).getText(
                                        'rrfqkby4' /* Muscle relaxation */,
                                      ),
                                      Icons.headset_sharp),
                                  ChipData(FFLocalizations.of(context).getText(
                                    'l2su8ujg' /* Meditation */,
                                  )),
                                  ChipData(FFLocalizations.of(context).getText(
                                    'm66zqpyh' /* Healthy cooking */,
                                  )),
                                  ChipData(FFLocalizations.of(context).getText(
                                    '31luunft' /* Yoga */,
                                  )),
                                  ChipData(FFLocalizations.of(context).getText(
                                    'fgu5jr5p' /* Reading  */,
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
                                    't9m954jc' /* Sports */,
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
                                        'h5kcv93v' /* Basketball */,
                                      ),
                                      Icons.sports_basketball_outlined),
                                  ChipData(
                                      FFLocalizations.of(context).getText(
                                        '0mtoiyho' /* Cricket */,
                                      ),
                                      Icons.sports_cricket_outlined),
                                  ChipData(
                                      FFLocalizations.of(context).getText(
                                        '1yokpv17' /* Soccer */,
                                      ),
                                      Icons.sports_soccer_rounded),
                                  ChipData(
                                      FFLocalizations.of(context).getText(
                                        '31zrdpjs' /* Tennis */,
                                      ),
                                      Icons.sports_tennis_rounded),
                                  ChipData(FFLocalizations.of(context).getText(
                                    'qp6mlsl4' /* Swimming */,
                                  )),
                                  ChipData(FFLocalizations.of(context).getText(
                                    '2kahxw7t' /* Volleyball */,
                                  )),
                                  ChipData(FFLocalizations.of(context).getText(
                                    'pa8khk76' /* Cycling */,
                                  )),
                                  ChipData(FFLocalizations.of(context).getText(
                                    '1nssib42' /* Golf */,
                                  )),
                                  ChipData(FFLocalizations.of(context).getText(
                                    'p3bq0kgv' /* Baseball */,
                                  ))
                                ],
                                onChanged: (val) => safeSetState(() =>
                                    _model.sportsValue = val?.firstOrNull),
                                selectedChipStyle: ChipStyle(
                                  backgroundColor: Color(0x00000000),
                                  textStyle: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontFamily: FlutterFlowTheme.of(context)
                                            .bodyMediumFamily,
                                        color: FlutterFlowTheme.of(context)
                                            .primary,
                                        letterSpacing: 0.0,
                                        useGoogleFonts:
                                            !FlutterFlowTheme.of(context)
                                                .bodyMediumIsCustom,
                                      ),
                                  iconColor:
                                      FlutterFlowTheme.of(context).primary,
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
                                    '04p46d3p' /* Music */,
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
                                        'c66gvkk0' /* Rock */,
                                      ),
                                      Icons.music_note_outlined),
                                  ChipData(
                                      FFLocalizations.of(context).getText(
                                        'a5vt0b5j' /* Jazz */,
                                      ),
                                      FontAwesomeIcons.headset),
                                  ChipData(
                                      FFLocalizations.of(context).getText(
                                        'asz1hg3n' /* Soft */,
                                      ),
                                      FontAwesomeIcons.music),
                                  ChipData(
                                      FFLocalizations.of(context).getText(
                                        'ticldcf9' /* Lo-fi */,
                                      ),
                                      Icons.library_music_outlined),
                                  ChipData(
                                      FFLocalizations.of(context).getText(
                                        'y6uwibio' /* English */,
                                      ),
                                      Icons.language_sharp),
                                  ChipData(
                                      FFLocalizations.of(context).getText(
                                        'g5w4c3ir' /* Hindi */,
                                      ),
                                      Icons.language_sharp),
                                  ChipData(FFLocalizations.of(context).getText(
                                    'vur4306u' /* Playing an instrument */,
                                  )),
                                  ChipData(FFLocalizations.of(context).getText(
                                    '8y25fkw6' /* Singing */,
                                  )),
                                  ChipData(FFLocalizations.of(context).getText(
                                    'ivh5j1i3' /* Hip-hop */,
                                  )),
                                  ChipData(FFLocalizations.of(context).getText(
                                    'ov4w1hu1' /* Electronic music */,
                                  )),
                                  ChipData(FFLocalizations.of(context).getText(
                                    '5wg72kqd' /* Pop music */,
                                  )),
                                  ChipData(FFLocalizations.of(context).getText(
                                    'qtz5bkje' /* Folk music */,
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
                                        color: FlutterFlowTheme.of(context)
                                            .primary,
                                        letterSpacing: 0.0,
                                        useGoogleFonts:
                                            !FlutterFlowTheme.of(context)
                                                .bodyMediumIsCustom,
                                      ),
                                  iconColor:
                                      FlutterFlowTheme.of(context).primary,
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
                                    '7qgvso1r' /* Art and Creativity */,
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
                                        'iet0q45r' /* Paint */,
                                      ),
                                      Icons.format_paint_outlined),
                                  ChipData(
                                      FFLocalizations.of(context).getText(
                                        'qpwqg5bs' /* Photography */,
                                      ),
                                      Icons.camera_enhance_outlined),
                                  ChipData(
                                      FFLocalizations.of(context).getText(
                                        '8ak1zcsw' /* Videography */,
                                      ),
                                      Icons.video_camera_back_outlined),
                                  ChipData(
                                      FFLocalizations.of(context).getText(
                                        '3ike0cvo' /* Abstact */,
                                      ),
                                      FontAwesomeIcons.tencentWeibo),
                                  ChipData(
                                      FFLocalizations.of(context).getText(
                                        '08lxgfyn' /* Therater */,
                                      ),
                                      Icons.theater_comedy_outlined),
                                  ChipData(FFLocalizations.of(context).getText(
                                    '3uq2iyc6' /* Drawing and sketching */,
                                  )),
                                  ChipData(FFLocalizations.of(context).getText(
                                    '60yzl2b8' /* Graphic design */,
                                  )),
                                  ChipData(FFLocalizations.of(context).getText(
                                    'bosoqhrd' /* Creative writing */,
                                  )),
                                  ChipData(FFLocalizations.of(context).getText(
                                    '4sfvoll4' /* Pottery */,
                                  )),
                                  ChipData(FFLocalizations.of(context).getText(
                                    'l0k2ed52' /* DIY crafts
 */
                                    ,
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
                                        color: FlutterFlowTheme.of(context)
                                            .primary,
                                        letterSpacing: 0.0,
                                        useGoogleFonts:
                                            !FlutterFlowTheme.of(context)
                                                .bodyMediumIsCustom,
                                      ),
                                  iconColor:
                                      FlutterFlowTheme.of(context).primary,
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
                                    'o6gclsps' /* Pets */,
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
                                        'xkk3hhkz' /* Dog */,
                                      ),
                                      FontAwesomeIcons.dog),
                                  ChipData(
                                      FFLocalizations.of(context).getText(
                                        '53rllp1n' /* Cat */,
                                      ),
                                      FontAwesomeIcons.cat),
                                  ChipData(
                                      FFLocalizations.of(context).getText(
                                        '48v6sxis' /* Bird */,
                                      ),
                                      FontAwesomeIcons.kiwiBird),
                                  ChipData(
                                      FFLocalizations.of(context).getText(
                                        's71hz45u' /* Fish */,
                                      ),
                                      FontAwesomeIcons.fish),
                                  ChipData(FFLocalizations.of(context).getText(
                                    '52ihdoh5' /* Pet grooming */,
                                  )),
                                  ChipData(FFLocalizations.of(context).getText(
                                    'nvp9n30l' /* Exotic pets */,
                                  )),
                                  ChipData(FFLocalizations.of(context).getText(
                                    '6a2muu9j' /* Horseback riding */,
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
                                        color: FlutterFlowTheme.of(context)
                                            .primary,
                                        letterSpacing: 0.0,
                                        useGoogleFonts:
                                            !FlutterFlowTheme.of(context)
                                                .bodyMediumIsCustom,
                                      ),
                                  iconColor:
                                      FlutterFlowTheme.of(context).primary,
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
                                    '2i7xgxk7' /* Outdoor Activities */,
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
                                        'aran4sc3' /* Hiking */,
                                      ),
                                      Icons.hiking_rounded),
                                  ChipData(
                                      FFLocalizations.of(context).getText(
                                        'zx2wxfds' /* Biking */,
                                      ),
                                      Icons.pedal_bike),
                                  ChipData(
                                      FFLocalizations.of(context).getText(
                                        'uzlvb6uv' /* Traveling */,
                                      ),
                                      Icons.directions_car_outlined),
                                  ChipData(
                                      FFLocalizations.of(context).getText(
                                        '0ut9hm8m' /* Explorer */,
                                      ),
                                      Icons.map_outlined),
                                  ChipData(FFLocalizations.of(context).getText(
                                    'qaklrnuz' /* Camping */,
                                  )),
                                  ChipData(FFLocalizations.of(context).getText(
                                    'gwtnsgqy' /* Stargazing */,
                                  )),
                                  ChipData(FFLocalizations.of(context).getText(
                                    'r8dt61b8' /* Fishing */,
                                  )),
                                  ChipData(FFLocalizations.of(context).getText(
                                    'xhmtjr8c' /* Rock climbing */,
                                  )),
                                  ChipData(FFLocalizations.of(context).getText(
                                    'e9rnr1po' /* Gardening */,
                                  ))
                                ],
                                onChanged: (val) => safeSetState(() =>
                                    _model.outdoorValue = val?.firstOrNull),
                                selectedChipStyle: ChipStyle(
                                  backgroundColor: Colors.white,
                                  textStyle: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontFamily: FlutterFlowTheme.of(context)
                                            .bodyMediumFamily,
                                        color: FlutterFlowTheme.of(context)
                                            .primary,
                                        letterSpacing: 0.0,
                                        useGoogleFonts:
                                            !FlutterFlowTheme.of(context)
                                                .bodyMediumIsCustom,
                                      ),
                                  iconColor:
                                      FlutterFlowTheme.of(context).primary,
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
                                    'qhev2f02' /* Spirituality and Mindfulness */,
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
                                        '4wp8uwld' /* Meditation */,
                                      ),
                                      FontAwesomeIcons.fan),
                                  ChipData(
                                      FFLocalizations.of(context).getText(
                                        'c513kix8' /* Yoga */,
                                      ),
                                      FontAwesomeIcons.medkit),
                                  ChipData(
                                      FFLocalizations.of(context).getText(
                                        'h086pwnl' /* Spiritual communities */,
                                      ),
                                      Icons.spa),
                                  ChipData(FFLocalizations.of(context).getText(
                                    'e2neh1en' /* Prayer */,
                                  )),
                                  ChipData(FFLocalizations.of(context).getText(
                                    'vh4rzu5t' /* Retreats */,
                                  )),
                                  ChipData(FFLocalizations.of(context).getText(
                                    '4qi42u2b' /* Astrology */,
                                  )),
                                  ChipData(FFLocalizations.of(context).getText(
                                    'uthuzp3s' /* Tarot reading */,
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
                                        color: FlutterFlowTheme.of(context)
                                            .primary,
                                        letterSpacing: 0.0,
                                        useGoogleFonts:
                                            !FlutterFlowTheme.of(context)
                                                .bodyMediumIsCustom,
                                      ),
                                  iconColor:
                                      FlutterFlowTheme.of(context).primary,
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
                                controller:
                                    _model.spritualityValueController ??=
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
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 12.0, 0.0, 0.0),
                  child: FFButtonWidget(
                    onPressed: () {
                      print('Button pressed ...');
                    },
                    text: FFLocalizations.of(context).getText(
                      'y5etwmna' /* Apply Filters */,
                    ),
                    options: FFButtonOptions(
                      width: MediaQuery.sizeOf(context).width * 0.9,
                      height: 50.0,
                      padding:
                          EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
                      iconPadding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                      color: FlutterFlowTheme.of(context).secondary,
                      textStyle: FlutterFlowTheme.of(context)
                          .titleSmall
                          .override(
                            fontFamily:
                                FlutterFlowTheme.of(context).titleSmallFamily,
                            color: Colors.white,
                            letterSpacing: 0.0,
                            useGoogleFonts: !FlutterFlowTheme.of(context)
                                .titleSmallIsCustom,
                          ),
                      elevation: 3.0,
                      borderSide: BorderSide(
                        color: Colors.transparent,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(8.0),
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

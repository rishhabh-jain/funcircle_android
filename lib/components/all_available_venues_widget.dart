import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/custom_functions.dart' as functions;
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'all_available_venues_model.dart';
export 'all_available_venues_model.dart';

class AllAvailableVenuesWidget extends StatefulWidget {
  const AllAvailableVenuesWidget({
    super.key,
    required this.tickets,
    int? sportid,
  }) : this.sportid = sportid ?? 90;

  final List<TicketsRow>? tickets;
  final int sportid;

  @override
  State<AllAvailableVenuesWidget> createState() =>
      _AllAvailableVenuesWidgetState();
}

class _AllAvailableVenuesWidgetState extends State<AllAvailableVenuesWidget> {
  late AllAvailableVenuesModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AllAvailableVenuesModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      primary: false,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Builder(
            builder: (context) {
              final allVenues = functions
                      .getAllVenueOptions(
                          widget.tickets?.toList(), widget.sportid)
                      ?.toList() ??
                  [];

              return SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: List.generate(allVenues.length, (allVenuesIndex) {
                    final allVenuesItem = allVenues[allVenuesIndex];
                    return Padding(
                      padding: EdgeInsets.all(12.0),
                      child: FutureBuilder<List<VenuesRow>>(
                        future: VenuesTable().querySingleRow(
                          queryFn: (q) => q.eqOrNull(
                            'id',
                            getJsonField(
                              allVenuesItem,
                              r'''$.venueid''',
                            ),
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
                          List<VenuesRow> containerVenuesRowList =
                              snapshot.data!;

                          final containerVenuesRow =
                              containerVenuesRowList.isNotEmpty
                                  ? containerVenuesRowList.first
                                  : null;

                          return Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16.0),
                              border: Border.all(
                                color: Color(0xFF5B5B5B),
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(12.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    valueOrDefault<String>(
                                      containerVenuesRow?.venueName,
                                      'Venue Name',
                                    ),
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          fontFamily:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMediumFamily,
                                          color: FlutterFlowTheme.of(context)
                                              .tertiary,
                                          fontSize: 16.0,
                                          letterSpacing: 0.0,
                                          useGoogleFonts:
                                              !FlutterFlowTheme.of(context)
                                                  .bodyMediumIsCustom,
                                        ),
                                  ),
                                  Text(
                                    FFLocalizations.of(context).getText(
                                      '8uwf26uf' /* Nearest Venue */,
                                    ),
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          fontFamily:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMediumFamily,
                                          color: Color(0xFF0C85FF),
                                          letterSpacing: 0.0,
                                          useGoogleFonts:
                                              !FlutterFlowTheme.of(context)
                                                  .bodyMediumIsCustom,
                                        ),
                                  ),
                                ].divide(SizedBox(height: 12.0)),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  }),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

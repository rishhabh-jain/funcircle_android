import 'package:flutter/material.dart';
import 'dart:ui';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'book_courts_model.dart';
export 'book_courts_model.dart';

class BookCourtsWidget extends StatefulWidget {
  const BookCourtsWidget({super.key});

  @override
  State<BookCourtsWidget> createState() => _BookCourtsWidgetState();
}

class _BookCourtsWidgetState extends State<BookCourtsWidget> {
  late BookCourtsModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => BookCourtsModel());
    _model.searchController ??= TextEditingController();
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<VenuesRow>>(
      future: VenuesTable().queryRows(
        queryFn: (q) => q.order('venue_name', ascending: true),
      ),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Scaffold(
            backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
            body: Center(
              child: SizedBox(
                width: 50.0,
                height: 50.0,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    FlutterFlowTheme.of(context).primary,
                  ),
                ),
              ),
            ),
          );
        }

        List<VenuesRow> venues = snapshot.data!;

        // Apply search filter
        if (_model.searchController != null && _model.searchController!.text.isNotEmpty) {
          final searchText = _model.searchController!.text.toLowerCase();
          venues = venues.where((venue) {
            final venueName = venue.venueName?.toLowerCase() ?? '';
            final location = venue.location?.toLowerCase() ?? '';
            return venueName.contains(searchText) ||
                location.contains(searchText);
          }).toList();
        }

        return GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: Scaffold(
            key: scaffoldKey,
            backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
            body: SafeArea(
              top: true,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Book Courts',
                            style: FlutterFlowTheme.of(context)
                                .headlineLarge
                                .override(
                                  fontFamily:
                                      FlutterFlowTheme.of(context).headlineLargeFamily,
                                  color: Colors.white,
                                  fontSize: 32.0,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.0,
                                  useGoogleFonts: !FlutterFlowTheme.of(context)
                                      .headlineLargeIsCustom,
                                ),
                          ),
                          SizedBox(height: 8.0),
                          Text(
                            'Find and book courts near you',
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  fontFamily:
                                      FlutterFlowTheme.of(context).bodyMediumFamily,
                                  color: Colors.white.withValues(alpha: 0.7),
                                  fontSize: 14.0,
                                  letterSpacing: 0.0,
                                  useGoogleFonts: !FlutterFlowTheme.of(context)
                                      .bodyMediumIsCustom,
                                ),
                          ),
                        ],
                      ),
                    ),

                    // Search Bar
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12.0),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.black.withValues(alpha: 0.7),
                                  Colors.black.withValues(alpha: 0.85),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(12.0),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.3),
                                width: 1,
                              ),
                            ),
                            child: TextField(
                              controller: _model.searchController,
                              onChanged: (_) => setState(() {}),
                              style: TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                hintText: 'Search venues, location...',
                                hintStyle: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.5),
                                ),
                                prefixIcon: Icon(
                                  Icons.search,
                                  color: FlutterFlowTheme.of(context).primary,
                                ),
                                suffixIcon: _model.searchController != null && _model.searchController!.text.isNotEmpty
                                    ? IconButton(
                                        icon: Icon(
                                          Icons.clear,
                                          color: Colors.white.withValues(alpha: 0.7),
                                        ),
                                        onPressed: () {
                                          _model.searchController?.clear();
                                          setState(() {});
                                        },
                                      )
                                    : null,
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 16.0,
                                  vertical: 14.0,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 20.0),

                    // Results count
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        '${venues.length} ${venues.length == 1 ? 'venue' : 'venues'} found',
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily:
                                  FlutterFlowTheme.of(context).bodyMediumFamily,
                              color: Colors.white.withValues(alpha: 0.7),
                              fontSize: 14.0,
                              letterSpacing: 0.0,
                              useGoogleFonts: !FlutterFlowTheme.of(context)
                                  .bodyMediumIsCustom,
                            ),
                      ),
                    ),

                    SizedBox(height: 12.0),

                    // Venues List
                    ListView.builder(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: venues.length,
                      itemBuilder: (context, index) {
                        final venue = venues[index];
                        return Padding(
                          padding: EdgeInsets.only(bottom: 16.0),
                          child: _buildVenueCard(venue),
                        );
                      },
                    ),

                    SizedBox(height: 20.0),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildVenueCard(VenuesRow venue) {
    final hasImages = venue.images.isNotEmpty;
    final imageUrl = hasImages ? venue.images.first : null;

    return InkWell(
      onTap: () {
        // Navigate to venue detail or booking page
        context.pushNamed(
          'VenueDetail',
          queryParameters: {
            'venueId': venue.id.toString(),
          },
        );
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.0),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.black.withValues(alpha: 0.7),
                  Colors.black.withValues(alpha: 0.85),
                ],
              ),
              borderRadius: BorderRadius.circular(16.0),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Venue Image
                if (imageUrl != null)
                  ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16.0),
                      topRight: Radius.circular(16.0),
                    ),
                    child: CachedNetworkImage(
                      imageUrl: imageUrl,
                      width: double.infinity,
                      height: 180.0,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: Colors.grey.withValues(alpha: 0.3),
                        child: Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              FlutterFlowTheme.of(context).primary,
                            ),
                          ),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: Colors.grey.withValues(alpha: 0.3),
                        child: Icon(
                          Icons.location_on,
                          size: 60,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  )
                else
                  Container(
                    height: 180.0,
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context)
                          .primary
                          .withValues(alpha: 0.2),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16.0),
                        topRight: Radius.circular(16.0),
                      ),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.sports_tennis,
                        size: 60,
                        color: FlutterFlowTheme.of(context).primary,
                      ),
                    ),
                  ),

                // Venue Details
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Venue Name
                      Text(
                        venue.venueName ?? 'Unnamed Venue',
                        style: FlutterFlowTheme.of(context)
                            .headlineSmall
                            .override(
                              fontFamily: FlutterFlowTheme.of(context)
                                  .headlineSmallFamily,
                              color: Colors.white,
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.0,
                              useGoogleFonts: !FlutterFlowTheme.of(context)
                                  .headlineSmallIsCustom,
                            ),
                      ),

                      SizedBox(height: 8.0),

                      // Location
                      if (venue.location != null)
                        Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              size: 16,
                              color: Colors.white.withValues(alpha: 0.7),
                            ),
                            SizedBox(width: 4.0),
                            Expanded(
                              child: Text(
                                venue.location!,
                                style: FlutterFlowTheme.of(context)
                                    .bodySmall
                                    .override(
                                      fontFamily: FlutterFlowTheme.of(context)
                                          .bodySmallFamily,
                                      color: Colors.white.withValues(alpha: 0.7),
                                      fontSize: 13.0,
                                      letterSpacing: 0.0,
                                      useGoogleFonts:
                                          !FlutterFlowTheme.of(context)
                                              .bodySmallIsCustom,
                                    ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),

                    ],
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

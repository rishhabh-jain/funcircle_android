import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '../models/venue_marker_model.dart';
import '../services/location_service.dart';
import '../pages/venue_details_page.dart';

/// Bottom sheet showing venue information
class VenueInfoSheet extends StatelessWidget {
  final VenueMarkerModel venue;
  final double? distanceKm;

  const VenueInfoSheet({
    super.key,
    required this.venue,
    this.distanceKm,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Drag handle
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Venue image
            if (venue.images != null && venue.images!.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: CachedNetworkImage(
                  imageUrl: venue.images!.first,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    height: 200,
                    color: Colors.grey[200],
                    child: const Center(child: CircularProgressIndicator()),
                  ),
                  errorWidget: (context, url, error) => Container(
                    height: 200,
                    color: Colors.grey[200],
                    child: const Icon(Icons.location_city, size: 50),
                  ),
                ),
              ),
            const SizedBox(height: 16),

            // Venue name
            Text(
              venue.name,
              style: FlutterFlowTheme.of(context).headlineSmall,
            ),
            const SizedBox(height: 8),

            // Distance
            if (distanceKm != null)
              Row(
                children: [
                  const Icon(Icons.location_on, size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(
                    LocationService.formatDistance(distanceKm!),
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontFamily: 'Readex Pro',
                          color: Colors.grey,
                        ),
                  ),
                ],
              ),
            const SizedBox(height: 16),

            // Address
            if (venue.address != null)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.place, size: 20, color: Colors.grey),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      venue.address!,
                      style: FlutterFlowTheme.of(context).bodyMedium,
                    ),
                  ),
                ],
              ),
            const SizedBox(height: 16),

            // Description
            if (venue.description != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'About',
                    style: FlutterFlowTheme.of(context).titleSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    venue.description!,
                    style: FlutterFlowTheme.of(context).bodyMedium,
                  ),
                  const SizedBox(height: 16),
                ],
              ),

            // Action buttons
            Row(
              children: [
                Expanded(
                  child: FFButtonWidget(
                    onPressed: () async {
                      final url = Uri.parse(
                        'https://www.google.com/maps/search/?api=1&query=${venue.latitude},${venue.longitude}',
                      );
                      if (await canLaunchUrl(url)) {
                        await launchUrl(url,
                            mode: LaunchMode.externalApplication);
                      }
                    },
                    text: 'Directions',
                    icon: const Icon(Icons.directions, size: 20),
                    options: FFButtonOptions(
                      height: 45,
                      color: FlutterFlowTheme.of(context).primary,
                      textStyle:
                          FlutterFlowTheme.of(context).titleSmall.override(
                                fontFamily: 'Readex Pro',
                                color: Colors.white,
                              ),
                      elevation: 2,
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                FFButtonWidget(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => VenueDetailsPage(
                          venue: venue,
                          distanceKm: distanceKm,
                        ),
                      ),
                    );
                  },
                  text: '',
                  icon: const Icon(Icons.info_outline, size: 24),
                  options: FFButtonOptions(
                    width: 45,
                    height: 45,
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                    textStyle: FlutterFlowTheme.of(context).titleSmall,
                    elevation: 2,
                    borderSide: BorderSide(
                      color: FlutterFlowTheme.of(context).primary,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

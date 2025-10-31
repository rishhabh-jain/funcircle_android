import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '../models/venue_marker_model.dart';
import '../services/location_service.dart';
/// Full page showing comprehensive venue details
class VenueDetailsPage extends StatefulWidget {
  final VenueMarkerModel venue;
  final double? distanceKm;

  const VenueDetailsPage({
    super.key,
    required this.venue,
    this.distanceKm,
  });

  @override
  State<VenueDetailsPage> createState() => _VenueDetailsPageState();
}

class _VenueDetailsPageState extends State<VenueDetailsPage> {
  int _currentImageIndex = 0;
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hasImages =
        widget.venue.images != null && widget.venue.images!.isNotEmpty;

    return Scaffold(
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      body: CustomScrollView(
        slivers: [
          // App bar with image carousel
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: FlutterFlowTheme.of(context).primary,
            leading: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.5),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.arrow_back, color: Colors.white),
              ),
              onPressed: () => Navigator.pop(context),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  if (hasImages)
                    PageView.builder(
                      controller: _pageController,
                      onPageChanged: (index) {
                        setState(() => _currentImageIndex = index);
                      },
                      itemCount: widget.venue.images!.length,
                      itemBuilder: (context, index) {
                        return CachedNetworkImage(
                          imageUrl: widget.venue.images![index],
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            color: Colors.grey[300],
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          ),
                          errorWidget: (context, url, error) => Container(
                            color: Colors.grey[300],
                            child: const Icon(
                              Icons.location_on,
                              size: 80,
                              color: Colors.grey,
                            ),
                          ),
                        );
                      },
                    )
                  else
                    Container(
                      color:
                          FlutterFlowTheme.of(context).primary.withValues(alpha: 0.2),
                      child: Icon(
                        Icons.location_on,
                        size: 100,
                        color: FlutterFlowTheme.of(context).primary,
                      ),
                    ),

                  // Gradient overlay at bottom for readability
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 100,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            Colors.black.withValues(alpha: 0.7),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Image indicators
                  if (hasImages && widget.venue.images!.length > 1)
                    Positioned(
                      bottom: 16,
                      left: 0,
                      right: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          widget.venue.images!.length,
                          (index) => Container(
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _currentImageIndex == index
                                  ? Colors.white
                                  : Colors.white.withValues(alpha: 0.4),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),

          // Content
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Venue name and distance
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.venue.name,
                        style: FlutterFlowTheme.of(context)
                            .headlineMedium
                            .override(
                              fontFamily: 'Outfit',
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 12),

                      // Distance badge
                      if (widget.distanceKm != null)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.black.withValues(alpha: 0.7),
                                    Colors.black.withValues(alpha: 0.85),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.3),
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.location_on,
                                    size: 16,
                                    color: FlutterFlowTheme.of(context).primary,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    LocationService.formatDistance(
                                        widget.distanceKm!),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
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

                // Address
                if (widget.venue.address != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.place,
                              size: 20,
                              color: Colors.grey[600],
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                widget.venue.address!,
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      fontFamily: 'Readex Pro',
                                      color: Colors.grey[600],
                                    ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),

                // Action buttons
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    children: [
                      Expanded(
                        child: FFButtonWidget(
                          onPressed: _openDirections,
                          text: 'Get Directions',
                          icon: const Icon(Icons.directions, size: 20),
                          options: FFButtonOptions(
                            height: 50,
                            color: FlutterFlowTheme.of(context).primary,
                            textStyle: FlutterFlowTheme.of(context)
                                .titleSmall
                                .override(
                                  fontFamily: 'Readex Pro',
                                  color: Colors.white,
                                ),
                            elevation: 2,
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Divider
                Divider(
                  thickness: 1,
                  color: Colors.grey[300],
                  indent: 24,
                  endIndent: 24,
                ),

                // Description
                if (widget.venue.description != null) ...[
                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'About',
                          style:
                              FlutterFlowTheme.of(context).titleMedium.override(
                                    fontFamily: 'Readex Pro',
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          widget.venue.description!,
                          style:
                              FlutterFlowTheme.of(context).bodyMedium.override(
                                    fontFamily: 'Readex Pro',
                                    color: Colors.grey[700],
                                  ),
                        ),
                      ],
                    ),
                  ),
                ],

                const SizedBox(height: 32),

                // Venue details section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Venue Details',
                        style:
                            FlutterFlowTheme.of(context).titleMedium.override(
                                  fontFamily: 'Readex Pro',
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                      const SizedBox(height: 16),
                      _buildDetailRow(
                        Icons.sports_tennis,
                        'Sports Available',
                        'Badminton, Pickleball',
                      ),
                      const SizedBox(height: 12),
                      _buildDetailRow(
                        Icons.location_on,
                        'Location',
                        '${widget.venue.latitude.toStringAsFixed(4)}, ${widget.venue.longitude.toStringAsFixed(4)}',
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withValues(alpha: 0.7),
                    Colors.black.withValues(alpha: 0.85),
                  ],
                ),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Icon(
                icon,
                size: 20,
                color: FlutterFlowTheme.of(context).primary,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: FlutterFlowTheme.of(context).bodySmall.override(
                      fontFamily: 'Readex Pro',
                      color: Colors.grey[600],
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily: 'Readex Pro',
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _openDirections() async {
    final url = Uri.parse(
      'https://www.google.com/maps/dir/?api=1&destination=${widget.venue.latitude},${widget.venue.longitude}',
    );

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Could not open maps'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}

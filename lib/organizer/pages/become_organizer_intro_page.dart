import 'package:flutter/material.dart';
import '/flutter_flow/flutter_flow_util.dart';

/// Introduction/responsibilities page for becoming an organizer
class BecomeOrganizerIntroPage extends StatelessWidget {
  const BecomeOrganizerIntroPage({super.key});

  static const String routeName = 'becomeOrganizer';
  static const String routePath = '/becomeOrganizer';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E1E1E),
        title: const Text(
          'Become an Organizer',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero section
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.greenAccent.shade400,
                    Colors.greenAccent.shade700,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.greenAccent.shade400.withValues(alpha: 0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.verified,
                      size: 36,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'FunCircle PlayTime',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Organize Official Games',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.9),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Responsibilities section
            const Text(
              'Your Responsibilities',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),

            _buildResponsibilityItem(
              Icons.post_add,
              'Post Games on App',
              'Create and manage games at your chosen venue and timings',
            ),
            _buildResponsibilityItem(
              Icons.contact_phone,
              'Be Point of Contact',
              'Users can contact you before the game for any queries',
            ),
            _buildResponsibilityItem(
              Icons.access_time,
              'Arrive 10 Minutes Early',
              'Setup the court and be ready before game time',
            ),
            _buildResponsibilityItem(
              Icons.sports_tennis,
              'Ensure Smooth Gameplay',
              'Balance sides and switch players for fair matches',
            ),
            _buildResponsibilityItem(
              Icons.videocam,
              'Capture Short Videos',
              'Record highlights and moments to share with the community',
            ),
            _buildResponsibilityItem(
              Icons.block,
              'No Cancellations',
              'Commitment is key - players count on you showing up',
            ),
            _buildResponsibilityItem(
              Icons.calendar_today,
              'Minimum 2 Days a Week',
              'Consistency helps build a regular playing community',
            ),

            const SizedBox(height: 32),

            // Requirements section
            const Text(
              'Requirements',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.blue.shade400.withValues(alpha: 0.15),
                    Colors.blue.shade600.withValues(alpha: 0.1),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.blue.shade400.withValues(alpha: 0.3),
                  width: 1.5,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildRequirementItem('✓ Minimum 2 days per week availability'),
                  _buildRequirementItem('✓ Good with people and communication'),
                  _buildRequirementItem('✓ Reliable and committed'),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Benefits section
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.amber.shade400.withValues(alpha: 0.15),
                    Colors.orange.shade400.withValues(alpha: 0.1),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.amber.shade400.withValues(alpha: 0.3),
                  width: 1.5,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.star,
                        color: Colors.amber.shade400,
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Organizer Benefits',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildBenefitItem('🆓 Free Gameplay - Play without paying'),
                  _buildBenefitItem('🎉 Run Your Personal Club - Every weekend'),
                  _buildBenefitItem('🤝 Social Interaction - Build a community'),
                  _buildBenefitItem('💰 Earn via Rentals - Extra rackets income'),
                  _buildBenefitItem('🎯 Featured Games - Higher visibility'),
                  _buildBenefitItem('✨ Organizer Badge on profile'),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Continue button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.greenAccent.shade700,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  context.pushNamed('organizerApplication');
                },
                child: const Text(
                  'Continue to Application',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildResponsibilityItem(
      IconData icon, String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.green.shade400.withValues(alpha: 0.2),
                  Colors.green.shade700.withValues(alpha: 0.15),
                ],
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: Colors.greenAccent.shade400, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    color: Colors.grey.shade400,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBenefitItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 14,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildRequirementItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 14,
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

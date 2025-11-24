# Game Organizer Feature - Implementation Guide

## 📋 Overview

This feature allows users to apply to become official FunCircle game organizers. Once approved by admins, their games automatically become "FunCircle PlayTime" official games with the green verification badge.

---

## 🗄️ Database Setup

### Step 1: Run Migration

Execute the SQL migration file on your Supabase database:

```bash
# In Supabase SQL Editor, run:
DATABASE_MIGRATION_ORGANIZERS.sql
```

This creates:
- `playnow.game_organizers` table
- `playnow.organizer_activity_log` table
- Adds `is_organizer` and `is_admin` columns to `users` table
- Sets up triggers for automatic `is_official` flag
- Configures RLS policies

### Step 2: Set Up First Admin

In Supabase SQL Editor:

```sql
UPDATE public.users
SET is_admin = true
WHERE email = 'your-admin-email@example.com';
```

---

## 🎨 UI Implementation

### 1. Menu Screen - Add Organizer Entry Point

**Location**: `lib/sidescreens/profile_menu_screen.dart` (or wherever your menu is)

**Add Menu Item**:

```dart
// In menu items list
ListTile(
  leading: Icon(
    Icons.verified,
    color: Colors.amber.shade400,
  ),
  title: Text('Become an Organizer'),
  subtitle: Text('Organize official FunCircle games'),
  trailing: _buildOrganizerBadge(), // Shows status badge
  onTap: () {
    context.pushNamed('becomeOrganizer');
  },
),
```

**Badge Widget** (shows application status):

```dart
Widget _buildOrganizerBadge() {
  // TODO: Fetch user's organizer status from database
  final status = 'none'; // or 'pending', 'approved', 'rejected'

  if (status == 'approved') {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text('APPROVED', style: TextStyle(fontSize: 10, color: Colors.white)),
    );
  } else if (status == 'pending') {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.orange,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text('PENDING', style: TextStyle(fontSize: 10, color: Colors.white)),
    );
  }
  return Icon(Icons.arrow_forward_ios, size: 16);
}
```

---

### 2. Organizer Application Flow

#### **Page 1: Responsibilities Screen**

**Location**: Create `lib/organizer/become_organizer_intro_page.dart`

```dart
class BecomeOrganizerIntroPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Become an Organizer')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero section
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.green.shade400, Colors.green.shade600],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Icon(Icons.verified, size: 48, color: Colors.white),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'FunCircle PlayTime',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Organize Official Games',
                          style: TextStyle(color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 32),

            // Responsibilities section
            Text(
              'Your Responsibilities',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),

            _buildResponsibilityItem(
              Icons.sports_tennis,
              'Organize Regular Games',
              'Create and manage games at your chosen venue and timings',
            ),
            _buildResponsibilityItem(
              Icons.people,
              'Maintain Fair Play',
              'Ensure all players match the skill level requirements',
            ),
            _buildResponsibilityItem(
              Icons.schedule,
              'Be Punctual',
              'Arrive on time and communicate clearly with players',
            ),
            _buildResponsibilityItem(
              Icons.payment,
              'Handle Bookings',
              'Manage court bookings and payment collection',
            ),
            _buildResponsibilityItem(
              Icons.favorite,
              'Create Positive Environment',
              'Foster an inclusive and welcoming atmosphere',
            ),
            _buildResponsibilityItem(
              Icons.report,
              'Report Issues',
              'Communicate any problems to FunCircle support',
            ),

            SizedBox(height: 32),

            // Benefits section
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.amber.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.amber.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.amber.shade700),
                      SizedBox(width: 8),
                      Text(
                        'Organizer Benefits',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  _buildBenefitItem('🎯 Featured Games - Higher visibility'),
                  _buildBenefitItem('✨ Organizer Badge on profile'),
                  _buildBenefitItem('📊 Analytics dashboard'),
                  _buildBenefitItem('💰 Potential revenue sharing (coming soon)'),
                ],
              ),
            ),

            SizedBox(height: 32),

            // Continue button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade600,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  context.pushNamed('organizerApplication');
                },
                child: Text(
                  'Continue to Application',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResponsibilityItem(IconData icon, String title, String description) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: Colors.green.shade700, size: 20),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    color: Colors.grey.shade600,
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
      padding: EdgeInsets.only(bottom: 8),
      child: Text(text, style: TextStyle(fontSize: 14)),
    );
  }
}
```

#### **Page 2: Application Form**

**Location**: Create `lib/organizer/organizer_application_page.dart`

**Key Fields**:
1. Sport Type (Badminton/Pickleball)
2. Skill Level (1-5 slider)
3. Venue (Dropdown from database)
4. Mobile Number (with country code)
5. Available Days (Multi-select chips)
6. Available Time Slots (Custom time picker)
7. Why you want to organize (Text area, min 200 chars)
8. Playing experience (Text area, min 100 chars)

**Example Structure**:

```dart
class OrganizerApplicationPage extends StatefulWidget {
  @override
  State<OrganizerApplicationPage> createState() => _OrganizerApplicationPageState();
}

class _OrganizerApplicationPageState extends State<OrganizerApplicationPage> {
  final _formKey = GlobalKey<FormState>();

  // Form fields
  String? selectedSport;
  int skillLevel = 3;
  int? selectedVenueId;
  String mobileNumber = '';
  Set<String> selectedDays = {};
  List<TimeSlot> timeSlots = [];
  String bioText = '';
  String experienceText = '';

  bool isSubmitting = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Organizer Application'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(20),
          children: [
            // Sport Type
            Text('Sport', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: selectedSport,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Select sport',
              ),
              items: [
                DropdownMenuItem(value: 'badminton', child: Text('🏸 Badminton')),
                DropdownMenuItem(value: 'pickleball', child: Text('🎾 Pickleball')),
              ],
              onChanged: (value) => setState(() => selectedSport = value),
              validator: (value) => value == null ? 'Please select a sport' : null,
            ),

            SizedBox(height: 24),

            // Skill Level
            Text('Your Skill Level', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            _buildSkillLevelSlider(),

            SizedBox(height: 24),

            // Venue Selection
            Text('Venue', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            _buildVenueDropdown(),

            SizedBox(height: 24),

            // Mobile Number
            Text('Mobile Number', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            TextFormField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: '+91 98765 43210',
                prefixIcon: Icon(Icons.phone),
              ),
              keyboardType: TextInputType.phone,
              onChanged: (value) => mobileNumber = value,
              validator: (value) {
                if (value == null || value.isEmpty) return 'Please enter mobile number';
                if (value.length < 10) return 'Please enter valid mobile number';
                return null;
              },
            ),

            SizedBox(height: 24),

            // Available Days
            Text('Available Days', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            _buildDaySelector(),

            SizedBox(height: 24),

            // Time Slots
            Text('Available Time Slots', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            _buildTimeSlotSelector(),

            SizedBox(height: 24),

            // Bio
            Text('Why do you want to organize games?', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Text('Minimum 200 characters', style: TextStyle(fontSize: 12, color: Colors.grey)),
            SizedBox(height: 8),
            TextFormField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Tell us about your motivation...',
              ),
              maxLines: 4,
              maxLength: 500,
              onChanged: (value) => bioText = value,
              validator: (value) {
                if (value == null || value.length < 200) {
                  return 'Please write at least 200 characters';
                }
                return null;
              },
            ),

            SizedBox(height: 24),

            // Experience
            Text('Your playing experience', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Text('Minimum 100 characters', style: TextStyle(fontSize: 12, color: Colors.grey)),
            SizedBox(height: 8),
            TextFormField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Share your badminton/pickleball journey...',
              ),
              maxLines: 3,
              maxLength: 300,
              onChanged: (value) => experienceText = value,
              validator: (value) {
                if (value == null || value.length < 100) {
                  return 'Please write at least 100 characters';
                }
                return null;
              },
            ),

            SizedBox(height: 32),

            // Submit Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade600,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: isSubmitting ? null : _submitApplication,
                child: isSubmitting
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text(
                        'Submit Application',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submitApplication() async {
    if (!_formKey.currentState!.validate()) return;

    if (selectedDays.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select at least one available day')),
      );
      return;
    }

    if (timeSlots.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please add at least one time slot')),
      );
      return;
    }

    setState(() => isSubmitting = true);

    try {
      // TODO: Submit to Supabase
      await SupaFlow.client.schema('playnow').from('game_organizers').insert({
        'user_id': currentUserUid,
        'sport_type': selectedSport,
        'venue_id': selectedVenueId,
        'available_days': selectedDays.toList(),
        'available_time_slots': timeSlots.map((t) => t.toJson()).toList(),
        'skill_level': skillLevel,
        'mobile_number': mobileNumber,
        'bio': bioText,
        'experience': experienceText,
        'status': 'pending',
      });

      // Show success and navigate back
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Application submitted successfully!'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context);
      Navigator.pop(context);

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => isSubmitting = false);
    }
  }

  // TODO: Implement helper widgets
  // _buildSkillLevelSlider()
  // _buildVenueDropdown()
  // _buildDaySelector()
  // _buildTimeSlotSelector()
}

class TimeSlot {
  String startTime;
  String endTime;

  TimeSlot(this.startTime, this.endTime);

  Map<String, dynamic> toJson() => {
    'start_time': startTime,
    'end_time': endTime,
  };
}
```

---

### 3. Admin Approval Panel

**Location**: Create `lib/admin/organizer_admin_panel.dart`

**Features**:
- Tab view: Pending / Approved / Rejected / Suspended
- Filter by sport, venue, date range
- Approve/Reject with reason
- View full applicant profile

**Example Structure**:

```dart
class OrganizerAdminPanel extends StatefulWidget {
  @override
  State<OrganizerAdminPanel> createState() => _OrganizerAdminPanelState();
}

class _OrganizerAdminPanelState extends State<OrganizerAdminPanel> {
  String currentTab = 'pending';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Organizer Applications'),
      ),
      body: Column(
        children: [
          // Tab bar
          Container(
            height: 50,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 16),
              children: [
                _buildTabChip('pending', 'Pending'),
                _buildTabChip('approved', 'Approved'),
                _buildTabChip('rejected', 'Rejected'),
                _buildTabChip('suspended', 'Suspended'),
              ],
            ),
          ),

          // Content
          Expanded(
            child: _buildApplicationsList(),
          ),
        ],
      ),
    );
  }

  Widget _buildApplicationsList() {
    // TODO: Fetch from Supabase based on currentTab
    return FutureBuilder(
      future: _fetchApplications(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        final applications = snapshot.data as List;

        return ListView.builder(
          padding: EdgeInsets.all(16),
          itemCount: applications.length,
          itemBuilder: (context, index) {
            return _buildApplicationCard(applications[index]);
          },
        );
      },
    );
  }

  Widget _buildApplicationCard(Map<String, dynamic> application) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User info
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(application['user_profile_picture'] ?? ''),
                  radius: 24,
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        application['user_name'] ?? 'Unknown',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        application['user_email'] ?? '',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            SizedBox(height: 16),
            Divider(),
            SizedBox(height: 16),

            // Application details
            _buildDetailRow(Icons.sports, application['sport_type']),
            _buildDetailRow(Icons.location_on, application['venue_name']),
            _buildDetailRow(Icons.bar_chart, 'Level ${application['skill_level']}'),
            _buildDetailRow(Icons.phone, application['mobile_number']),
            _buildDetailRow(Icons.calendar_today, 'Days: ${application['available_days'].join(', ')}'),

            SizedBox(height: 16),

            // Bio
            Text('Why:', style: TextStyle(fontWeight: FontWeight.bold)),
            Text(application['bio'] ?? ''),

            SizedBox(height: 8),

            // Experience
            Text('Experience:', style: TextStyle(fontWeight: FontWeight.bold)),
            Text(application['experience'] ?? ''),

            SizedBox(height: 16),

            // Action buttons (only for pending)
            if (currentTab == 'pending') ...[
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                      icon: Icon(Icons.check, color: Colors.white),
                      label: Text('Approve', style: TextStyle(color: Colors.white)),
                      onPressed: () => _approveApplication(application['id']),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      icon: Icon(Icons.close, color: Colors.white),
                      label: Text('Reject', style: TextStyle(color: Colors.white)),
                      onPressed: () => _showRejectDialog(application['id']),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _approveApplication(String organizerId) async {
    // TODO: Update in Supabase
    await SupaFlow.client.schema('playnow').from('game_organizers')
      .update({
        'status': 'approved',
        'approved_by': currentUserUid,
        'approved_date': DateTime.now().toIso8601String(),
      })
      .eq('id', organizerId);

    setState(() {}); // Refresh list
  }

  void _showRejectDialog(String organizerId) {
    // TODO: Show dialog to enter rejection reason
  }

  // TODO: Implement other helper methods
}
```

---

## 📱 Navigation Routes

Add to your `lib/index.dart` or router configuration:

```dart
GoRoute(
  path: 'becomeOrganizer',
  name: 'becomeOrganizer',
  pageBuilder: (context, state) => MaterialPage(
    child: BecomeOrganizerIntroPage(),
  ),
),
GoRoute(
  path: 'organizerApplication',
  name: 'organizerApplication',
  pageBuilder: (context, state) => MaterialPage(
    child: OrganizerApplicationPage(),
  ),
),
GoRoute(
  path: 'admin/organizers',
  name: 'adminOrganizers',
  pageBuilder: (context, state) => MaterialPage(
    child: OrganizerAdminPanel(),
  ),
),
```

---

## 🔧 Backend Integration Points

### 1. Check if user is organizer:

```dart
Future<bool> isUserOrganizer(String userId) async {
  final response = await SupaFlow.client
    .from('users')
    .select('is_organizer')
    .eq('user_id', userId)
    .single();

  return response['is_organizer'] ?? false;
}
```

### 2. Fetch organizer applications (Admin):

```dart
Future<List<Map<String, dynamic>>> fetchOrganizerApplications(String status) async {
  return await SupaFlow.client
    .schema('playnow')
    .from('game_organizers')
    .select('''
      *,
      user:users!user_id(first_name, email, profile_picture),
      venue:venues!venue_id(venue_name)
    ''')
    .eq('status', status)
    .order('created_at', ascending: false);
}
```

### 3. Create game as organizer:

When creating a game, the trigger will automatically set `is_official = true` if the user is an approved organizer.

---

## ✅ Testing Checklist

- [ ] Migration runs successfully
- [ ] User can view "Become Organizer" in menu
- [ ] Application form validates all fields
- [ ] Application submits to database
- [ ] Admin can view pending applications
- [ ] Admin can approve applications
- [ ] Admin can reject applications with reason
- [ ] User's `is_organizer` flag updates on approval
- [ ] Games created by organizers have `is_official = true`
- [ ] FunCircle PlayTime badge shows on organizer games
- [ ] Activity logs are created for actions
- [ ] RLS policies prevent unauthorized access

---

## 🚀 Next Steps

1. Run the database migration
2. Set up first admin user
3. Create the UI screens as outlined above
4. Test the complete flow
5. Deploy and monitor

---

## 📞 Support

For issues or questions about this feature:
- Check database logs in Supabase
- Review RLS policies
- Check trigger functions are executing correctly

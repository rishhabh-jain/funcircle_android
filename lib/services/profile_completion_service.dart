import 'package:supabase_flutter/supabase_flutter.dart';
import '/backend/supabase/supabase.dart';

class ProfileCompletionService {
  final SupabaseClient _client;

  ProfileCompletionService(this._client);

  /// Check if user profile needs completion
  Future<bool> needsProfileCompletion(String userId) async {
    try {
      final response = await _client
          .from('users')
          .select('first_name, gender, preferred_sports')
          .eq('user_id', userId)
          .maybeSingle();

      if (response == null) {
        print('Profile check: No user found for $userId');
        return true;
      }

      // Check if essential fields are filled
      final firstName = response['first_name'] as String?;
      final gender = response['gender'] as String?;
      final preferredSports = response['preferred_sports'] as List?;

      print('Profile check for $userId:');
      print('  first_name: ${firstName ?? "MISSING"}');
      print('  gender: ${gender ?? "MISSING"}');
      print('  preferred_sports: ${preferredSports ?? "MISSING"}');

      // Return true if any essential field is missing
      // Note: profile_picture is optional and can be added later
      final needsCompletion = firstName == null ||
          firstName.isEmpty ||
          gender == null ||
          preferredSports == null ||
          preferredSports.isEmpty;

      print('  Needs completion: $needsCompletion');
      return needsCompletion;
    } catch (e) {
      print('Error checking profile completion: $e');
      return true; // Default to needing completion if error
    }
  }

  /// Create initial user profile
  Future<void> createUserProfile({
    required String userId,
    required String firstName,
    required String gender,
    required List<String> preferredSports,
    String? email,
    String? phoneNumber,
    String? profilePicture,
    double? latitude,
    double? longitude,
  }) async {
    try {
      // Debug: Log what we're trying to save
      print('DEBUG: ProfileCompletionService.createUserProfile called:');
      print('  userId: $userId');
      print('  firstName: $firstName');
      print('  latitude: $latitude');
      print('  longitude: $longitude');

      // Check if user already exists
      final existingUser = await _client
          .from('users')
          .select('user_id')
          .eq('user_id', userId)
          .maybeSingle();

      if (existingUser != null) {
        // User exists, update profile
        final updateData = <String, dynamic>{
          'first_name': firstName,
          'gender': gender,
          'preferred_sports': preferredSports,
          'isOnline': true,
          'lastactive': DateTime.now().toIso8601String(),
        };

        // Only update email if it's different or not set
        if (email != null && email.isNotEmpty) {
          // Check if this email is already used by another user
          final emailCheck = await _client
              .from('users')
              .select('user_id')
              .eq('email', email)
              .maybeSingle();

          if (emailCheck == null || emailCheck['user_id'] == userId) {
            updateData['email'] = email;
          }
        }

        if (profilePicture != null) {
          updateData['profile_picture'] = profilePicture;
        }

        if (latitude != null) {
          updateData['lat'] = latitude;
          print('DEBUG: Adding latitude to update: $latitude');
        }

        if (longitude != null) {
          updateData['lng'] = longitude;
          print('DEBUG: Adding longitude to update: $longitude');
        }

        print('DEBUG: Update data: $updateData');

        await _client
            .from('users')
            .update(updateData)
            .eq('user_id', userId);

        print('DEBUG: User profile updated successfully');
      } else {
        // New user, insert profile
        final insertData = <String, dynamic>{
          'user_id': userId,
          'first_name': firstName,
          'gender': gender,
          'preferred_sports': preferredSports,
          'email': email,
          'profile_picture': profilePicture,
          'created': DateTime.now().toIso8601String(),
          'isOnline': true,
          'lastactive': DateTime.now().toIso8601String(),
        };

        if (latitude != null) {
          insertData['lat'] = latitude;
          print('DEBUG: Adding latitude to insert: $latitude');
        }

        if (longitude != null) {
          insertData['lng'] = longitude;
          print('DEBUG: Adding longitude to insert: $longitude');
        }

        print('DEBUG: Insert data: $insertData');

        await _client.from('users').insert(insertData);

        print('DEBUG: New user profile inserted successfully');
      }
    } catch (e) {
      print('Error creating user profile: $e');
      rethrow;
    }
  }

  /// Update user profile field
  Future<void> updateProfileField({
    required String userId,
    required String field,
    required dynamic value,
  }) async {
    try {
      await _client.from('users').update({
        field: value,
      }).eq('user_id', userId);
    } catch (e) {
      print('Error updating profile field: $e');
      rethrow;
    }
  }

  /// Update skill level for a sport
  Future<void> updateSkillLevel({
    required String userId,
    required String sport,
    required int level,
  }) async {
    try {
      String fieldName;
      switch (sport) {
        case 'badminton':
          fieldName = 'skill_level_badminton';
          break;
        case 'pickleball':
          fieldName = 'skill_level_pickleball';
          break;
        case 'tennis':
          fieldName = 'skill_level_tennis';
          break;
        case 'padel':
          fieldName = 'skill_level_padel';
          break;
        default:
          print('Unknown sport: $sport');
          return;
      }

      await _client.from('users').update({
        fieldName: level,
      }).eq('user_id', userId);
    } catch (e) {
      print('Error updating skill level: $e');
      rethrow;
    }
  }

  /// Upload profile picture URL (placeholder - implement with actual file upload)
  Future<String?> uploadProfilePicture({
    required String userId,
    required String imageUrl,
  }) async {
    try {
      // For now, just return the URL
      // In production, implement actual file upload to Supabase Storage
      return imageUrl;
    } catch (e) {
      print('Error uploading profile picture: $e');
      return null;
    }
  }
}

import '/flutter_flow/flutter_flow_util.dart';
import '/backend/supabase/database/tables/users.dart';
import 'edit_profile_widget.dart' show EditProfileWidget;
import 'package:flutter/material.dart';

class EditProfileModel extends FlutterFlowModel<EditProfileWidget> {
  ///  Local state fields for this page.

  bool isInitialized = false;

  // Text field controllers
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController bioController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  final TextEditingController collegeController = TextEditingController();
  final TextEditingController companyController = TextEditingController();
  final TextEditingController hometownController = TextEditingController();

  // Date field
  DateTime? selectedDate;

  // Skill levels (1-5 stars)
  int badmintonSkillLevel = 0;
  int pickleballSkillLevel = 0;

  // Preferred sports list
  List<String> preferredSports = [];

  // Dropdown values
  String? workoutStatus;
  String? selectedCity;

  /// Initialize with user data from database
  void initializeWithUserData(UsersRow userData) {
    if (isInitialized) return;

    firstNameController.text = userData.firstName ?? '';
    selectedCity = userData.location;
    bioController.text = userData.bio ?? '';
    heightController.text = userData.height ?? '';
    collegeController.text = userData.college ?? '';
    companyController.text = userData.company ?? '';
    hometownController.text = userData.hometown ?? '';

    selectedDate = userData.birthday;

    badmintonSkillLevel = userData.skillLevelBadminton ?? 0;
    pickleballSkillLevel = userData.skillLevelPickleball ?? 0;

    preferredSports = List<String>.from(userData.preferredSports);

    // Map database values to display values for workout status
    final rawWorkoutStatus = userData.workoutStatus;
    if (rawWorkoutStatus != null && rawWorkoutStatus.isNotEmpty) {
      switch (rawWorkoutStatus.toLowerCase()) {
        case 'regularly':
          workoutStatus = 'Active';
          break;
        case 'sometimes':
          workoutStatus = 'Sometimes';
          break;
        case 'not active':
          workoutStatus = 'Never';
          break;
        default:
          // If it's an unexpected value, try to match it anyway
          workoutStatus = null;
      }
    }

    isInitialized = true;
  }

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    firstNameController.dispose();
    bioController.dispose();
    heightController.dispose();
    collegeController.dispose();
    companyController.dispose();
    hometownController.dispose();
  }
}

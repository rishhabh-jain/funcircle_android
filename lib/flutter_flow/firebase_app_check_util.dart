import 'package:firebase_app_check/firebase_app_check.dart';

Future initializeFirebaseAppCheck() => FirebaseAppCheck.instance.activate(
      webProvider:
          ReCaptchaV3Provider('6LehGScpAAAAANu1eoy5tGhAPFk4VgzQMLFytb-X'),
      androidProvider: AndroidProvider.playIntegrity,
      appleProvider: AppleProvider.deviceCheck,
    );

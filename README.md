# Firebase UI for Flutter - Example app

This is a sample app showing how to use the Firebase UI packages.

### Features

- Authentication flow using `firebase_ui_auth`:
  - Email & password
  - Google Sign In
- `ListView` with pagination using `FirestoreQueryBuilder`

### Packages

```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.2
  firebase_core: ^2.3.0
  firebase_auth: ^4.1.4
  flutter_riverpod: ^2.1.1
  firebase_ui_auth: ^1.1.0
  go_router: 5.1.1
  faker: ^2.0.0
  cloud_firestore: ^4.1.0
  firebase_ui_oauth_google: ^1.0.7
  firebase_ui_firestore: ^1.1.0
```

## Running the app

Before running the app:

### Create a new Firebase project

- enable Email & Password and Google Sign in under authentication
- enable Cloud Firestore

### Security rules

For the Cloud Firestore part to work, set the following rules:

```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
		match /users/{uid}/jobs/{document=**} {
      allow read, write: if request.auth.uid == uid;
    }
  }
}
```

### Flutterfire config

- run `flutterfire configure` and generate the configuration file for `ios`, `android`, `macos`, `web`.

- create a `lib/google_client_id.dart` file with the following contents:

```dart
import 'dart:io';

import 'package:faker_app_firebase/firebase_options.dart';
import 'package:flutter/foundation.dart';

String getGoogleClientId() {
  if (kIsWeb) {
    // Get this from the Web Client ID in the Firebase console
    return 'your-web-client-id';
  }
  if (Platform.isIOS || Platform.isMacOS) {
    return DefaultFirebaseOptions.ios.iosClientId!;
  }
  if (Platform.isAndroid) {
    // Got to return an empty string since [GoogleProvider] takes a non-nullable
    // clientId. Otherwise, this error will show up:
    // > clientId is not supported on Android and is interpreted as serverClientId. Use serverClientId instead to suppress this warning.
    return '';
  }
  throw UnimplementedError(
      'Requested Google Client ID for an unsupported platform');
}
```

### Issues and Friction Log

Read this log for all the issues I encountered while enabling Google Sign In:

- [Google Sign In with FlutterFire - Friction Log](https://gorgeous-bar-e02.notion.site/Google-Sign-In-with-FlutterFire-Friction-Log-b188dc66685d4d45b3f7d107c8a45d6a)

### [LICENSE: MIT](LICENSE.md)
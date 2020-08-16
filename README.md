# flutter_companybook

My first Flutter project 

    flutter : 1.20.0  
    Tools : Dart2.9.0  
    firebase : 8.7.0  

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

 ## initial setting
    flutter channel beta  
    flutter upgarde  
    flutter run -d chrome  


 ## Google Authentication
    applicationId "my project name"(for example, com.XXXX.XXXXX)
    cd <project path>/android/
    gradlew signingReport
    check SHA1, SHA-256 hashcode
    In Firebase project-> Project Settings -> SHA certificate fingerprints -> add SHA1, SHA-256
    Download google-services.json
    paste <project path>/android/app
    cd <project path>
    flutter pub get
    
    console.developers.google.com
    select a project -> application list check
    
    console.firebase.google.com
    Authentication -> Sign-in method -> Google -> Enable, input email -> save
    


## firebase deploy



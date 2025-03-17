import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:joblagbe/firebase_options.dart';
import 'app/_app.dart';

void main() async {
  // initialize flutter bindings
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  
  runApp(const MyApp());
}

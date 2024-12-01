import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vinyl_allosa/app/routes.dart';
import 'package:vinyl_allosa/app/theme.dart';
import 'package:vinyl_allosa/ui/viewmodels/vinyl_viewmodel.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp( ChangeNotifierProvider(
      create: (context) => VinylViewModel(),
      child: MyApp(),
    ),);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vinyl Library',
      theme: AppTheme.darkTheme,
      initialRoute: '/login',
      routes: Routes.getRoutes(),
      debugShowCheckedModeBanner: false,
    );
  }
}
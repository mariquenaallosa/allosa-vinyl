import 'package:flutter/material.dart';
import 'package:vinyl_allosa/data/models/vinyl_model.dart';
import 'package:vinyl_allosa/ui/pages/details/vinyl_details_page.dart';
import 'package:vinyl_allosa/ui/pages/edit/vinyl_edit_page.dart';
import 'package:vinyl_allosa/ui/pages/home_page.dart';
import 'package:vinyl_allosa/ui/pages/login_page.dart';

class Routes {
  static Map<String, WidgetBuilder> getRoutes() {
    return {
      '/login': (context) => LoginPage(),
      '/home': (context) => HomePage(),
      '/details': (context) => VinylDetailsPage(vinyl: ModalRoute.of(context)!.settings.arguments as VinylModel),
      '/edit': (context) => VinylEditPage(vinyl: ModalRoute.of(context)!.settings.arguments as VinylModel),
    };
  }
}

import 'package:flutter/material.dart';
import 'import_method_screen.dart';
import 'google_sheets_sync_screen.dart';
import 'import_options_screen.dart';
import 'match_field_names_screen.dart';
import 'export_method_screen.dart';

void main() {
  runApp(const GearchainApp());
}

class GearchainApp extends StatelessWidget {
  const GearchainApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GEARCHAIN Import',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Inter',
      ),
      home: const MatchFieldNamesScreen(),
    );
  }
} 
// ImportOptionsScreen
// MatchFieldNamesScreen
// ExportMethodScreen
// GoogleSheetsSyncScreen

import 'package:books/providers/list_provider.dart';
import 'package:books/providers/note_provider.dart';
import 'package:books/providers/repository_provider.dart';
import 'package:books/ui/screens/all_results.dart';
import 'package:books/ui/screens/list_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'ui/screens/book_preview_screen.dart';
import 'ui/screens/home_screen.dart';

void main() => runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => Repository(),
          ),
          ChangeNotifierProvider(
            create: (context) => ListProvider(),
          ),
          ChangeNotifierProvider(
            create: (context) => NoteProvider(),
          ),
        ],
        child: Main(),
      ),
    );

class Main extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(),
        '/book-preview': (context) => BookPreviewScreen(),
        '/list-view': (context) => ListViewScreen(),
        '/all-results': (context) => AllResults(),
      },
    );
  }
}

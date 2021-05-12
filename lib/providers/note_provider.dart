import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:localstorage/localstorage.dart';

class NoteProvider extends ChangeNotifier {
  NoteProvider() {
    loadFromStorage();
  }
  final LocalStorage storage = LocalStorage('books');
  Map<String, String> _notes = {};
  Map<String, String> get notes => _notes;

  // Add note in format bookId : noteText
  void addNote(String bookId, String note) {
    _notes.addAll({bookId: note});
    saveToStorage();
    notifyListeners();
  }

  // Load notes from storage
  void loadFromStorage() async {
    if (await storage.ready) {
      if (storage.getItem('notes') != null) {
        // Converting note from JSON to Map
        _notes = Map<String, String>.from(jsonDecode(storage.getItem('notes')));

        notifyListeners();
      }
    }
  }

  // Save notes to storage
  void saveToStorage() {
    storage.setItem('notes', jsonEncode(_notes));
  }
}

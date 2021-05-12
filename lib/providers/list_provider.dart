import 'package:books/models/book.dart';
import 'package:books/models/book_result.dart';
import 'package:flutter/foundation.dart';
import 'package:localstorage/localstorage.dart';

class ListProvider extends ChangeNotifier {
  ListProvider() {
    loadFromStorage();
  }

  final LocalStorage storage = LocalStorage('books');

  List _customLists = [
    {
      'name': 'Want to read',
      'books': [],
    },
    {
      'name': 'Currently reading',
      'books': [],
    },
    {
      'name': 'Finished reading',
      'books': [],
    },
  ];

  List get customLists => _customLists;

  // Load data from storage
  void loadFromStorage() async {
    if (await storage.ready) {
      if (storage.getItem('lists') != null) {
        // Data is converted to JSON when saved so we need to convert it back to BookResult
        for (int i = 0; i < storage.getItem('lists').length; i++) {
          for (int y = 0;
              y < storage.getItem('lists')[i]['books'].length;
              y++) {
            storage.getItem('lists')[i]['books'][y] =
                BookResult.fromJson(storage.getItem('lists')[i]['books'][y]);
          }
        }
        _customLists = storage.getItem('lists');
        notifyListeners();
      }
    }
  }

  // Creates custom list
  void createCustomList(String listName) {
    _customLists.add({
      'name': listName,
      'books': [],
    });

    saveToStorage();
    notifyListeners();
  }

  // Deletes custom list
  void deleteCustomList(String listName) {
    _customLists.removeWhere((element) => element['name'] == listName);
    saveToStorage();
    notifyListeners();
  }

  // Remove book from list
  void removeFromCustomList(String listName, BookResult bookResult) {
    for (Map<String, dynamic> list in _customLists) {
      if (list['name'] == listName) {
        list['books'].remove(bookResult);
      }
    }
    saveToStorage();
    notifyListeners();
  }

  // Add book to list
  void addToCustomList(String listName, BookResult bookResult) {
    for (Map<String, dynamic> list in _customLists) {
      if (list['name'] == listName) {
        list['books'].add(bookResult);
      }
    }
    saveToStorage();
    notifyListeners();
  }

  // Save data to storage (Converts data to JSON)
  void saveToStorage() {
    storage.setItem('lists', _customLists);
  }
}

import 'dart:convert';
import 'dart:math';
import 'package:books/constants.dart';
import 'package:books/models/book.dart';
import 'package:books/models/book_result.dart';
import 'package:books/models/quote.dart';
import 'package:http/http.dart';
import 'package:flutter/foundation.dart';
import 'package:localstorage/localstorage.dart';

class Repository extends ChangeNotifier {
  Repository() {
    getQuoteOfTheDay();
  }
  List<BookResult> _bookResults = [];
  List<BookResult> _allResults = [];
  bool _loadingState = false;
  bool _emptyState = false;
  Quote _quote;

  List<BookResult> get bookResults => _bookResults;

  Quote get quote => _quote;

  bool get loadingState => _loadingState;
  bool get emptyState => _emptyState;

  // Shows random quote on the home screen
  void getQuoteOfTheDay() async {
    try {
      Response response = await get(Uri.parse(QUOTES));
      var decodedResponse = jsonDecode(response.body);
      Random r = Random();
      _quote =
          Quote.fromJson(decodedResponse[r.nextInt(decodedResponse.length)]);
      notifyListeners();
    } catch (e) {
      print(e.toString());
    }
  }

  // Get all search results
  Future<List<BookResult>> getAllResults(String query) async {
    try {
      Response response =
          await get(Uri.parse('$SEARCH_URL${query.replaceAll(' ', '+')}'));
      var decodedResponse = jsonDecode(response.body)['docs'];

      if (decodedResponse.length != 0) {
        for (var result in decodedResponse) {
          _allResults.add(BookResult.fromJson(result));
        }
      } else {
        _emptyState = true;
        notifyListeners();
      }
    } catch (e) {
      print(e.toString());
    }
    return _allResults;
  }

  // Get limited number of results to show in autofill
  void getQueryResults(String query) async {
    _emptyState = false;
    _loadingState = true;
    notifyListeners();
    try {
      Response response = await get(Uri.parse(
          '$SEARCH_URL${query.replaceAll(' ', '+')}&limit=$NUM_OF_SUGGESTIONS'));
      var decodedResponse = jsonDecode(response.body)['docs'];

      if (decodedResponse.length != 0) {
        for (var result in decodedResponse) {
          _bookResults.add(BookResult.fromJson(result));
        }
      } else {
        _emptyState = true;
        notifyListeners();
      }
    } catch (e) {
      print(e.toString());
    }
    _loadingState = false;
    notifyListeners();
  }

  // Get specific book information
  Future<Book> getBookData(String bookId) async {
    Response response = await get(Uri.parse('$BASE_URL$bookId.json'));
    Book _book = Book.json(jsonDecode(response.body));
    return _book;
  }

  // Check if cover image is available
  Future<bool> checkForCover(String imageCode) async {
    Response response =
        await get(Uri.parse('$COVER_BY_ID$imageCode-M.jpg?default=false'));
    if (response.statusCode != 200) {
      return false;
    } else {
      return true;
    }
  }

  // Clear book results
  void clearResults() {
    _bookResults.clear();
    notifyListeners();
  }
}

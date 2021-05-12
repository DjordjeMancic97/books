import 'package:books/models/book_result.dart';
import 'package:books/providers/list_provider.dart';
import 'package:books/providers/repository_provider.dart';
import 'package:books/ui/screens/all_results.dart';
import 'package:flutter/material.dart';
import 'package:just_debounce_it/just_debounce_it.dart';
import '../../constants.dart';
import 'book_result_tile.dart';

/*
  Widget containing states for all search actions.
  Including search bar, loading and results listing
 */

class BookSearchBar extends StatefulWidget {
  final Repository repositoryProvider;
  final ListProvider listProvider;

  BookSearchBar({Key key, this.repositoryProvider, this.listProvider})
      : super(key: key);

  @override
  _BookSearchBarState createState() => _BookSearchBarState();
}

class _BookSearchBarState extends State<BookSearchBar> {
  TextEditingController _searchController = TextEditingController();
  FocusNode _searchFocus = FocusNode();
  ScrollController _suggestionsScroll = ScrollController();
  String lastSearchedText = '';

  @override
  void dispose() {
    super.dispose();
    _searchFocus.dispose();
    _searchController.dispose();
    _suggestionsScroll.dispose();
  }

  void _getSearchResults(String text, Repository repositoryProvider) {
    repositoryProvider.clearResults();
    if (text.length != 0) {
      repositoryProvider.getQueryResults(text);
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height,
      child: Stack(
        children: [
          Positioned(
            top: size.height / 3,
            left: 0,
            right: 0,
            child: Container(
              height: 60,
              decoration: BoxDecoration(
                color: WHITE,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                        focusNode: _searchFocus,
                        controller: _searchController,
                        cursorColor: Colors.black,
                        textCapitalization: TextCapitalization.sentences,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          contentPadding: EdgeInsets.only(
                              left: 15, bottom: 11, top: 11, right: 15),
                          hintText: "Search",
                          hintStyle: TextStyle(
                            color: Colors.grey[500],
                          ),
                        ),
                        onChanged: (text) {
                          if (lastSearchedText != text) {
                            lastSearchedText = text;
                            Debounce.milliseconds(500, _getSearchResults,
                                [text, widget.repositoryProvider]);
                          }
                        }),
                  ),
                  AnimatedOpacity(
                    duration: Duration(milliseconds: 200),
                    opacity: _searchController.text.length != 0 ? 1 : 0,
                    child: GestureDetector(
                      onTap: () {
                        widget.repositoryProvider.clearResults();
                        _searchFocus.unfocus();
                        _searchController.clear();
                      },
                      child: Container(
                        height: 30,
                        width: 30,
                        margin: EdgeInsets.only(right: 14),
                        decoration: BoxDecoration(
                          color: PURPLISH,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.close,
                          color: WHITE,
                          size: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          widget.repositoryProvider.loadingState
              ? Positioned(
                  top: size.height / 5.2,
                  left: 0,
                  right: 0,
                  height: 100,
                  child: Container(
                    margin: EdgeInsets.only(top: 14),
                    padding: EdgeInsets.symmetric(vertical: 14),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: WHITE,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        Container(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            backgroundColor: PURPLISH,
                            valueColor: AlwaysStoppedAnimation<Color>(WHITE),
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Loading...',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : widget.repositoryProvider.bookResults.length != 0 &&
                      _searchController.text.length != 0
                  ? Positioned(
                      top: size.height * 0.02,
                      left: 0,
                      right: 0,
                      child: Column(
                        children: [
                          Container(
                            margin: EdgeInsets.only(top: 14),
                            width: MediaQuery.of(context).size.width,
                            height: 200,
                            decoration: BoxDecoration(
                              color: WHITE,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Scrollbar(
                                controller: _suggestionsScroll,
                                isAlwaysShown: true,
                                radius: Radius.circular(16),
                                thickness: 8,
                                child: Column(
                                  children: [
                                    Expanded(
                                      child: ListView(
                                        controller: _suggestionsScroll,
                                        children: [
                                          for (BookResult result in widget
                                              .repositoryProvider.bookResults)
                                            BookResultTile(
                                              repositoryProvider:
                                                  widget.repositoryProvider,
                                              result: result,
                                              listProvider: widget.listProvider,
                                              controller: _searchController,
                                              focus: _searchFocus,
                                            ),
                                        ],
                                      ),
                                    ),
                                    GestureDetector(
                                      behavior: HitTestBehavior.opaque,
                                      onTap: () {
                                        Navigator.of(context).pushNamed(
                                            '/all-results',
                                            arguments: AllResultsArgs(
                                                _searchController.text,
                                                widget.repositoryProvider,
                                                widget.listProvider,
                                                _searchController,
                                                _searchFocus));
                                      },
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        padding:
                                            EdgeInsets.symmetric(vertical: 14),
                                        decoration: BoxDecoration(
                                          color: WHITE,
                                        ),
                                        child: Center(
                                          child: Text('Show all results',
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w600,
                                                color: PURPLISH,
                                              )),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : Container(),
        ],
      ),
    );
  }
}

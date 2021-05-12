import 'dart:ui';
import 'package:animated_text/animated_text.dart';
import 'package:books/providers/list_provider.dart';
import 'package:books/ui/components/your_list_tile.dart';
import 'package:flutter/services.dart';
import '../../providers/repository_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants.dart';
import '../components/book_search_bar.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController _listNameController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void dispose() {
    super.dispose();
    _listNameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Repository repositoryProvider = Provider.of<Repository>(context);
    final ListProvider listProvider = Provider.of<ListProvider>(context);
    Size size = MediaQuery.of(context).size;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: PURPLISH,
        resizeToAvoidBottomInset: false,
        drawer: Theme(
          data: Theme.of(context).copyWith(
            canvasColor: Colors.transparent,
          ),
          child: Drawer(
            child: Stack(
              children: [
                ClipRRect(
                  child: Container(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 16.0, sigmaY: 16.0),
                      child: Container(
                        decoration:
                            BoxDecoration(color: PURPLISH.withOpacity(0.4)),
                      ),
                    ),
                  ),
                ),
                ListView(
                  children: [
                    for (Map<String, dynamic> list in listProvider.customLists)
                      YourListTile(
                        listName: list['name'],
                        numOfItems: list['books'].length,
                        bookResults: list['books'],
                        listProvider: listProvider,
                        repositoryProvider: repositoryProvider,
                        index: listProvider.customLists.indexOf(list),
                      ),
                    Divider(
                      color: WHITE,
                      thickness: 0.3,
                    ),
                    InkWell(
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (context) => Dialog(
                                  elevation: 0.0,
                                  backgroundColor: WHITE,
                                  child: Container(
                                    height: 200,
                                    width: 200,
                                    padding: EdgeInsets.only(
                                        left: 24, top: 24, right: 24),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'New list',
                                              style: TextStyle(
                                                color: BLACK,
                                                fontSize: 24,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () =>
                                                  Navigator.pop(context),
                                              child: Container(
                                                height: 25,
                                                width: 25,
                                                decoration: BoxDecoration(
                                                  color: PURPLISH,
                                                  shape: BoxShape.circle,
                                                ),
                                                child: Icon(Icons.close,
                                                    color: WHITE, size: 14),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 14),
                                        Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: BLACK, width: 1.0),
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          child: TextField(
                                            controller: _listNameController,
                                            cursorColor: Colors.black,
                                            textCapitalization:
                                                TextCapitalization.sentences,
                                            keyboardType: TextInputType.text,
                                            decoration: InputDecoration(
                                              focusedBorder: InputBorder.none,
                                              enabledBorder: InputBorder.none,
                                              errorBorder: InputBorder.none,
                                              disabledBorder: InputBorder.none,
                                              contentPadding: EdgeInsets.only(
                                                  left: 15,
                                                  bottom: 11,
                                                  top: 11,
                                                  right: 15),
                                              hintText: "Your list name",
                                              hintStyle: TextStyle(
                                                color: Colors.grey[500],
                                              ),
                                            ),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            if (_listNameController
                                                    .text.length !=
                                                0) {
                                              listProvider.createCustomList(
                                                  _listNameController.text);
                                              Navigator.pop(context);
                                            }
                                          },
                                          child: Container(
                                            margin: EdgeInsets.only(
                                                left: 34, right: 34, top: 34),
                                            width: size.width,
                                            height: 30,
                                            decoration: BoxDecoration(
                                              color: PURPLISH,
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                            ),
                                            child: Center(
                                              child: Text('Add',
                                                  style: TextStyle(
                                                    color: WHITE,
                                                    fontSize: 16,
                                                  )),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )).then((value) => _listNameController.clear());
                      },
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                        child: Row(
                          children: [
                            Text(
                              'Create new list',
                              style: TextStyle(color: WHITE, fontSize: 18),
                            ),
                            SizedBox(width: 8),
                            Icon(Icons.add, color: WHITE, size: 22),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        body: Container(
          child: Stack(
            children: [
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: size.height / 2,
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/bg.jpg'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Container(
                      height: size.height / 2,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            PURPLISH.withOpacity(0.2),
                            PURPLISH.withOpacity(0.5),
                            PURPLISH.withOpacity(0.7),
                            PURPLISH,
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: size.height / 5,
                left: 24,
                right: 24,
                child: repositoryProvider.quote == null
                    ? Container()
                    : GestureDetector(
                        onTap: () => repositoryProvider.getQuoteOfTheDay(),
                        child: Column(
                          children: [
                            Container(
                              width: size.width,
                              child: Text(
                                'Quote of the day:',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  color: WHITE,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            SizedBox(height: 14),
                            Text(
                              '\"${repositoryProvider.quote.quote}\"',
                              style: TextStyle(
                                color: WHITE,
                                fontSize: 18,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                            Container(
                              width: size.width,
                              child: Text(
                                '- ${repositoryProvider.quote.author ?? 'Anonymous'}',
                                textAlign: TextAlign.end,
                                style: TextStyle(
                                  color: WHITE,
                                  fontStyle: FontStyle.italic,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
              ),
              Positioned(
                top: size.height / 3,
                left: 24,
                right: 24,
                child: Container(
                  height: 50,
                  width: size.width,
                  child: AnimatedText(
                    displayTime: Duration(milliseconds: 2500),
                    textStyle: TextStyle(
                      color: WHITE,
                      fontSize: 34,
                      fontFamily: 'Kingthings',
                      fontWeight: FontWeight.w700,
                    ),
                    wordList: [
                      'Let\'s read...',
                      'books!',
                    ],
                  ),
                ),
              ),
              Positioned(
                top: size.height / 10,
                left: 24,
                right: 24,
                child: BookSearchBar(
                    repositoryProvider: repositoryProvider,
                    listProvider: listProvider),
              ),
              Positioned(
                left: 0,
                right: 0,
                top: 24,
                height: 50,
                child: Container(
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.only(left: 14),
                        child: IconButton(
                          onPressed: () =>
                              _scaffoldKey.currentState.openDrawer(),
                          icon: Icon(
                            Icons.menu,
                            size: 28,
                            color: PURPLISH,
                          ),
                        ),
                      ),
                      Spacer(flex: 2),
                      Container(
                        child: Text(
                          'books.',
                          style: TextStyle(
                            color: PURPLISH,
                            fontSize: 28,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Spacer(flex: 3),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

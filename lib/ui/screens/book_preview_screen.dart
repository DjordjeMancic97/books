import 'package:books/models/book.dart';
import 'package:books/models/book_result.dart';
import 'package:books/providers/list_provider.dart';
import 'package:books/providers/note_provider.dart';
import 'package:books/providers/repository_provider.dart';
import 'package:books/ui/components/dialogs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../constants.dart';

class BookPreviewArgs {
  final String link;
  final String authors;
  final Repository repositoryProvider;
  final ListProvider listProvider;
  final BookResult bookResult;

  BookPreviewArgs(this.link, this.authors, this.repositoryProvider,
      this.listProvider, this.bookResult);
}

class BookPreviewScreen extends StatefulWidget {
  @override
  _BookPreviewScreenState createState() => _BookPreviewScreenState();
}

class _BookPreviewScreenState extends State<BookPreviewScreen> {
  ScrollController _descriptionController = ScrollController();
  ScrollController _listsController = ScrollController();
  TextEditingController _noteController = TextEditingController();
  Dialogs _dialogs = Dialogs();

  @override
  void dispose() {
    super.dispose();
    _descriptionController.dispose();
    _listsController.dispose();
    _noteController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final BookPreviewArgs args = ModalRoute.of(context).settings.arguments;
    final NoteProvider noteProvider = Provider.of<NoteProvider>(context);
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: PURPLISH,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Color(0xff4964ba),
        centerTitle: true,
        title: Text('books.',
            style: TextStyle(
              color: WHITE,
              fontWeight: FontWeight.w700,
              fontSize: 24,
            )),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_rounded, color: WHITE, size: 24),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: FutureBuilder(
          future: args.repositoryProvider.getBookData(args.link),
          builder: (BuildContext context, AsyncSnapshot<Book> snapshot) {
            if (snapshot.hasData) {
              return Container(
                child: SingleChildScrollView(
                  child: Container(
                    height: size.height,
                    width: size.width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.all(14),
                          child: Row(
                            children: [
                              Expanded(
                                child: Container(
                                  child: Image(
                                    width: 120,
                                    height: 290,
                                    image: !snapshot.hasData
                                        ? AssetImage('assets/book-loading.gif')
                                        : snapshot.data.image == 0
                                            ? AssetImage(
                                                'assets/book-cover-placeholder.jpg')
                                            : NetworkImage(
                                                '$COVER_BY_ID${snapshot.data.image}-L.jpg?default=false'),
                                  ),
                                ),
                              ),
                              SizedBox(width: 14),
                              Expanded(
                                child: Container(
                                  height: 290,
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        child: RichText(
                                          text: TextSpan(
                                            children: <TextSpan>[
                                              TextSpan(
                                                  text: snapshot.data.title,
                                                  style: TextStyle(
                                                    color: WHITE,
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 18,
                                                  )),
                                              TextSpan(
                                                  text:
                                                      '\nAuthor: ${args.authors}',
                                                  style: TextStyle(
                                                    color: WHITE,
                                                    fontSize: 14,
                                                    fontStyle: FontStyle.italic,
                                                    height: 1.5,
                                                  )),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Column(
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              showDialog(
                                                  context: context,
                                                  builder: (context) => Dialog(
                                                        elevation: 0.0,
                                                        backgroundColor: WHITE,
                                                        child: Container(
                                                          height: 200,
                                                          width: 200,
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 24,
                                                                  top: 24,
                                                                  right: 24),
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20),
                                                          ),
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Text(
                                                                    'Note',
                                                                    style:
                                                                        TextStyle(
                                                                      color:
                                                                          BLACK,
                                                                      fontSize:
                                                                          24,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                    ),
                                                                  ),
                                                                  GestureDetector(
                                                                    onTap: () =>
                                                                        Navigator.pop(
                                                                            context),
                                                                    child:
                                                                        Container(
                                                                      height:
                                                                          25,
                                                                      width: 25,
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        color:
                                                                            PURPLISH,
                                                                        shape: BoxShape
                                                                            .circle,
                                                                      ),
                                                                      child: Icon(
                                                                          Icons
                                                                              .close,
                                                                          color:
                                                                              WHITE,
                                                                          size:
                                                                              14),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              SizedBox(
                                                                  height: 14),
                                                              Container(
                                                                decoration:
                                                                    BoxDecoration(
                                                                  border: Border.all(
                                                                      color:
                                                                          BLACK,
                                                                      width:
                                                                          1.0),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              12),
                                                                ),
                                                                child:
                                                                    TextField(
                                                                  controller:
                                                                      _noteController,
                                                                  cursorColor:
                                                                      Colors
                                                                          .black,
                                                                  textCapitalization:
                                                                      TextCapitalization
                                                                          .sentences,
                                                                  keyboardType:
                                                                      TextInputType
                                                                          .text,
                                                                  decoration:
                                                                      InputDecoration(
                                                                    focusedBorder:
                                                                        InputBorder
                                                                            .none,
                                                                    enabledBorder:
                                                                        InputBorder
                                                                            .none,
                                                                    errorBorder:
                                                                        InputBorder
                                                                            .none,
                                                                    disabledBorder:
                                                                        InputBorder
                                                                            .none,
                                                                    contentPadding: EdgeInsets.only(
                                                                        left:
                                                                            15,
                                                                        bottom:
                                                                            11,
                                                                        top: 11,
                                                                        right:
                                                                            15),
                                                                    hintText:
                                                                        "Ex: Page 154",
                                                                    hintStyle:
                                                                        TextStyle(
                                                                      color: Colors
                                                                              .grey[
                                                                          500],
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              GestureDetector(
                                                                onTap: () {
                                                                  noteProvider.addNote(
                                                                      snapshot
                                                                          .data
                                                                          .key,
                                                                      _noteController
                                                                          .text);
                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                                child:
                                                                    Container(
                                                                  margin: EdgeInsets
                                                                      .only(
                                                                          left:
                                                                              34,
                                                                          right:
                                                                              34,
                                                                          top:
                                                                              34),
                                                                  width: size
                                                                      .width,
                                                                  height: 30,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color:
                                                                        PURPLISH,
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            16),
                                                                  ),
                                                                  child: Center(
                                                                    child: Text(
                                                                        'Add',
                                                                        style:
                                                                            TextStyle(
                                                                          color:
                                                                              WHITE,
                                                                          fontSize:
                                                                              16,
                                                                        )),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      )).then((value) {
                                                _noteController.clear();
                                              });
                                            },
                                            child: Container(
                                              width: size.width,
                                              height: 50,
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: WHITE, width: 1),
                                                borderRadius:
                                                    BorderRadius.circular(14),
                                              ),
                                              child: Center(
                                                child: Text('Add note',
                                                    style: TextStyle(
                                                      color: WHITE,
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                    )),
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 14),
                                          GestureDetector(
                                            onTap: () {
                                              _dialogs.chooseListDialog(
                                                  context,
                                                  size,
                                                  _listsController,
                                                  args.listProvider,
                                                  args.bookResult);
                                            },
                                            child: Container(
                                              width: size.width,
                                              height: 50,
                                              decoration: BoxDecoration(
                                                color: WHITE,
                                                borderRadius:
                                                    BorderRadius.circular(14),
                                              ),
                                              child: Center(
                                                child: Text('Add to list',
                                                    style: TextStyle(
                                                      color: PURPLISH,
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                    )),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Scrollbar(
                                  controller: _descriptionController,
                                  isAlwaysShown: true,
                                  thickness: 8.0,
                                  child: Markdown(
                                    controller: _descriptionController,
                                    //physics: NeverScrollableScrollPhysics(),
                                    data: snapshot.data.description,
                                    styleSheet: MarkdownStyleSheet(
                                      p: TextStyle(color: WHITE, fontSize: 16),
                                      a: TextStyle(
                                          color: WHITE,
                                          fontSize: 16,
                                          decoration: TextDecoration.underline),
                                    ),
                                    onTapLink: (String text, String url,
                                        String title) async {
                                      await canLaunch(url)
                                          ? await launch(url)
                                          : throw 'Could not launch $url';
                                    },
                                  ),
                                ),
                              ),
                              noteProvider.notes != null &&
                                      noteProvider.notes[snapshot.data.key] !=
                                          null
                                  ? Expanded(
                                      child: Container(
                                        padding: EdgeInsets.all(20),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text('Notes',
                                                style: TextStyle(
                                                  color: WHITE,
                                                  fontSize: 24,
                                                  fontWeight: FontWeight.w500,
                                                )),
                                            SizedBox(height: 14),
                                            Text(
                                                noteProvider
                                                    .notes[snapshot.data.key],
                                                style: TextStyle(
                                                    color: WHITE,
                                                    fontSize: 16)),
                                          ],
                                        ),
                                      ),
                                    )
                                  : Container(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            } else {
              return Center(
                  child: CircularProgressIndicator(
                backgroundColor: WHITE,
                valueColor: AlwaysStoppedAnimation<Color>(PURPLISH),
              ));
            }
          },
        ),
      ),
    );
  }
}

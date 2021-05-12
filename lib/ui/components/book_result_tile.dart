import 'package:books/models/book_result.dart';
import 'package:books/providers/list_provider.dart';
import 'package:books/providers/repository_provider.dart';
import 'package:books/ui/screens/book_preview_screen.dart';
import 'package:flutter/material.dart';
import '../../constants.dart';

// Widget used when displaying book search results and books from list

class BookResultTile extends StatelessWidget {
  final Repository repositoryProvider;
  final BookResult result;
  final ListProvider listProvider;
  final TextEditingController controller;
  final FocusNode focus;

  const BookResultTile(
      {Key key,
      this.repositoryProvider,
      this.result,
      this.listProvider,
      this.controller,
      this.focus})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            controller.clear();
            focus.unfocus();
            Navigator.pushNamed(context, '/book-preview',
                arguments: BookPreviewArgs(
                    result.link,
                    '${result.authorNames.toString().replaceAll('[', '').replaceAll(']', '')}',
                    repositoryProvider,
                    listProvider,
                    result));
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: WHITE,
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: FutureBuilder(
                        future: repositoryProvider
                            .checkForCover(result.image.toString()),
                        builder: (BuildContext context,
                            AsyncSnapshot<dynamic> snapshot) {
                          return Container(
                            child: Image(
                              image: !snapshot.hasData
                                  ? AssetImage('assets/book-loading.gif')
                                  : !snapshot.data
                                      ? AssetImage(
                                          'assets/book-cover-placeholder.jpg')
                                      : NetworkImage(
                                          '$COVER_BY_ID${result.image}-M.jpg?default=false'),
                              height: 70,
                              width: 40,
                            ),
                          );
                        }),
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        result.title,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                          'by ${result.authorNames.toString().replaceAll('[', '').replaceAll(']', '')}'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

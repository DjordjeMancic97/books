import 'package:books/models/book_result.dart';
import 'package:books/providers/list_provider.dart';
import 'package:flutter/material.dart';
import '../../constants.dart';

class Dialogs {
  chooseListDialog(
      BuildContext context,
      Size size,
      ScrollController scrollController,
      ListProvider listProvider,
      BookResult bookResult) {
    showDialog(
        context: context,
        builder: (context) => Dialog(
              elevation: 1.0,
              backgroundColor: WHITE,
              child: Container(
                height: size.height / 3,
                width: size.width / 2,
                padding: EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: WHITE,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Choose list',
                          style: TextStyle(
                            color: BLACK,
                            fontSize: 28,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            height: 25,
                            width: 25,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: PURPLISH,
                            ),
                            child: Icon(
                              Icons.close,
                              color: WHITE,
                              size: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(top: 14),
                        child: Scrollbar(
                          controller: scrollController,
                          isAlwaysShown: true,
                          child: ListView.builder(
                              controller: scrollController,
                              itemCount: listProvider.customLists.length,
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onTap: listProvider.customLists[index]
                                              ['books']
                                          .contains(bookResult)
                                      ? () {
                                          listProvider.removeFromCustomList(
                                              listProvider.customLists[index]
                                                  ['name'],
                                              bookResult);
                                          Navigator.pop(context);
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                            content: Text(
                                                'Removed from \'${listProvider.customLists[index]['name']}\''),
                                          ));
                                        }
                                      : () {
                                          listProvider.addToCustomList(
                                              listProvider.customLists[index]
                                                  ['name'],
                                              bookResult);
                                          Navigator.pop(context);
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                            content: Text(
                                                'Added to \'${listProvider.customLists[index]['name']}\''),
                                          ));
                                        },
                                  child: Container(
                                    padding: EdgeInsets.all(14),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                            listProvider.customLists[index]
                                                ['name'],
                                            style: TextStyle(
                                              fontSize: 20,
                                              color: listProvider
                                                      .customLists[index]
                                                          ['books']
                                                      .contains(bookResult)
                                                  ? Colors.green
                                                  : BLACK,
                                              fontWeight: FontWeight.w400,
                                            )),
                                        listProvider.customLists[index]['books']
                                                .contains(bookResult)
                                            ? Icon(Icons.check,
                                                color: Colors.green, size: 24)
                                            : Container(),
                                      ],
                                    ),
                                  ),
                                );
                              }),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ));
  }
}

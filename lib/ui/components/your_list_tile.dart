import 'package:books/providers/list_provider.dart';
import 'package:books/providers/repository_provider.dart';
import 'package:books/ui/screens/list_view.dart';
import 'package:flutter/material.dart';
import '../../constants.dart';

class YourListTile extends StatelessWidget {
  final String listName;
  final int numOfItems;
  final List bookResults;
  final ListProvider listProvider;
  final Repository repositoryProvider;
  final int index;

  const YourListTile({
    Key key,
    this.listName,
    this.numOfItems,
    this.bookResults,
    this.listProvider,
    this.repositoryProvider,
    this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.pushNamed(context, '/list-view',
          arguments: ListViewArgs(listName, index)),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  listName,
                  style: TextStyle(
                    color: WHITE,
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      numOfItems.toString(),
                      style: TextStyle(
                        color: WHITE,
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

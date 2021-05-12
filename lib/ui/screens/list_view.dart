import 'package:books/constants.dart';
import 'package:books/providers/list_provider.dart';
import 'package:books/providers/repository_provider.dart';
import 'package:books/ui/components/book_result_tile.dart';
import 'package:books/ui/components/dialogs.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ListViewArgs {
  final String listName;
  final int index;

  ListViewArgs(this.listName, this.index);
}

class ListViewScreen extends StatefulWidget {
  @override
  _ListViewScreenState createState() => _ListViewScreenState();
}

class _ListViewScreenState extends State<ListViewScreen> {
  Dialogs _dialogs = Dialogs();
  ScrollController _scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    ListViewArgs args = ModalRoute.of(context).settings.arguments;
    ListProvider listProvider = Provider.of<ListProvider>(context);
    Repository repositoryProvider = Provider.of<Repository>(context);
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Color(0xff4964ba),
        centerTitle: true,
        title: Text(args.listName,
            style: TextStyle(
              color: WHITE,
              fontWeight: FontWeight.w700,
              fontSize: 24,
            )),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_rounded, color: WHITE, size: 24),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          args.listName == 'Currently reading' ||
                  args.listName == 'Want to read' ||
                  args.listName == 'Finished reading'
              ? Container()
              : IconButton(
                  icon: Icon(Icons.delete, color: WHITE, size: 24),
                  onPressed: () {
                    Navigator.pop(context);
                    Future.delayed(Duration(milliseconds: 300), () {
                      listProvider.deleteCustomList(args.listName);
                    });
                  },
                ),
        ],
      ),
      backgroundColor: PURPLISH,
      body: Container(
        height: size.height * 0.8,
        width: size.width,
        child: listProvider.customLists[args.index]['books'].length != 0
            ? ListView.builder(
                itemCount: listProvider.customLists[args.index]['books'].length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    margin: EdgeInsets.all(14),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 5,
                          child: BookResultTile(
                            result: listProvider.customLists[args.index]
                                ['books'][index],
                            listProvider: listProvider,
                            repositoryProvider: repositoryProvider,
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              IconButton(
                                icon: Icon(
                                  Icons.list_alt,
                                  color: WHITE,
                                ),
                                onPressed: () {
                                  _dialogs.chooseListDialog(
                                      context,
                                      size,
                                      _scrollController,
                                      listProvider,
                                      listProvider.customLists[args.index]
                                          ['books'][index]);
                                },
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.delete,
                                  color: WHITE,
                                ),
                                onPressed: () =>
                                    listProvider.removeFromCustomList(
                                        args.listName,
                                        listProvider.customLists[args.index]
                                            ['books'][index]),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              )
            : Center(
                child: Text(
                  'This list is empty.\nGo on and add some books!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: WHITE,
                    fontSize: 24,
                    fontWeight: FontWeight.w400,
                    height: 1.4,
                  ),
                ),
              ),
      ),
    );
  }
}

import 'package:books/constants.dart';
import 'package:books/models/book_result.dart';
import 'package:books/providers/list_provider.dart';
import 'package:books/providers/repository_provider.dart';
import 'package:books/ui/components/book_result_tile.dart';
import 'package:flutter/material.dart';

class AllResultsArgs {
  final String query;
  final Repository repositoryProvider;
  final ListProvider listProvider;

  AllResultsArgs(this.query, this.repositoryProvider, this.listProvider);
}

class AllResults extends StatefulWidget {
  @override
  _AllResultsState createState() => _AllResultsState();
}

class _AllResultsState extends State<AllResults> {
  @override
  Widget build(BuildContext context) {
    AllResultsArgs args = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      backgroundColor: WHITE,
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
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FutureBuilder(
              future: args.repositoryProvider.getAllResults(args.query),
              builder: (BuildContext context,
                  AsyncSnapshot<List<BookResult>> snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                } else {
                  return Container(
                    height: MediaQuery.of(context).size.height * 0.85,
                    width: MediaQuery.of(context).size.width,
                    child: ListView(children: [
                      Container(
                        padding: EdgeInsets.all(14),
                        child: Text(
                          '${snapshot.data.length} results for \"${args.query}\"',
                          style: TextStyle(
                            color: BLACK,
                            fontSize: 16,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                      for (BookResult result in snapshot.data)
                        BookResultTile(
                          listProvider: args.listProvider,
                          repositoryProvider: args.repositoryProvider,
                          result: result,
                        )
                    ]),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

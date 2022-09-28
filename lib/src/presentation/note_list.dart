// ignore_for_file: prefer_const_constructors
import 'package:consuming_restapi/src/data/api_response.dart';
import 'package:consuming_restapi/src/data/note_listing.dart';
import 'package:consuming_restapi/src/domain/notes_services.dart';
import 'package:consuming_restapi/src/presentation/note_delete.dart';
import 'package:consuming_restapi/src/presentation/note_modify.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class NoteList extends StatefulWidget {
  const NoteList({Key? key}) : super(key: key);

  @override
  State<NoteList> createState() => _NoteListState();
}

class _NoteListState extends State<NoteList> {
  String formatedDateTime(DateTime dateTime) {
    return '${dateTime.year}/${dateTime.month}/${dateTime.day}';
  }

  NoteServices get service => GetIt.I<NoteServices>();
  late ApiResponse<List<NoteListing>> _apiResponse;
  bool _isLoading = false;

  @override
  void initState() {
    _fetchNotes();
    super.initState();
  }

  _fetchNotes() async {
    setState(() {
      _isLoading = true;
    });
    _apiResponse = await service.getNoteList();
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Note list'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NoteModify()),
          ).then((value) => _fetchNotes());
        },
        child: Icon(Icons.add),
      ),
      body: Builder(
        builder: (context) {
          if (_isLoading) {
            return Center(child: CircularProgressIndicator());
          }

          if (_apiResponse.error!) {
            return Center(
              child: Text(_apiResponse.erorMessage.toString()),
            );
          }

          return ListView.separated(
            separatorBuilder: (context, index) {
              return Divider(
                height: 1,
                color: Colors.green,
              );
            },
            itemBuilder: (context, index) {
              return Dismissible(
                key: ValueKey(_apiResponse.data![index].noteId),
                direction: DismissDirection.startToEnd,
                onDismissed: (direction) {},
                confirmDismiss: (direction) async {
                  final result = await showDialog(
                    context: context,
                    builder: (context) => DeleteNoteView(),
                  );
                  late var message;
                  if (result) {
                    final deleteResponse = await service
                        .deleteNote(_apiResponse.data![index].noteId!);
                    if (deleteResponse.data == true && deleteResponse != null) {
                      message = "Succefully deleted note";
                    } else {
                      message =
                          deleteResponse.erorMessage ?? "An error ocurred";
                    }
                    Scaffold.of(context).showSnackBar(SnackBar(
                      content: Text(message),
                      duration: Duration(seconds: 4),
                    ));
                    return deleteResponse.data ?? false;
                  }
                  print(result);
                  return result;
                },
                background: Container(
                  color: Colors.red,
                  padding: EdgeInsets.only(left: 16),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Icon(
                      Icons.delete,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ),
                child: ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => NoteModify(
                                noteId: _apiResponse.data![index].noteId,
                              )),
                    ).then((value) => _fetchNotes());
                  },
                  title: Text(
                    _apiResponse.data![index].noteTitle.toString(),
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  subtitle: Text(
                    'Last edites on ${formatedDateTime(_apiResponse.data![index].dateCreated!)}',
                  ),
                ),
              );
            },
            itemCount: _apiResponse.data!.length,
          );
        },
      ),
    );
  }
}

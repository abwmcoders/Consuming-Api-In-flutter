// ignore_for_file: prefer_const_constructors

import 'package:consuming_restapi/src/data/note_editing.dart';
import 'package:consuming_restapi/src/data/note_insert.dart';
import 'package:consuming_restapi/src/domain/notes_services.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../data/note.dart';

class NoteModify extends StatefulWidget {
  const NoteModify({Key? key, this.noteId}) : super(key: key);

  final String? noteId;
  @override
  State<NoteModify> createState() => _NoteModifyState();
}

class _NoteModifyState extends State<NoteModify> {
  bool get isEditing => widget.noteId != null;
  NoteServices get noteServices => GetIt.I<NoteServices>();
  late final String errorMessage;
  late final Note note;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteContentController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    if (isEditing) {
      setState(() {
        _isLoading = true;
      });
      noteServices.getNoteById(widget.noteId!).then((value) {
        setState(() {
          _isLoading = false;
        });
        if (value.data != null) {
          note = value.data!;
          print('MY single note --> $note');
          _noteContentController.text = isEditing ? note.noteContent! : "";
          _titleController.text = isEditing ? note.noteTitle! : "";
        } else {
          print(value.error);
          errorMessage = value.erorMessage ?? "An error occured";
        }
      });
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: isEditing ? Text('Edit Note') : Text('Create Note'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextFormField(
                    controller: _titleController,
                    decoration: InputDecoration(label: Text('Note title')),
                  ),
                  SizedBox(height: 8),
                  TextFormField(
                    controller: _noteContentController,
                    decoration: InputDecoration(label: Text('Note content')),
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 35,
                    child: OutlinedButton(
                      onPressed: () async {
                        if (isEditing) {
                          // edit the note
                           setState(() {
                            _isLoading = true;
                          });
                          final note = NoteEditing(
                              noteTitle: _titleController.text,
                              noteContent: _noteContentController.text);
                          final result = await noteServices.updateNote(note, widget.noteId!);
                          setState(() {
                            _isLoading = false;
                          });
                          final title = 'Done';
                          final text = result.error!
                              ? result.erorMessage ?? "An error ocurred"
                              : "Note updated succesfully";

                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text(title),
                              content: Text(text),
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text('OK'))
                              ],
                            ),
                          ).then((value) {
                            if (result.data!) {
                              print(result.data);
                              Navigator.pop(context);
                            }
                          });

                        } else {
                          // create a new note
                          setState(() {
                            _isLoading = true;
                          });
                          final note = NoteInsert(
                              noteTitle: _titleController.text,
                              noteContent: _noteContentController.text);
                          final result = await noteServices.createNote(note);
                          setState(() {
                            _isLoading = false;
                          });
                          final title = 'Done';
                          final text = result.error!
                              ? result.erorMessage ?? "An error ocurred"
                              : "Note created succesfully";

                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text(title),
                              content: Text(text),
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text('OK'))
                              ],
                            ),
                          ).then((value) {
                            if (result.data!) {
                              print(result.data);
                              Navigator.pop(context);
                            }
                          });
                        }
                      },
                      style: OutlinedButton.styleFrom(
                        backgroundColor:
                            Theme.of(context).primaryColor, //<-- SEE HERE
                      ),
                      child: Text(
                        'Submit',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  )
                ],
              ),
            ),
    );
  }
}

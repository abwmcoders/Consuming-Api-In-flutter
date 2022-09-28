import 'dart:convert';

import 'package:consuming_restapi/src/data/api_response.dart';
import 'package:consuming_restapi/src/data/note_editing.dart';
import 'package:consuming_restapi/src/data/note_insert.dart';
import 'package:consuming_restapi/src/data/note_listing.dart';
import 'package:http/http.dart' as http;

import '../data/note.dart';

class NoteServices {
  static const API = 'https://tq-notes-api-jkrgrdggbq-el.a.run.app';
  static const header = {
    'apikey': '2deda1a9-94cf-4804-8d4b-0658979c15f2',
    'Content-Type': 'application/json',
  };

// GEt all notes
  Future<ApiResponse<List<NoteListing>>> getNoteList() {
    return http.get(Uri.parse(API + '/notes'), headers: header).then((value) {
      if (value.statusCode == 200) {
        print('THe data get ----> ${value.body}');
        final jsonData = json.decode(value.body);
        final notes = <NoteListing>[];
        for (var item in jsonData) {
          notes.add(NoteListing.fromjson(item));
        }
        return ApiResponse<List<NoteListing>>(
          data: notes,
        );
      } else {
        return ApiResponse<List<NoteListing>>(
          error: true,
          erorMessage: 'An error occurred',
        );
      }
    }).catchError((_) {
      print(_);
      return ApiResponse<List<NoteListing>>(
        error: true,
        erorMessage: 'An error occurred',
      );
    });
  }

  // Get note by id
  Future<ApiResponse<Note>> getNoteById(String noteId) {
    return http
        .get(Uri.parse(API + '/notes/' + noteId), headers: header)
        .then((value) {
      if (value.statusCode == 200) {
        print('THe individual note ----> ${value.body}');
        final jsonData = json.decode(value.body);
        final note = Note.fromjson(jsonData);
        return ApiResponse<Note>(data: note);
      } else {
        return ApiResponse<Note>(error: true, erorMessage: 'An error occured');
      }
    }).catchError((_) {
      print(_);
      return ApiResponse<Note>(error: true, erorMessage: "An error occurred");
    });
  }

  // create note
  Future<ApiResponse<bool?>> createNote(NoteInsert insertItem) {
    return http
        .post(Uri.parse(API + '/notes'),
            headers: header, body: json.encode(insertItem.toJson()))
        .then((value) {
      if (value.statusCode == 201) {
        return ApiResponse<bool>(data: true);
      } else {
        return ApiResponse<bool>(error: true, erorMessage: "An error occurred");
      }
    }).catchError((_) {
      print(_);
      return ApiResponse<bool>(error: true, erorMessage: "An error occured");
    });
  }

  // updating note
  Future<ApiResponse<bool?>> updateNote(NoteEditing editItem, String noteId) {
    return http
        .put(Uri.parse(API + '/notes/' + noteId),
            headers: header, body: json.encode(editItem.toJson()))
        .then((value) {
      if (value.statusCode == 204) {
        return ApiResponse<bool>(data: true);
      } else {
        return ApiResponse<bool>(error: true, erorMessage: "An error occurred");
      }
    }).catchError((_) {
      print(_);
      return ApiResponse<bool>(error: true, erorMessage: "An error occured");
    });
  }

  // Deleting note by id
  Future<ApiResponse<bool?>> deleteNote(String noteId) {
    return http
        .delete(Uri.parse(API + '/notes/' + noteId), headers: header)
        .then((value) {
      if (value.statusCode == 204) {
        return ApiResponse<bool>(data: true);
      } else {
        return ApiResponse<bool>(error: true, erorMessage: "An error occurred");
      }
    }).catchError((_) {
      print(_);
      return ApiResponse<bool>(error: true, erorMessage: "An error occured");
    });
  }
}

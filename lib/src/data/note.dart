class Note{
  final String? noteId, noteTitle, noteContent;
  final DateTime? dateCreated, lastEdited;

  Note({this.noteId, this.noteTitle, this.noteContent, this.dateCreated, this.lastEdited});

  factory Note.fromjson(Map<String, dynamic> jsonData) {
    return Note(
          noteId: jsonData['noteID'],
          noteTitle: jsonData['noteTitle'],
          noteContent: jsonData['noteContent'],
          dateCreated: DateTime.parse(jsonData['createDateTime']),
          lastEdited: jsonData['lastEditDateTime'] != null
              ? DateTime.parse(jsonData['lastEditDateTime'])
              : null,
        );
  }
}
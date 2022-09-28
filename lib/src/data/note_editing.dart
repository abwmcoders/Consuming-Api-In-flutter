class NoteEditing {
  final String noteTitle, noteContent;

  NoteEditing({required this.noteTitle, required this.noteContent});

  Map<String, dynamic> toJson() {
    return {
      "noteTitle": noteTitle,
      "noteContent": noteContent,
    };
  }
}

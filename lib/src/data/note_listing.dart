class NoteListing {
  final String? noteId, noteTitle;
  final DateTime? dateCreated, lastEdited;

  NoteListing({this.noteId, this.noteTitle, this.dateCreated, this.lastEdited});

  factory NoteListing.fromjson(Map<String, dynamic> item){
    return NoteListing(
            noteId: item['noteID'],
            noteTitle: item['noteTitle'],
            dateCreated: DateTime.parse(item['createDateTime']),
            lastEdited: item['latestEditDateTime'] != null
                ? DateTime.parse(item['latestEditDateTime'])
                : null,
          );
  }
}

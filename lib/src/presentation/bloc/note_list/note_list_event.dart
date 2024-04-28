part of 'note_list_bloc.dart';

@immutable
sealed class NoteListEvent {}


class FetchInitialNotes extends NoteListEvent {}

class CreatedNote extends NoteListEvent {
  final String title;

  CreatedNote({
    required this.title,
   });
}

class DeletedNote extends NoteListEvent {
  final int index;

  DeletedNote({
    required this.index,
  });
}

class UpdatedNote extends NoteListEvent {
  final int index;
  final String? title;
  final String? description;
  final bool? noteIsClosed;

  UpdatedNote({
    required this.index,
    this.title,
    this.description,
    this.noteIsClosed,
});

}

class ClickedNote extends NoteListEvent {
  final int id;

  ClickedNote({
    required this.id
  });
}
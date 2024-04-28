part of 'note_list_bloc.dart';

@immutable
sealed class NoteListState {}

final class NoteListInitial extends NoteListState {}

final class NoteListEmpty extends NoteListState {}

final class NoteListLoading extends NoteListState {}

final class NoteListError extends NoteListState {
  final String message;

  NoteListError({
    required this.message,
  });
}

final class NoteListLoaded extends NoteListState {
  final List<NoteModel> notes;

  NoteListLoaded({
    required this.notes,
  });

}

final class NavigateToDetailedScreen extends NoteListState {
  final NoteModel note;

  NavigateToDetailedScreen({
    required this.note,
  });
}
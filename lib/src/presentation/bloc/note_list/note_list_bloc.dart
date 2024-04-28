import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../data/model/note_list_model.dart';
import '../../../domain/repository/note_repository.dart';

part 'note_list_event.dart';
part 'note_list_state.dart';

class NoteListBloc extends Bloc<NoteListEvent, NoteListState> {
  final List<NoteModel> notesList = [];
  final NoteRepository noteRepository;

  NoteListBloc(this.noteRepository) : super(NoteListInitial()) {
    on<CreatedNote>(_createdNote);
    on<DeletedNote>(_deletedNote);
    on<UpdatedNote>(_updatedNote);
    on<ClickedNote>(_clickedNote);
    on<FetchInitialNotes>(_initialFetchNotes);
  }

  void _initialFetchNotes(
      FetchInitialNotes event, Emitter<NoteListState> emit) async {
    emit(NoteListLoading());
    try{
      final notes = await noteRepository.notes();
      if(notes.isEmpty){
        emit(NoteListEmpty());
        return;
      }
      emit(NoteListLoaded(notes: notes));
    } catch (e) {
      emit(NoteListError(message: e.toString()));
    }
  }

  void _createdNote(CreatedNote event, Emitter<NoteListState> emit) async {
    emit(NoteListLoading());
    try{


      final newNote = await noteRepository.add(NoteModel(
        title: event.title,
        description: 'test',
      ));
      emit(NavigateToDetailedScreen(note: newNote));
    } catch (e) {
      emit(NoteListError(message: e.toString()));
    }
  }

  void _deletedNote(DeletedNote event, Emitter<NoteListState> emit) async {
    emit(NoteListLoading());
    try{
      await noteRepository.delete(event.index);

      final notes = await noteRepository.notes();
      // if notes is empty, emit NotesListInitial
      if(notes.isEmpty) {
        emit(NoteListInitial());
        return;
      }
      // Emit the updated notes
      emit(NoteListLoaded(notes: notes));
    } catch (e) {
      emit(NoteListError(message: e.toString()));
    }
  }

  void _updatedNote(UpdatedNote event, Emitter<NoteListState> emit) async {
    emit(NoteListLoading());
    try{
      final updatedNote = await noteRepository.update(
        NoteModel(
            id: event.index,
            title: event.title ?? '',
            description: event.description,
        ),
      );
      // to close the note
      if(event.noteIsClosed == true) {
        final notes = await noteRepository.notes();
        emit(NoteListLoaded(notes: notes));
        return;
      }
      emit(NavigateToDetailedScreen(note: updatedNote));
    } catch (e) {
      emit(NoteListError(message: e.toString()));
    }
  }

  void _clickedNote(ClickedNote event, Emitter<NoteListState> emit) async {
    emit(NoteListLoading());
    try{
      final note = await noteRepository.noteById(event.id);
      emit(NavigateToDetailedScreen(note: note));
    } catch (e) {
      emit(NoteListError(message: e.toString()));
    }
  }
}

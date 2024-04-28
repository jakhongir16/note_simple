import '../../data/model/note_list_model.dart';
import '../providers/note_db.dart';

class NoteRepository {
  final NoteProvider noteProvider;
  NoteRepository(this.noteProvider);

  // Fetch notes
  Future<List<NoteModel>> notes() async {
    try{
      final List<NoteModel> notes = await noteProvider.notes();

      return notes;
    } catch (e) {
      rethrow;
    }
  }


  // Add note
  Future<NoteModel> add(NoteModel note) async {
    try{
      await noteProvider.insert(note);

      //Return the added note by fetching it from the database
      return await noteProvider.lastNote();
    } catch (e) {
      rethrow;
    }
  }

  // Update note return the updated note
  Future<NoteModel> update(NoteModel note) async {
    try{
      await noteProvider.update(note);

      // return await noteProvider by fetching from the database
      return await noteProvider.noteById(note.id!);
    } catch (e) {
      rethrow;
    }
  }

  // Delete note
  Future<void> delete(int id) async {
    try{
      await noteProvider.delete(id);
    } catch (e) {
      rethrow;
    }
  }

  // Receive note by id
  Future<NoteModel> noteById(int id) async {
    try{
      return await noteProvider.noteById(id);
    } catch (e) {
      rethrow;
    }
  }
}
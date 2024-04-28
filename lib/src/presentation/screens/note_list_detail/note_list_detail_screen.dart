import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/note_list/note_list_bloc.dart';

class NoteListDetailScreen extends StatefulWidget {
  const NoteListDetailScreen({super.key});

  @override
  State<NoteListDetailScreen> createState() => _NoteListDetailScreenState();
}

class _NoteListDetailScreenState extends State<NoteListDetailScreen> {
  // Timer
  Timer? timer;

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void resetTimer(String value, int index, String title, {bool noteIsClosed = false}) {
    // cancel the previous timer, if any
    timer?.cancel();
    // Start a new timer

    // if value and index are not null, then start the timer
    if(noteIsClosed == true){
      context.read<NoteListBloc>().add(
        UpdatedNote(
          title: title,
          index: index,
          description: value,
          noteIsClosed: noteIsClosed,
        )
      );
    } else if(noteIsClosed == false) {
      timer = Timer(const Duration(seconds: 1), (){
        debugPrint('Auto-saving... $value, $index');
        // Auto-save after 2 seconds of inactivity
        context.read<NoteListBloc>().add(
          UpdatedNote(
            title: title,
            index: index,
            description: value,
          )
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NoteListBloc, NoteListState>(
      builder: (context, state){
        if(state is NoteListLoading) {
          return const Center(
            child: CircularProgressIndicator.adaptive(),
          );
        } else if(state is NavigateToDetailedScreen) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Theme.of(context).colorScheme.primary,
              title: GestureDetector(
                onTap: (){
                  // Обрабатывай событие касания, чтобы сделать заголовок редактируемым
                  // Вы можете использовать диалоговое окно или перейти на новый экран для редактирования
                  // Для простоты покажем диалог
                  showDialog(
                    context: context,
                    builder: (context){
                      String editedTitle = state.note.title;
                      return AlertDialog(
                        title: Text(
                          'Edit Title',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.inversePrimary),
                        ),
                        content: TextFormField(
                          initialValue: state.note.title,
                          onChanged: (value){
                            editedTitle = value;
                          },
                        ),
                        actions: [
                          TextButton(
                            onPressed: (){
                              context.read<NoteListBloc>().add(
                                UpdatedNote(
                                  index: state.note.id!,
                                  title: editedTitle,
                                  description: state.note.description,
                                ),
                              );
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              'Save',
                              style: TextStyle(
                                color: Theme.of(context)
                                    .colorScheme
                                    .inversePrimary
                              ),
                            ),
                          )
                        ],
                      );
                    },
                  );
                },
                child: Text(
                  state.note.title,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.inversePrimary),
                ),
              ),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios),
                onPressed: (){
                  resetTimer(
                  state.note.description!,
                  state.note.id!,
                  state.note.title,
                  noteIsClosed: true);
                  Navigator.pop(context);
                },
              ),
            ),
            body: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: TextField(
                  controller: TextEditingController(text: state.note.description),
                  maxLines: null,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: null,
                  style: const TextStyle(
                    fontSize: 19,
                    height: 1.5,
                  ),
                  onChanged: (value){
                    // Reset the timer when the text changes
                    resetTimer(value, state.note.id!, state.note.title);
                  },
                ),
              ),
            ),
          );
        }
        return const SizedBox();
      },
    );
  }
}
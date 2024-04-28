import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_note/src/presentation/bloc/note_list/note_list_bloc.dart';

class NoteListScreen extends StatelessWidget {
  const NoteListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 120, bottom: 20),
            child: Center(
              child: Text(
                'Note',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.normal,
                  color: Theme.of(context).colorScheme.inversePrimary,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20,),
          Padding(
            padding: const EdgeInsets.only(right: 20, left: 20),
            child: Container(
              height: 1,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          Expanded(
            child: BlocConsumer<NoteListBloc, NoteListState>(
              listener: (context, state){
                if(state is NoteListError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.message),
                    ));
                }
              },
              builder: (context, state){
                if(state is NoteListInitial) {
                  context.read<NoteListBloc>().add(
                    FetchInitialNotes(),
                  );
                  return const Scaffold();
                }  else if(state is NoteListEmpty){
                  return Center(
                    child: Text(
                      'No notes yet',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.inversePrimary,
                      ),
                    ),
                  );
                } else if(state is NoteListLoading) {
                  return const Center(
                    child: CircularProgressIndicator.adaptive(),
                  );
                } else if(state is NoteListLoaded) {
                  return ListView.builder(
                      itemCount: state.notes.length,
                      itemBuilder: (context, index){
                        return GestureDetector(
                          onTap: (){
                            context.read<NoteListBloc>().add(
                              ClickedNote(
                                id: state.notes[index].id!,
                              )
                            );
                            Navigator.pushNamed(
                              context,
                              '/note_list_detail_screen',
                            );
                          },
                          child: ListTile(
                            title: Text(
                              state.notes[index].title,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.inversePrimary,
                              ),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(
                                    Icons.delete,
                                    color: Theme.of(context).colorScheme
                                    .inversePrimary,
                                  ),
                                  onPressed: (){
                                    context.read<NoteListBloc>().add(
                                      DeletedNote(
                                        index: state.notes[index].id!,
                                      )
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      });
                }
                return const SizedBox();
              },
            ),
          )
        ],
      ),
      floatingActionButton: BlocBuilder<NoteListBloc, NoteListState>(
        builder: (context, state){
          debugPrint("State: $state");
          if(state is NoteListLoaded) {
            return FloatingActionButton(
              backgroundColor: Theme.of(context).colorScheme.primary,
              child: Icon(
                Icons.add,
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
              onPressed: (){
                context.read<NoteListBloc>().add(
                  CreatedNote(title: "New note")); // To add the note to the list
                  Navigator.pushNamed(context, '/note_list_detail_screen');
              },
            );
          } else if(state is NoteListInitial || state is NoteListEmpty) {
            return FloatingActionButton(
              backgroundColor: Theme.of(context).colorScheme.primary,
              child: Icon(
                Icons.add,
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
              onPressed: (){
                context.read<NoteListBloc>().add(
                  CreatedNote(title: "New Note"));
                  Navigator.pushNamed(context, '/note_list_detail_screen');
              },
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
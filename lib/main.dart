import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_note/src/domain/repository/note_repository.dart';
import 'package:simple_note/src/presentation/screens/note_list_detail/note_list_detail_screen.dart';
import 'package:simple_note/src/presentation/screens/note_list_screen/note_list_screen.dart';

import 'src/core/observer_bloc/app_bloc_observer.dart';
import 'src/core/theme/dark_mode.dart';
import 'src/core/theme/light_mode.dart';
import 'src/domain/providers/note_db.dart';
import 'src/presentation/bloc/note_list/note_list_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // initialize the database
  await NoteProvider.init();
  Bloc.observer = AppBlocObserver();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => NoteRepository(NoteProvider()),
      child: BlocProvider(
        create: (context) => NoteListBloc(context.read<NoteRepository>()),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Note App',
          theme: lightMode,
          darkTheme: darkMode,
          home: const NoteListScreen(),
          initialRoute: '/note_list_screen',
          routes: {
            '/note_list_screen': (context) => const NoteListScreen(),
            '/note_list_detail_screen': (context) =>
            const NoteListDetailScreen(),
          },
        ),
      ),
    );
  }
}


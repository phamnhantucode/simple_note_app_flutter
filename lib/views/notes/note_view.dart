import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart' show ReadContext;
import 'package:mynotesbeginer/constants/routes.dart';
import 'package:mynotesbeginer/extension/buildcontext/loc.dart';
import 'package:mynotesbeginer/services/auth/auth_service.dart';
import 'package:mynotesbeginer/services/auth/bloc/auth_bloc.dart';
import 'package:mynotesbeginer/services/auth/bloc/auth_event.dart';
import 'package:mynotesbeginer/services/cloud/firebase_cloud_storage.dart';
import 'package:mynotesbeginer/utilities/dialogs/log_out_dialog.dart';
import 'package:mynotesbeginer/views/notes/notes_list_view.dart';
import '../../enums/menu_actions.dart';
// import '../../services/crud/notes_service.dart';
import 'dart:developer' as dev show log;


extension Count<T extends Iterable> on Stream<T> {
  Stream<int> get getLength => map((event) => event.length);
}

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  late final FirebaseCloudStorage _notesService;

  String get userId => AuthService.firebase().currentUser!.id;
  @override
  void initState() {
    _notesService = FirebaseCloudStorage();
    super.initState();
  }

  // @override
  // void dispose() {
  //   _notesService.close();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: StreamBuilder<int>(
          stream: _notesService.allNotes(ownerUserId: userId).getLength,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final noteCount = snapshot.data ?? 0;
              return Text(context.loc.notes_title(noteCount));
            }
            return const Text('');
          }
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(createOrUpdateNoteRoute);
            },
            icon: const Icon(Icons.add),
          ),
          PopupMenuButton<MenuAction>(
            onSelected: (value) async {
              switch (value) {
                case MenuAction.logout:
                  final result = await showLogoutDialog(context);
                  if (result) {
                    // ignore: use_build_context_synchronously
                    context.read<AuthBloc>().add(const AuthEventLogout());
                  }
              }
            },
            itemBuilder: (context) {
              return const [
                PopupMenuItem<MenuAction>(
                  value: MenuAction.logout,
                  child: Text('Logout'),
                )
              ];
            },
          )
        ],
      ),
      body: StreamBuilder(
          stream: _notesService.allNotes(ownerUserId: userId),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return const Text('Waiting for all note...');

              case ConnectionState.active:
                if (snapshot.hasData) {
                  final allNotes = snapshot.data!;
                  dev.log(allNotes.toString());
                  return NoteListView(
                    onDeleteNote: (note) async {
                      await _notesService.deleteNote(
                          documentId: note.documentId);
                    },
                    notes: allNotes,
                    onTap: (note) {
                      Navigator.of(context).pushNamed(
                        createOrUpdateNoteRoute,
                        arguments: note,
                      );
                    },
                  );
                } else {
                  return const CircularProgressIndicator();
                }
              default:
                return const CircularProgressIndicator();
            }
          }),
    );
  }
}

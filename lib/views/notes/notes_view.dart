import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/consts/routes.dart';
import 'package:notes_app/enums/menu_action.dart';
import 'package:notes_app/services/auth/auth_service.dart';
import 'package:notes_app/services/auth/bloc/auth_bloc.dart';
import 'package:notes_app/services/auth/bloc/auth_events.dart';
import 'package:notes_app/services/cloud/cloud_note.dart';
import 'package:notes_app/utils/dialog/logout_dialog.dart';
import 'notes_list_view.dart';
import 'package:notes_app/services/cloud/firebase_cloud_storage.dart';

class NotesView extends StatefulWidget {
  const NotesView({Key? key}) : super(key: key);

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  late final FirebaseCloudStorage _firebaseCloudStorage;

  String get userEmail => AuthService.firebase().getCurrentUser!.email;
  String get userId => AuthService.firebase().getCurrentUser!.userId;

  @override
  void initState() {
    _firebaseCloudStorage = FirebaseCloudStorage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notes"),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(createUpdateNoteRoute);
              },
              icon: const Icon(Icons.add)),
          PopupMenuButton<MenuAction>(onSelected: (value) async {
            switch (value) {
              case MenuAction.logout:
                final shouldLogout = await showLogoutDialog(context);
                if (shouldLogout) {
                  context.read<AuthBloc>().add(const AuthEventLogOut());
                }
            }
          }, itemBuilder: (context) {
            return [
              const PopupMenuItem<MenuAction>(
                  value: MenuAction.logout, child: Text("Logout")),
            ];
          }),
        ],
      ),
      body: StreamBuilder(
        stream: _firebaseCloudStorage.allNotes(ownerUserId: userId),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
            case ConnectionState.active:
              if (snapshot.hasData) {
                final allNotes = snapshot.data as Iterable<CloudNote>;
                return NotesListView(
                  notes: allNotes,
                  onDeleteNote: (note) async {
                    await _firebaseCloudStorage.deleteNote(documentId: note.documentId);
                  },
                  onTapNote: (note) {
                    Navigator.of(context).pushNamed(
                      createUpdateNoteRoute,
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
        },
      )
    );
  }
}

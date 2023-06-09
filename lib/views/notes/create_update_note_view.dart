import 'package:flutter/material.dart';
import 'package:notes_app/services/auth/auth_service.dart';
import 'package:notes_app/services/cloud/cloud_note.dart';
import 'package:notes_app/utils/dialog/cannot_share_empty_note_dialog.dart';
import 'package:notes_app/utils/generics/get_arguments.dart';
import 'package:notes_app/services/cloud/firebase_cloud_storage.dart';
import 'package:share_plus/share_plus.dart';

class CreateUpdateNoteView extends StatefulWidget {
  const CreateUpdateNoteView({Key? key}) : super(key: key);

  @override
  State<CreateUpdateNoteView> createState() => _CreateUpdateNoteViewState();
}

class _CreateUpdateNoteViewState extends State<CreateUpdateNoteView> {
  CloudNote? _note;
  late final FirebaseCloudStorage _firebaseCloudStorage;
  late final TextEditingController _textController;

  Future<CloudNote> createOrGetExistingNote(BuildContext context) async {
    final widgetNote = context.getArgument<CloudNote>();

    if (widgetNote != null) {
      _note = widgetNote;
      _textController.text = widgetNote.text;
      return widgetNote;
    }

    final existingNote = _note;
    if (existingNote != null) {
      return existingNote;
    }
    final currentUser = AuthService.firebase().getCurrentUser!;
    final newNote = await _firebaseCloudStorage.createNewNote(
        ownerUserId: currentUser.userId);
    _note = newNote;
    return newNote;
  }

  void _deleteNoteIfTextIsEmpty() {
    final note = _note;
    if (_textController.text.isEmpty && note != null) {
      _firebaseCloudStorage.deleteNote(documentId: note.documentId);
    }
  }

  void _saveNoteIfTextNotEmpty() async {
    final note = _note;
    final text = _textController.text;
    if (text.isNotEmpty && note != null) {
      await _firebaseCloudStorage.updateNote(
          documentId: note.documentId, text: text);
    }
  }

  void _textControllerListener() async {
    final note = _note;
    if (note == null) {
      return;
    }
    final text = _textController.text;
    await _firebaseCloudStorage.updateNote(
        documentId: note.documentId, text: text);
  }

  void _setupTextControllerListener() {
    _textController.removeListener(_textControllerListener);
    _textController.addListener(_textControllerListener);
  }

  @override
  void initState() {
    _textController = TextEditingController();
    _firebaseCloudStorage = FirebaseCloudStorage();
    super.initState();
  }

  @override
  void dispose() {
    _deleteNoteIfTextIsEmpty();
    _saveNoteIfTextNotEmpty();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("New Note"),
        actions: [
          IconButton(
            onPressed: () async{
              final text = _textController.text;
              if(_note == null || text.isEmpty) {
                await showCanNotShareDialog(context);
              }else{
                Share.share(text);
              }
            },
            icon: const Icon(Icons.share),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder(
            future: createOrGetExistingNote(context),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.done:
                  _setupTextControllerListener();
                  return TextField(
                    autofocus: true,
                    controller: _textController,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration: const InputDecoration(
                      hintText: "Write note here",
                    ),
                  );
                default:
                  return const CircularProgressIndicator();
              }
            }),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:mynotesbeginer/services/auth/auth_service.dart';
import 'package:mynotesbeginer/utilities/dialogs/cannot_share_empty_note_dialog.dart';
import 'package:mynotesbeginer/utilities/generic/get_argurements.dart';
// import '../../services/crud/notes_service.dart';
import 'package:mynotesbeginer/services/cloud/cloud_note.dart';
// import 'package:mynotesbeginer/services/cloud/cloud_storage_exceptions.dart';
import 'package:mynotesbeginer/services/cloud/firebase_cloud_storage.dart';
import 'package:share_plus/share_plus.dart';

class CreateUpdateNoteView extends StatefulWidget {
  const CreateUpdateNoteView({super.key});

  @override
  State<CreateUpdateNoteView> createState() => _CreateUpdateNoteViewState();
}

class _CreateUpdateNoteViewState extends State<CreateUpdateNoteView> {
  CloudNote? _note;
  late final FirebaseCloudStorage _noteService;
  late final TextEditingController _textEditingController;

  Future<CloudNote> createOrGetExistingNote() async {
    try {
      final widgetNote = context.getArgument<CloudNote>();

      if (widgetNote != null) {
        _note = widgetNote;
        _textEditingController.text = widgetNote.text;
        return widgetNote;
      }

      final existingNote = _note;
      if (existingNote != null) {
        return existingNote;
      }
      final currentUser = AuthService.firebase().currentUser!;
      // final email = currentUser.email;

      // final owner = await _noteService.getUser(email: email);
      // final newNote = await _noteService.createNote(owner: owner);
      final newNote =
          await _noteService.createNewNote(ownerUserId: currentUser.id);
      _note = newNote;
      return newNote;
    } catch (e) {
      throw Exception();
    }
  }

  void _deleteNoteIfTextIsEmpty() {
    final note = _note;
    if (_textEditingController.text.isEmpty && note != null) {
      _noteService.deleteNote(documentId: note.documentId);
    }
  }

  void _saveNoteIfTextIsNotEmpty() async {
    final note = _note;
    if (_textEditingController.text.isNotEmpty && note != null) {
      _noteService.updateNote(
        documentId: note.documentId,
        text: _textEditingController.text,
      );
    }
  }

  void _textControllerListener() async {
    final note = _note;
    if (note == null) {
      return;
    }
    final text = _textEditingController.text;
    _noteService.updateNote(documentId: note.documentId, text: text);
  }

  void _setupTextControllerListener() async {
    _textEditingController.removeListener(_textControllerListener);
    _textEditingController.addListener(_textControllerListener);
  }

  @override
  void initState() {
    _noteService = FirebaseCloudStorage();
    _textEditingController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _saveNoteIfTextIsNotEmpty();
    _deleteNoteIfTextIsEmpty();
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("New Note"),
        actions: [
          IconButton(
            onPressed: () async {
              final text = _textEditingController.text;
              if (_note == null || text.isEmpty) {
                await showCannotShareEmptyNoteDialog(context);
              } else {
                await Share.share(text);
              }

            },
            icon: const Icon(Icons.share),
          ),
        ],
      ),
      body: FutureBuilder(
          future: createOrGetExistingNote(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                _setupTextControllerListener();
                return TextField(
                  controller: _textEditingController,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  decoration: const InputDecoration(
                    hintText: 'Start typing your note...',
                  ),
                );
              default:
                return Container();
            }
          }),
    );
  }
}

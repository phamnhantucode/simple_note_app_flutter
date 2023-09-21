import 'package:flutter/material.dart';
import 'package:mynotesbeginer/services/cloud/cloud_note.dart';
// import 'package:mynotesbeginer/services/crud/notes_service.dart';
import 'package:mynotesbeginer/utilities/dialogs/delete_dialog.dart';

typedef NoteCallBack = void Function(CloudNote note);

class NoteListView extends StatelessWidget {
  const NoteListView({
    super.key,
    required this.onDeleteNote,
    required this.notes,
    required this.onTap,
  });
  final NoteCallBack onDeleteNote;
  final NoteCallBack onTap;
  final Iterable<CloudNote> notes;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: notes.length,
      itemBuilder: (context, index) {
        final note = notes.elementAt(index);
        return ListTile(
          onTap: () => onTap(note),
          title: Text(
            note.text,
            maxLines: 1,
            softWrap: true,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: IconButton(
              onPressed: () async {
                final shouldDelete = await showDeleteDialog(context);
                if (shouldDelete) {
                  onDeleteNote(note);
                }
              },
              icon: const Icon(Icons.delete)),
        );
      },
    );
  }
}

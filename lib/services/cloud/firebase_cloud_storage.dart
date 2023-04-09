import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:notes_app/services/cloud/cloud_note.dart';
import 'package:notes_app/services/cloud/cloud_storage_constants.dart';
import 'package:notes_app/services/cloud/cloud_storage_exceptions.dart';

//shared instance
class FirebaseCloudStorage {
  // return collections reference
  final notes = FirebaseFirestore.instance.collection('notes');

  Future<void> updateNote({
    required String documentId,
    required String text,
  }) async {
    try {
      await notes.doc(documentId).update({textFieldName: text});
    } catch (e) {
      throw CouldNotUpdateNoteException();
    }
  }

  Future<void> deleteNote({required String documentId}) async {
    try {
      await notes.doc(documentId).delete();
    } catch (e) {
      throw CouldNotDeleteNoteException();
    }
  }

  // returns document reference
  Future<CloudNote> createNewNote({required String ownerUserId}) async {
    return await notes
        .add({
          ownerUserIdFieldName: ownerUserId,
          textFieldName: "",
        })
        .then((doc) => doc.get())
        .then((docSnapshot) => CloudNote.fromDocumentSnapshot(docSnapshot));
  }


  /// Returns Stream of all notes for given user.
  /// Query itself makes sure that all notes retrieved belong to respective user.
  /// Query is made on the Database.
  Stream<Iterable<CloudNote>> allNotes({required String ownerUserId}) {
    // two ways of doing same things
    // either get all docs and check the ones with userID
    // or query those docs which have user ID

    // return notes.snapshots().map((querySnapshot) => querySnapshot.docs
    //     .map((doc) => CloudNote.fromSnapshot(doc))
    //     .where((note) => note.ownerUserId == ownerUserId));

    return notes
        .where(ownerUserIdFieldName, isEqualTo: ownerUserId)
        .snapshots()
        .map((querySnapshot) =>
            querySnapshot.docs.map((doc) => CloudNote.fromQuerySnapshot(doc)));
  }

  /// Returns Iterable of all notes for given user.
  /// Query itself makes sure that all notes retrieved belong to respective user.
  /// query is made on the Database.
  Future<Iterable<CloudNote>> getNotes({required String ownerUserId}) async {
    try {
      return await notes
          .where(ownerUserIdFieldName, isEqualTo: ownerUserId)
          .get()
          .then((querySnapshot) => querySnapshot.docs.map(
              (queryDocumentSnapshot) =>
                  CloudNote.fromQuerySnapshot(queryDocumentSnapshot)));
    } catch (e) {
      throw CouldNotGetAllNotesException();
    }
  }

  static final FirebaseCloudStorage _shared =
      FirebaseCloudStorage._sharedInstance();

  FirebaseCloudStorage._sharedInstance();

  factory FirebaseCloudStorage() => _shared;
}

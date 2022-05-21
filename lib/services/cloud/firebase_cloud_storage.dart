import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:login_app/services/cloud/cloud_note.dart';
import 'package:login_app/services/cloud/cloud_storage_constants.dart';
import 'package:login_app/services/cloud/cloud_storage_exceptions.dart';
import 'package:login_app/services/crud/crud_exceptions.dart';

class FirebaseCloudStorage {
  final notes = FirebaseFirestore.instance.collection('notes');

  Future<void> deleteNote({required String documentId}) async {
    try {
      await notes.doc(documentId).delete();
    } catch (e) {
      throw CouldNotDeleteNoteExceptions();
    }
  }

  Future<void> updateNote({
    required String documentId,
    required String text,
  }) async {
    try {
      notes.doc(documentId).update({textFieldName: text});
    } catch (e) {
      throw CouldNortUpdateNoteException();
    }
  }

  Stream<Iterable<CloudNote>> allNotes({required String onwerUserId}) => notes
      .snapshots()
      .map((event) => event.docs.map((e) => CloudNote.fromSnapshot(e)).where(
            (element) => element.ownerUserId == onwerUserId,
          ));

  Future<Iterable<CloudNote>> getNotes({required String onwerUserId}) async {
    try {
      return await notes
          .where(
            ownerUserIdFieldName,
            isEqualTo: onwerUserId,
          )
          .get()
          .then(
            (value) => value.docs.map(
              (doc) {
                return CloudNote(
                  documentId: doc.id,
                  ownerUserId: doc.data()[ownerUserIdFieldName] as String,
                  text: doc.data()[textFieldName] as String,
                );
              },
            ),
          );
    } catch (e) {
      throw CouldNotGetAllNotesException();
    }
  }

  void createNewNote({required String ownerUserId}) async {
    await notes.add({ownerUserIdFieldName: ownerUserId, textFieldName: ''});
  }

  static final FirebaseCloudStorage _shared =
      FirebaseCloudStorage._sharedInstance();
  FirebaseCloudStorage._sharedInstance();
  factory FirebaseCloudStorage() => _shared;
}

import 'package:cloud_firestore/cloud_firestore.dart';

abstract class ParentDao {
  CollectionReference getCollection();

  docExists(String idToCheck) async {
    DocumentSnapshot doc = await getCollection().doc(idToCheck).get();
    return doc.exists;
  }

  updateValue(String parameter, var value, String docID) async {
    if (await docExists(docID)) {
      await getCollection().doc(docID).update({
        parameter: value,
      });
    }
  }

  // Be careful with this one
  deleteAllElementsFromCollection() async {
    QuerySnapshot querySnapshot = await getCollection().get();
    for (DocumentSnapshot ds in querySnapshot.docs) {
      ds.reference.delete();
    }
  }

  updateList(
      String parameter, var value, String docID, ListAction action) async {
    await getCollection().doc(docID).update({
      parameter: (action == ListAction.ADD)
          ? FieldValue.arrayUnion([value])
          : FieldValue.arrayRemove([value]),
    });
  }

  clearList(String parameter, String docID) {
    getCollection().doc(docID).update({
      parameter: [],
    });
  }
}

enum ListAction { ADD, REMOVE }

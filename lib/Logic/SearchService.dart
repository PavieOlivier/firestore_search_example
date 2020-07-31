import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class SearchService {
  searchByName(
      {@required String inCollection, @required String whithKeyNamed, @required String searchKey}) {
        print('getting the list');
        print(whithKeyNamed);
    return Firestore.instance
        .collection(inCollection)
        .where(searchKey,
            isEqualTo: whithKeyNamed.substring(0, 1).toUpperCase())
        .getDocuments();
  }
}

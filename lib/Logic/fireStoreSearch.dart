library firestore_indexing_search;

import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

//The base class
class FirestoreIndexingSearch {
  ///This will navigate you inside the search page
  static showSearch(
    BuildContext context, {
    @required String inCollection,
    @required String indexedField,
    @required SearchController searchController,
    PageTransitionType pageTransitionType = PageTransitionType.fade,
    Duration duration = const Duration(milliseconds: 300),
    bool bypassAuth = false,
  }) {
    if (bypassAuth == false) {
      if (FirebaseAuth.instance.currentUser() == null) {
        print(
            'Firestore_indexing Error: You need to be logged in order to Search, If for any reason, you whish to ignore this, set "BypassAuth" to true ');
        print(
            'Firestore_indexing Comment: Please use FirebaseAuth to authenticate your user and try again');
        return;
      }
    }
    if (searchController.custonResultWidget == null) {
      print(
          'Firestore_indexing Warning: You did not set the "ResultWidget" your search result will not be displayed ');
      print(
          'Firestore_indexing Comment: Configure the searchController.resultWidget, By passing it a STATEFULL widget\nPlease read the Documentation carefully');
      return;
    }

    Navigator.of(context).push(PageTransition(
        //TODO: check what happens when the duration is null
        duration: duration,
        child: _FirestoreSearchScreen(
          inCollection: inCollection,
          indexedField: indexedField,
          searchController: searchController,
        ),
        type: pageTransitionType));
  }
}

class SearchController {
  //TODO: need a way to index individual field
  var searchResult = [];

  ///this internal index must be given to your custom widget and it's value must be persisted
  int internalIndex;

  ///The widget to display in case the default
  Widget custonResultWidget;

  /// Use this to change the overall decoration of the FireStore indexed search page
  BoxDecoration searchPageBackgroundDecoration;

  ///The style of the textField typed text
  TextStyle textFieldTextStyle;

  ///The textField outer container decoration.
  ///the container is parent
  BoxDecoration textFieldOuterContainerDecoration;

  ///The textField outer container width
  double textFieldOuterContainerWidth;

  ///The textField outer container height
  double textFieldOuterContainerHeight;

  ///The textField outer container padding
  Padding textFieldOuterContainerPadding;

  ///The textField hint text
  String textFieldHintText;

  ///The value entered in the textfield
  String texFieldValue;

  ///The Input decoration of the search field
  InputDecoration inputDecoration;

  ///How will the text be aligned; default to center of the screen
  TextAlign textAlign;

  ///The color of the Active cursor
  Color cursorColor;

  ///Whether or not Display the keyboard
  bool autofocus;

  ///is autoCorrect enabled
  bool autoCorrect;
}

///Contains all indexing methods
class Indexer {
  ///Use this to scan your collections to check if your field is indexed here
  static Future<bool> isField(String named,
      {@required indexedInCollection, bool emptyBucket = false}) async {
    bool hasData;
    List<String> bucket = [];

    var tempData = await Firestore.instance
        .collection(indexedInCollection)
        .where(named.toString() + 'Key')
        .getDocuments();
    if (tempData.documents.length == 0) {
      print(
          'Firestore_indexing Error: The collection $indexedInCollection does not exist or is empty, The operation will be aborded');
      hasData = false;
      return hasData;
    }
    for (int i = 0; i < tempData.documents.length; i++) {
      if (tempData.documents[i][named + 'Key'] != null) {
        print(
            'Firestore_indexing: An Indexed Field was found in the database: DocumentID is: ${tempData.documents[i].documentID} ');
        bucket.add(tempData.documents[i].documentID.toString());
      }
    }
    if (bucket.isNotEmpty) {
      if (emptyBucket == false) {
        print(
            'Firestore_indexing: The analyse is over and ${bucket.length} indexedField were found, Here are the statistics:');
        print(
            '-> Total Number of field checked for index in the collection: ${tempData.documents.length} elements\n-> Total field indexed: ${bucket.length}\n-> To remove the indexed field run this method again and set the option "emptyBucket" to true');

        hasData = true;
        return hasData;
      } else {
        hasData = true;
        bucket.forEach((element) async {
          print(
              'Firestore_indexing: removing index in doxument with ID: $element');
          await Firestore.instance
              .collection(indexedInCollection)
              .document(element)
              .updateData({named + 'Key': FieldValue.delete()});
        });
      }
    } else if (bucket.isEmpty) {
      print(
          'FireStore_indexing: The analyse is over and the fiels $named is not indexed in the collection $indexedInCollection ');
      hasData = false;
      return hasData;
    }

    return hasData;
  }

  ///Use this in case you dont want to index a particular document
  static Future<bool> removeIndexInField(
      {@required String named,
      @required String inCollection,
      @required String withDocumentId,
      bool showLogs = false}) async {
    await Firestore.instance
        .collection(inCollection)
        .document(withDocumentId)
        .updateData({named + 'Key': FieldValue.delete()}).catchError((onError) {
      print('Firestore_indexing Error : ' + onError.toString());
      return false;
    });
    if (showLogs == true) {
      print(
          'Firestore_indexing: removed an index inside the document with ID $withDocumentId');
    }
    return true;
  }

  ///use this in case you want to index a particular document
  static Future<bool> addIndexInField(
      {@required String named,
      @required String inCollection,
      @required String withDocumentId,
      bool showLog = false}) async {
    DocumentSnapshot datax = await Firestore.instance
        .collection(inCollection)
        .document(withDocumentId)
        .get();
    await Firestore.instance
        .collection(inCollection)
        .document(withDocumentId)
        .updateData({
      named + 'Key': datax.data[named].toString().substring(0, 1).toUpperCase()
    }).catchError((onError) {
      print('Firestore_indexing Error : ' + onError.toString());
      return false;
    });
    if (showLog == true) {
      print(
          'Firestore_indexing: Added an index inside the document with ID $withDocumentId\n-> Field indexed is $named\n-> Element indexed is ${datax.data[named]}');
    }
    return true;
  }

  ///Use this  only when you need to remove an index from all your database's collection
  static Future<bool> removeAllIndex(
      {@required String inCollection,
      @required String indexedField,
      bool showLogs}) async {
    List<String> documentRef = [];
    String refKey = indexedField + 'Key';
    QuerySnapshot tempData = await Firestore.instance
        .collection(inCollection)
        .where(refKey)
        .getDocuments()
        .catchError((onError) {
      print('Firestore_indexing Error : ' + onError.toString());
      print(
          'Firestore_indexing Action_1: canceling the removal\nPossible reason: the field you requested does not exist/is not indexed or  an internet connection is not present ');
      return false;
    });
    //We just recheck for safety reason
    if (tempData.documents.isEmpty) {
      print(
          'Firestore_indexing Action_2: canceling the removal; Possible reasons are:\n-> The field you requested ($indexedField) does not exist or is not indexed\n-> The collection named $inCollection does not exist ( wrong spelling )\n-> An internet connection is not present ');
      return false;
    }
    //We just recheck for safety reason
    if (tempData.documents.isNotEmpty) {
      tempData.documents.forEach((element) {
        if (element.data[refKey] == null) {
          //We do not do anything
        } else {
          if (showLogs == true) {
            print(
                'Firestore_indexing Action_3: An indexed field is found, adding it to the removal queue');
          }
          //We get the reference of the indexed field documents
          documentRef.add(element.documentID);
        }
      });
    }
    //We are checking wether of not perform the transaction
    if (documentRef.isEmpty) {
      print(
          'Firestore_indexing: the field $indexedField is not indexed in the collection $inCollection. No action to be performed');
      return true;
    }

    try {
      //Running transaction is better to ensure that the datas will be sent in order
      await Firestore.instance.runTransaction((transaction) async {
        CollectionReference reference =
            Firestore.instance.collection(inCollection);

        for (int i = 0; i < documentRef.length; i++) {
          await transaction.update(
            reference.document(documentRef[i]),
            {indexedField + 'Key': FieldValue.delete()},
          ).catchError((onError) {
            print('Firestore_indexing Error : ' + onError.toString());
            print(
                'Firestore_indexing Action_4: canceling a removal already in process\nPossible reason: an internet connection is not present');
            print(
                'Firestore_indexing Comment: The removal process has been interupted at index $i');
            documentRef.clear();

            return false;
          });
          if (showLogs == true) {
            print(
                'Firestore_indexing: Successfully removed $indexedField from the indexer');
          }
        }
        documentRef.clear();
        if (showLogs == true) {
          print(
              'Firestore_indexing: All indexed field of $indexedField in the collection $inCollection removed sucessfully');
        }
        return true;
      });
    } catch (error) {
      // print(error.toString());
      //TODO: come here and complete this log
      print(
          'Firestore_indexing Alert: There has been an exception, your index has been removed sucessfully, However please try running the method ......');
    }
    return true;
  }

  ///Use this only when you need to index a field in all of your database's specific collection
  static Future<bool> indexDatabase(
      {@required String inCollection,
      @required String withFieldToIndex,
      bool showLogs = false}) async {
    //Contin temporary document reference ID
    List<String> documentRef = [];
    //Contains temporary indexes to be uploaded
    List<String> tempIndexes = [];
    QuerySnapshot tempData = await Firestore.instance
        .collection(inCollection)
        .where(withFieldToIndex)
        .getDocuments()
        .catchError((onError) {
      print('Firestore_indexing Error : ' + onError.toString());
      print(
          'Firestore_indexing Action_5: canceling the indexing\nPossible reason: an internet connection is not present');
      return false;
    });
    //Here we pass the reference of the document to a temporary list and we also create a List of index keys
    tempData.documents.forEach((element) {
      tempIndexes
          .add(element.data[withFieldToIndex].substring(0, 1).toUpperCase());
      documentRef.add(element.documentID);
    });
    //Running transaction is better to ensure that the datas will be sent in order
    await Firestore.instance.runTransaction((transaction) async {
      CollectionReference reference =
          Firestore.instance.collection(inCollection);
      for (int i = 0; i < documentRef.length; i++) {
        await transaction.update(reference.document(documentRef[i]),
            {withFieldToIndex + 'Key': tempIndexes[i]}).catchError((onError) {
          print('Firestore_indexing Error : ' + onError.toString());
          print(
              'Firestore_indexing Action_6: canceling an indexing already in process\nPossible reason: an internet connection is not present');
          print(
              'Firestore_indexing Comment: The indexing process has been interupted at document with ID ${documentRef[i]}');
          documentRef.clear();
          tempIndexes.clear();
          return false;
        });
        if (showLogs == true) {
          print('Firestore_indexing: Successfully indexed $withFieldToIndex');
        }
      }

      documentRef.clear();
      tempIndexes.clear();
      if (showLogs == true) {
        print(
            'Firestore_indexing: All fields named << $withFieldToIndex >> in the collection << $inCollection >> indexed sucessfully');
      }
    });
    return true;
  }

  ///This will create an indexed field use it when you need to add more data inside your database main document
  ///it is similar to
  /// ````
  ///Firestore.instance.collection(collectionName).add()
  ///````
  ///However this method will add the specified field to the Indexer
  static Future addInCollection(String named,
      {@required String fieldToIndex,
      @required String fieldToIndexContent,
      Map<String, dynamic> others,
      bool allowEmptyAndNullCollection = false,
      bool showLogs = false}) async {
    QuerySnapshot snap =
        await Firestore.instance.collection(named).limit(1).getDocuments();
    if (snap.documents.isEmpty) {
      if (allowEmptyAndNullCollection == false) {
        print(
          'Firestore_indexing Warning: The collection you are trying to access ($named) does not exist or is empty,\nBy default firestore will create a new collection and name it $named \n' +
              'However your operation has been stopped to prevent unwanted read/write in your database\nIf you wish to create the collection $named or are adding an item to a newly created collection, set the parameter << allowEmptyAndNullCollection >> to true\n',
        );
        return null;
      } else {
        print(
            'Firestore_indexing Waarning: The collection you are trying to access ($named) does not exist or is empty,\nFiretore will create a new collection and name it $named then add your data there');
      }
    }
    Map<String, dynamic> tempMap = {
      fieldToIndex: fieldToIndexContent,
      fieldToIndex + 'Key': fieldToIndexContent.substring(0, 1).toUpperCase()
    };
    tempMap.addAll(others);

    if (showLogs == true) {
      print('Firestore_indexing: Adding datas inside the collection $named');
    }
    await Firestore.instance
        .collection(named)
        .add(tempMap)
        .catchError((onError) {
      print('Firestore_indexing Error : $onError  ');
    }).then((value) {
      if (showLogs == true) {
        print(
            'Firestore_indexing:\nThe followin data/datas have been added to the collection $named and the field $fieldToIndex has been added to the indexer');
        tempMap.forEach((key, value) {
          if (key != fieldToIndex + 'Key') {
            print('$key : $value');
          }
        });
      }
    });
  }

  ///This will create an Index for a spacific field, to use when manually creating indexes
  static String createIndex(String forFeald) {
    return forFeald + 'Key';
  }

  ///This will create an Index for a spacific field, to use when manually creating indexes
  static String content(String ofFieldToIndex) {
    return ofFieldToIndex.substring(0, 1).toUpperCase();
  }
}

//=======================================================================================
//=======================================================================================
//HIDDEN classes

///Use this for starting the search engine
class _SearchService {
  searchFirestore(
      //TODO: come here and fix the log
      {@required String inCollection,
      @required String whithKeyNamed,
      @required String searchKey,
      bool showLog = false}) {
    if (showLog) {
      print('getting the list');
      print(whithKeyNamed);
    }
    return Firestore.instance
        .collection(inCollection)
        .where(searchKey,
            isEqualTo: whithKeyNamed.substring(0, 1).toUpperCase())
        .getDocuments();
  }
}

///That is the screen that will handle the search
class _FirestoreSearchScreen extends StatefulWidget {
  final String inCollection;
  final String indexedField;

  final SearchController searchController;
  const _FirestoreSearchScreen(
      {Key key,
      @required this.inCollection,
      @required this.indexedField,
      @required this.searchController})
      : super(key: key);
  @override
  _FirestoreSearchScreenState createState() => _FirestoreSearchScreenState();
}

class _FirestoreSearchScreenState extends State<_FirestoreSearchScreen> {
  
  @override
  void initState() {
    super.initState();
   
  }

  var queryResultSet = [];
  var tempSearchStore = [];
  var tempSearchStoreDelegate = [];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: widget.searchController.searchPageBackgroundDecoration ??
          BoxDecoration(color: Colors.white),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Material(
            color: Colors.transparent,
            child: SafeArea(
              top: true,
              child: Padding(
                padding: widget
                        .searchController.textFieldOuterContainerPadding ??
                    EdgeInsets.only(
                        top: 8.0,
                        left: (MediaQuery.of(context).size.width / 100) * 10,
                        right: (MediaQuery.of(context).size.width / 100) * 10),
                child: Container(
                  height: widget.searchController.textFieldOuterContainerHeight,
                  width: widget.searchController.textFieldOuterContainerWidth,
                  decoration: widget
                          .searchController.textFieldOuterContainerDecoration ??
                      BoxDecoration(),
                  child: Center(
                    child: TextField(
                      style: widget.searchController.textFieldTextStyle ??
                          TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                      textAlign:
                          widget.searchController.textAlign ?? TextAlign.center,
                      cursorColor:
                          widget.searchController.cursorColor ?? Colors.black,
                      autofocus: widget.searchController.autofocus ?? true,
                      autocorrect: widget.searchController.autoCorrect ?? false,
                      decoration: widget.searchController.inputDecoration ??
                          InputDecoration(
                            hintText:
                                widget.searchController.textFieldHintText ??
                                    'Search within ${widget.inCollection}',
                            hintStyle: TextStyle(
                                color: Colors.black26,
                                fontWeight: FontWeight.bold),
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.black38)),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.black12)),
                          ),
                      onChanged: (value) {
                        widget.searchController.texFieldValue = value;
                        initiateSearch(value);
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
          ListView.builder(
            reverse: true,
            itemCount: widget.searchController.searchResult.length,
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {
              widget.searchController.internalIndex = index;
              
              return Padding(
                  key: Key((32 + Random().nextInt(43827576)).toString() + 'hr'),
                  padding: const EdgeInsets.all(8.0),
                  child: widget.searchController.custonResultWidget ??
                      Material(
                          color: Colors.transparent,
                          elevation: 0,
                          shadowColor: Colors.transparent,
                          child: Card(
                            elevation: 2,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ListTile(
                                title: Text(
                                    'data found but cannot be displayed by the default widget, please use searchController.ResultWidget to build your search result, do refer the example folder for more information'),
                              ),
                            ),
                          )));
            },
          )
        ],
      ),
    );
  }

  initiateSearch(value) {
    if (value.length == 0) {
      setState(() {
        queryResultSet = [];
        tempSearchStore = [];
        widget.searchController.searchResult.clear();
      });
    }
    //This is to run the query only once and not bombard fire base lol
    if (queryResultSet.length == 0 && value.length == 1) {
      _SearchService()
          .searchFirestore(
              inCollection: widget.inCollection,
              whithKeyNamed: value,
              searchKey: widget.indexedField + 'Key')
          .then((QuerySnapshot documentSnapshot) {
        for (int i = 0; i < documentSnapshot.documents.length; i++) {
          queryResultSet.add(documentSnapshot.documents[i].data);

          setState(() {
            tempSearchStore.add(queryResultSet[i]);
            widget.searchController.searchResult.add(queryResultSet[i]);
          });
          //print(documentSnapshot.documents[i]['name']);
        }
      });
    } else {
      tempSearchStore = [];
      widget.searchController.searchResult.clear();
     
      queryResultSet.forEach(
        (element) {
          if (element[widget.indexedField]
                  .toLowerCase()
                  .contains(value.toLowerCase()) ==
              true) {
            if (element[widget.indexedField]
                    .toLowerCase()
                    .indexOf(value.toLowerCase()) ==
                0) {
              setState(() {
                tempSearchStore.add(element);
                widget.searchController.searchResult.add(element);
              });
            }
          }
        },
      );
    }
    if (widget.searchController.searchResult.length == 0 && value.length > 1) {
      setState(() {});
    }
  }
}

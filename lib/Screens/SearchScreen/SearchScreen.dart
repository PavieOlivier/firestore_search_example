import 'package:firestore_search_example/Logic/SearchService.dart';
import 'package:firestore_search_example/MainHelper/sizeConfig.dart';
import 'package:firestore_search_example/Screens/DetailScreen/DetailsScreen.dart';
import 'package:firestore_search_example/Screens/DetailScreen/Helper/animeCardElement.dart';
import 'package:firestore_search_example/Screens/HomeScreen/Helper/CustomGrid.dart';
import 'package:firestore_search_example/Screens/SearchScreen/Helper/SearchHeader.dart';


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class SearchScreen extends StatefulWidget {
  final String inCollection;
  final String indexedField;
  final bool isWithinCategory;

  const SearchScreen(
      {Key key,
      @required this.inCollection,
      @required this.isWithinCategory,
      @required this.indexedField})
      : super(key: key);
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController textEditingController;
  @override
  void initState() {
    super.initState();
    textEditingController = TextEditingController();
  }

  var queryResultSet = [];
  var tempSearchStore = [];
  var tempSearchStoreDelegate = [];
  //since we are starting with name categ
  String subSearchKey = 'NameSearchKey';
  String specialIndexedField = 'name';

  @override
  Widget build(BuildContext context) {
    return Container(
      width: SizeConfig.screenWidth,
      height: SizeConfig.screenHeight,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue[300], Colors.blueAccent],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Material(
            color: Colors.transparent,
            child: SafeArea(
              top: true,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: textEditingController,
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                  cursorColor: Colors.white,
                  autofocus: true,
                  autocorrect: false,
                  decoration: InputDecoration(
                    hintText: 'Search within ${widget.inCollection}',
                    hintStyle: TextStyle(
                        color: Colors.white60, fontWeight: FontWeight.bold),
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                  ),
                  onChanged: (value) {
                    initiateSearch(value);
                  },
                ),
              ),
            ),
          ),
          widget.isWithinCategory
              ? SizedBox()
              : SearchHeader(
                  onHeaderChanged: (newIndexedFile, _subSearchKey) {
                    subSearchKey = _subSearchKey;
                    specialIndexedField = newIndexedFile;
                    textEditingController.clear();

                    initiateSearch('');
                    setState(() {});
                  },
                ),
          widget.isWithinCategory
              ? ListView.builder(
                  itemCount: tempSearchStore.length,
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CategoryGridObject(
                        isFromSearch: true,
                          onTap: () {
                            Navigator.pushReplacement(
                                context,
                                PageTransition(
                                    type: PageTransitionType.fade,
                                    child: DetailScreen(
                                      ofCategory: tempSearchStore[index]
                                          [widget.indexedField],
                                    )));
                          },
                          categoryName: tempSearchStore[index]
                              [widget.indexedField]),
                    );
                  },
                )
              : ListView.builder(
                  itemCount: tempSearchStore.length,
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                        padding: const EdgeInsets.all(8.0),
                        //TODO: come and complete the card distribution here once the data is received
                        child: AnimeCardElement(
                          name: tempSearchStore[index]['name'],
                          
                        ));
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
      });
    }

    //This is to run the query only once and not bombard fire base lol
    if (queryResultSet.length == 0 && value.length == 1) {
      SearchService()
          .searchByName(
              inCollection: widget.inCollection,
              whithKeyNamed: value,
              searchKey: widget.isWithinCategory ? 'searchKey' : subSearchKey)
          .then((QuerySnapshot documentSnapshot) {
        for (int i = 0; i < documentSnapshot.documents.length; i++) {
          queryResultSet.add(documentSnapshot.documents[i].data);
          setState(() {
            tempSearchStore.add(queryResultSet[i]);
          });
          //print(documentSnapshot.documents[i]['name']);
        }
      });
    } else {
      tempSearchStore = [];
      queryResultSet.forEach((element) {
        if (widget.isWithinCategory == true) {
          if (element[widget.indexedField].toLowerCase().contains(value.toLowerCase()) ==  true) {
            if (element[widget.indexedField].toLowerCase().indexOf(value.toLowerCase()) == 0) {
              setState(() {
                tempSearchStore.add(element);
              });
            }
          }
        } else if (specialIndexedField == 'name') {
          print('we are here');
          if (element[specialIndexedField]
                  .toLowerCase()
                  .contains(value.toLowerCase()) ==
              true) {
            if (element[specialIndexedField]
                    .toLowerCase()
                    .indexOf(value.toLowerCase()) ==
                0) {
              setState(() {
                tempSearchStore.add(element);
              });
            }
          }
        } else if (specialIndexedField == 'part number') {
          if (element[specialIndexedField]
                  .toLowerCase()
                  .contains(value.toLowerCase()) ==
              true) {
            if (element[specialIndexedField]
                    .toLowerCase()
                    .indexOf(value.toLowerCase()) ==
                0) {
              setState(() {
                tempSearchStore.add(element);
              });
            }
          }
        } else if (specialIndexedField == 'gadi') {
          if (element[specialIndexedField]
                  .toLowerCase()
                  .contains(value.toLowerCase()) ==
              true) {
            if (element[specialIndexedField]
                    .toLowerCase()
                    .indexOf(value.toLowerCase()) ==
                0) {
              setState(() {
                tempSearchStore.add(element);
              });
            }
          }
        }
      });
    }
    if (tempSearchStore.length == 0 && value.length > 1) {
      setState(() {});
    }
  }
}

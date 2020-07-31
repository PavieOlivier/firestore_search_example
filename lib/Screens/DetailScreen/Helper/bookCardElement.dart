import 'package:cached_network_image/cached_network_image.dart';
import 'package:firestore_search_example/Fork/CustomExpansionTile.dart';
import 'package:firestore_search_example/Fork/WidgetAnimator.dart';
import 'package:firestore_search_example/MainHelper/sizeConfig.dart';
import 'package:flutter/material.dart';

import 'animeCardElement.dart';

class BookCardElement extends StatefulWidget {
  final String name;
  final List<dynamic> authors;
  final List<dynamic> category;
  final String imageUrl;
  final String pageCount;
  final String description;

  const BookCardElement({
    Key key,
    @required this.name,

    @required this.category,
 
    @required this.imageUrl,
 
    @required this.description, @required this.authors, @required this.pageCount,
  }) : super(key: key);

  @override
  _BookCardElementState createState() => _BookCardElementState();
}

class _BookCardElementState extends State<BookCardElement> {
  String category = '' , authors= '';
  @override
  void initState() {
    super.initState();
    widget.authors.forEach((authorsX) {
      authors = authors+ authorsX + ', ';
     });
     widget.category.forEach((catX) {
      category = category + catX+'| ';
     });
  }

  @override
  Widget build(BuildContext context) {
    return WidgetAnimator(
      
          child: Card(
        color: Colors.transparent,
        elevation: 0.03,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: CustomExpansionTile(
            backgroundColor: Colors.transparent,
            detectTouchOnExpandedTile: true,
            trailing: SizedBox(),
            title: Container(
              //height: SizeConfig.safeBlockVertical * 25.5,
              child: Stack(
                children: <Widget>[
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          height: SizeConfig.safeBlockVertical * 22,
                          width: SizeConfig.safeBlockHorizontal * 35,
                          decoration: BoxDecoration(
                            //color: Colors.red,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: CachedNetworkImage(
              imageUrl: widget.imageUrl,
              imageBuilder: (context, imageProvider) => Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
                ),
              ),
              placeholder: (context, url) => Padding(
                padding: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 14),
                child: CircularProgressIndicator(),
              ),
              errorWidget: (context, url, error) => Padding(
                  padding:
                      EdgeInsets.only(top: SizeConfig.safeBlockVertical * 25),
                  child: Icon(
                    Icons.warning,
                    color: Colors.red,
                    size: SizeConfig.safeBlockHorizontal * 9,
                  )),
            ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              left: SizeConfig.safeBlockHorizontal * 2,
                              top: SizeConfig.safeBlockVertical * 1),
                          child: Container(
                            //height: SizeConfig.safeBlockVertical * 22,
                            width: SizeConfig.safeBlockHorizontal * 49,
                            //color: Colors.white,
                            child: Column(
                              
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                SubCardElement(
                                  title: 'Title:',
                                  value: ' ${widget.name}',
                                ),
                                SubCardElement(
                                  title: 'Pages',
                                  value: ' ${widget.pageCount}',
                                ),
                               
                                SubCardElement(
                                  title: 'Category:',
                                  value: ' $category',
                                ),
                                SubCardElement(
                                  title: 'Authors:',
                                  value: '$authors',
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            children: <Widget>[
              Divider(
                endIndent: 20,
                indent: 20,
              ),
              Padding(
                padding: EdgeInsets.only(
                    left: SizeConfig.safeBlockHorizontal * 3.5,
                    right: SizeConfig.safeBlockHorizontal * 3.5,
                    bottom: SizeConfig.safeBlockHorizontal * 3.5),
                child: Text(
                  widget.description,
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                      color: Colors.white70,
                      fontWeight: FontWeight.w500,
                      fontSize: SizeConfig.safeBlockHorizontal * 3.5),
                ),
              )
            ]),
      ),
    );
  }
}


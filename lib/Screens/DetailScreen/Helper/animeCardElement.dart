import 'package:cached_network_image/cached_network_image.dart';
import 'package:firestore_search_example/Fork/CustomExpansionTile.dart';
import 'package:firestore_search_example/MainHelper/sizeConfig.dart';
import 'package:flutter/material.dart';

class AnimeCardElement extends StatefulWidget {
  final String name;
  final String studio;
  final String category;
  final String episodes;
  final String imageUrl;
  final String rating;
  final String description;

  const AnimeCardElement({
    Key key,
    @required this.name,
    @required this.studio,
    @required this.category,
    @required this.episodes,
    @required this.imageUrl,
    @required this.rating,
    @required this.description,
  }) : super(key: key);

  @override
  _AnimeCardElementState createState() => _AnimeCardElementState();
}

class _AnimeCardElementState extends State<AnimeCardElement> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.transparent,
      elevation: 0.03,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: CustomExpansionTile(
          backgroundColor: Colors.transparent,
          detectTouchOnExpandedTile: true,
          trailing: SizedBox(),
          title: Container(
            height: SizeConfig.safeBlockVertical * 25.5,
            child: Stack(
              children: <Widget>[
                Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
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
                            top: SizeConfig.safeBlockVertical * 3),
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
                                title: 'Rating:',
                                value: ' ${widget.rating}',
                              ),
                              SubCardElement(
                                title: 'Studio:',
                                value: ' ${widget.studio}',
                              ),
                              SubCardElement(
                                title: 'Episode:',
                                value: ' ${widget.episodes}',
                              ),
                              SubCardElement(
                                title: 'Category:',
                                value: ' ${widget.category}',
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
    );
  }
}

class SubCardElement extends StatelessWidget {
  final String title, value;
  final Color titleColor, valueColor;
  const SubCardElement({
    Key key,
    @required this.title,
    @required this.value,
    this.titleColor = Colors.white,
    this.valueColor = Colors.white70,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: RichText(
          text: TextSpan(
              text: title,
              style: TextStyle(
                color: titleColor,
                fontWeight: FontWeight.w900,
                fontSize: SizeConfig.safeBlockHorizontal * 5,
              ),
              children: [
            TextSpan(
                text: value,
                style: TextStyle(
                    color: valueColor,
                    decoration: TextDecoration.none,
                    fontWeight: FontWeight.w500))
          ])),
    );
  }
}

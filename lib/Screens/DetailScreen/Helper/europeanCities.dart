import 'package:cached_network_image/cached_network_image.dart';
import 'package:firestore_search_example/Fork/CustomExpansionTile.dart';
import 'package:firestore_search_example/Fork/WidgetAnimator.dart';
import 'package:firestore_search_example/MainHelper/sizeConfig.dart';
import 'package:flutter/material.dart';
import 'package:sliding_card/sliding_card.dart';

class EuropeanCardElement extends StatefulWidget {
  final String cityName;
  final String countryName;
  final String imageUrl;
  final String description;

  const EuropeanCardElement({
    Key key,
    @required this.imageUrl,
    @required this.description,
    @required this.cityName,
    @required this.countryName,
  }) : super(key: key);

  @override
  _EuropeanCardElementState createState() => _EuropeanCardElementState();
}

class _EuropeanCardElementState extends State<EuropeanCardElement> {
  String category = '', authors = '';
  SlidingCardController slidingCardController;
  @override
  void initState() {
    super.initState();
    slidingCardController = SlidingCardController();
  }

  @override
  Widget build(BuildContext context) {
    return WidgetAnimator(
      animateFromTop: true,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: SlidingCard(
              controller: slidingCardController,
              showColors: false,
              slimeCardElevation: 0,
              slidingCardWidth: SizeConfig.horizontalBloc * 95,
              visibleCardHeight: SizeConfig.safeBlockVertical * 27,
              backCardWidget: Stack(
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.black12,
                        borderRadius: BorderRadius.circular(25)),
                    //I am repeating code .. i actually dont mind here becaue it is just a showoff app
                    child: CachedNetworkImage(
                      imageUrl: widget.imageUrl,
                      imageBuilder: (context, imageProvider) => Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          image: DecorationImage(
                              image: imageProvider, fit: BoxFit.cover),
                        ),
                      ),
                      placeholder: (context, url) => Padding(
                        padding: EdgeInsets.only(
                            top: SizeConfig.safeBlockVertical * 14),
                        child: CircularProgressIndicator(),
                      ),
                      errorWidget: (context, url, error) => Padding(
                          padding: EdgeInsets.only(
                              top: SizeConfig.safeBlockVertical * 25),
                          child: Icon(
                            Icons.warning,
                            color: Colors.red,
                            size: SizeConfig.safeBlockHorizontal * 9,
                          )),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(25))
                  )
                ],
              ),
              frontCardWidget: Stack(
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                        //color: Colors.yellow,
                        borderRadius: BorderRadius.circular(25)),
                    width: SizeConfig.horizontalBloc * 95,
                    height: SizeConfig.safeBlockVertical * 27,
                    child: CachedNetworkImage(
                      imageUrl: widget.imageUrl,
                      imageBuilder: (context, imageProvider) => Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          image: DecorationImage(
                              image: imageProvider, fit: BoxFit.cover),
                        ),
                      ),
                      placeholder: (context, url) => Padding(
                        padding: EdgeInsets.only(
                            top: SizeConfig.safeBlockVertical * 14),
                        child: CircularProgressIndicator(),
                      ),
                      errorWidget: (context, url, error) => Padding(
                          padding: EdgeInsets.only(
                              top: SizeConfig.safeBlockVertical * 25),
                          child: Icon(
                            Icons.warning,
                            color: Colors.red,
                            size: SizeConfig.safeBlockHorizontal * 9,
                          )),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: GestureDetector(
                      onTap: () {
                        slidingCardController.isCardSeparated
                            ? slidingCardController.collapseCard()
                            : slidingCardController.expandCard();
                      },
                      child: Container(
                        width: SizeConfig.horizontalBloc * 95,
                        height: SizeConfig.safeBlockVertical * 27,
                        decoration: BoxDecoration(
                            color: Colors.black12,
                            borderRadius: BorderRadius.circular(20)),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: SizeConfig.safeBlockHorizontal * 4,
                          bottom: SizeConfig.safeBlockVertical * 3.7),
                      child: Text(
                        '${widget.cityName}, ${widget.countryName} ',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: SizeConfig.safeBlockHorizontal * 6),
                      ),
                    ),
                  ),
                ],
              )),
        ),
      ),
    );
  }
}

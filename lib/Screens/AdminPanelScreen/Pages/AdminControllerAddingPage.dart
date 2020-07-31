import 'package:firestore_search_example/MainHelper/sizeConfig.dart';
import 'package:firestore_search_example/Screens/AdminPanelScreen/Helper/AdminDropDownMenu.dart';
import 'package:firestore_search_example/Screens/AdminPanelScreen/Helper/AdminInputField.dart';
import 'package:firestore_search_example/Screens/AdminPanelScreen/Helper/AdminPannelActionButton.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:edge_alert/edge_alert.dart';
import 'package:flutter/material.dart';

class AdminControllerAddingPage extends StatefulWidget {
  final bool isCreatingCat;
  final String mainTitle, subTitle;
  const AdminControllerAddingPage(
      {Key key,
      @required this.isCreatingCat,
      @required this.mainTitle,
      @required this.subTitle})
      : super(key: key);

  @override
  _AdminControllerAddingPageState createState() =>
      _AdminControllerAddingPageState();
}

class _AdminControllerAddingPageState extends State<AdminControllerAddingPage> {
  bool useExtraSpace = true;
  ScrollController scrollController;
  AdminPannelActionButtonController buttonController;
  String selectedCategoryName = '';
  TextEditingController categoryNameTextEditingController;
  TextEditingController nameTextEditingController;
  TextEditingController mrpTextEditingController;
  TextEditingController gadiTextEditingController;
  TextEditingController partNoTextEditingController;
  TextEditingController locationTextEditingController;
  TextEditingController inchTextEditingController;
  TextEditingController holeTextEditingController;
  TextEditingController sizeTextEditingController;
  TextEditingController crossTextEditingController;
  TextEditingController teethTextEditingController;
  TextEditingController boltSizeTextEditingController;
  TextEditingController sizeInchTextEditingController;

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
    buttonController = AdminPannelActionButtonController();
    categoryNameTextEditingController = TextEditingController();
    nameTextEditingController = TextEditingController();
    mrpTextEditingController = TextEditingController();
    gadiTextEditingController = TextEditingController();
    partNoTextEditingController = TextEditingController();
    locationTextEditingController = TextEditingController();
    inchTextEditingController = TextEditingController();
    holeTextEditingController = TextEditingController();
    sizeTextEditingController = TextEditingController();
    crossTextEditingController = TextEditingController();
    teethTextEditingController = TextEditingController();
    boltSizeTextEditingController = TextEditingController();
    sizeInchTextEditingController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
        colors: [Colors.blue[300], Colors.blueAccent],
        begin: Alignment.bottomLeft,
        end: Alignment.topRight,
      )),
      child: Container(
        width: SizeConfig.screenWidth,
        height: SizeConfig.screenHeight,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SafeArea(
                  child: Container(
                width: SizeConfig.safeBlockHorizontal * 95,
                height: SizeConfig.safeBlockVertical * 15,
                // color: Colors.pink,
                child: Center(
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                        text: widget.mainTitle,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: SizeConfig.safeBlockHorizontal * 6),
                        children: [
                          TextSpan(
                              text: widget.subTitle,
                              style: TextStyle(
                                  fontSize: SizeConfig.safeBlockHorizontal * 4))
                        ]),
                  ),
                ),
              )),
              Container(
                height: SizeConfig.safeBlockVertical * 84,
                child: SingleChildScrollView(
                  controller: scrollController,
                  physics: BouncingScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  child: Column(
                    children: <Widget>[
                      widget.isCreatingCat
                          ? AdminInputField(
                              enableText: useExtraSpace,
                              textEditingController:
                                  categoryNameTextEditingController,
                              label: 'Category Name',
                            )
                          : AdminDropDownMenu(
                              onItemSelected: (itemName) {
                                selectedCategoryName = itemName;
                                print(selectedCategoryName);
                              },
                            ),
                      AdminInputField(
                        enableText: useExtraSpace,
                        textEditingController: nameTextEditingController,
                        label: 'Name',
                      ),
                      AdminInputField(
                        enableText: useExtraSpace,
                        textEditingController: mrpTextEditingController,
                        label: 'MRP',
                      ),
                      AdminInputField(
                        enableText: useExtraSpace,
                        textEditingController: gadiTextEditingController,
                        label: 'Gadi',
                      ),
                      AdminInputField(
                        enableText: useExtraSpace,
                        textEditingController: partNoTextEditingController,
                        label: 'Part No',
                      ),
                      AdminInputField(
                        enableText: useExtraSpace,
                        textEditingController: locationTextEditingController,
                        label: 'Location',
                      ),
                      AdminInputField(
                        enableText: useExtraSpace,
                        textEditingController: inchTextEditingController,
                        keyboardType: TextInputType.number,
                        label: 'Inch',
                      ),
                      AdminInputField(
                        enableText: useExtraSpace,
                        textEditingController: holeTextEditingController,
                        label: 'Hole',
                      ),
                      AdminInputField(
                        enableText: useExtraSpace,
                        textEditingController: sizeTextEditingController,
                        keyboardType: TextInputType.number,
                        label: 'Size',
                      ),
                      AdminInputField(
                        enableText: useExtraSpace,
                        textEditingController: crossTextEditingController,
                        label: 'Cross',
                      ),
                      AdminInputField(
                        enableText: useExtraSpace,
                        textEditingController: teethTextEditingController,
                        label: 'Teeth',
                      ),
                      AdminInputField(
                        enableText: useExtraSpace,
                        textEditingController: boltSizeTextEditingController,
                        keyboardType: TextInputType.number,
                        label: 'Bolt Size',
                      ),
                      AdminInputField(
                        enableText: useExtraSpace,
                        textEditingController: sizeInchTextEditingController,
                        keyboardType: TextInputType.number,
                        label: 'Size inch',
                      ),
                      Padding(
                        padding:
                            EdgeInsets.all(SizeConfig.safeBlockHorizontal * 3),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: AdminPannelActionButton(
                                onTap: () async {
                                  
                                  Navigator.of(context).pop();
                                },
                                textColor: Colors.red,
                                title: 'Cancel',
                              ),
                            ),
                            Expanded(
                              child: AdminPannelActionButton(
                                controller: buttonController,
                                onTap: () async {
                                  FocusScope.of(context).unfocus();
                                  setState(() {
                                    useExtraSpace = false;
                                  });
                                  await verifyFields()
                                      .then((areFieldAcceptable) async {
                                    if (areFieldAcceptable == false) {
                                      print('we got $areFieldAcceptable');
                                      setState(() {
                                        useExtraSpace = true;
                                      });
                                    } else {
                                      buttonController.animateWaitON();
                                      await DataConnectionChecker()
                                          .hasConnection
                                          .then(
                                        (hasConnection) async {
                                          if (hasConnection == true) {
                                            ///TODO : IMPORTANT !!!!! REMOVE THIS 
                                            //await addElementToFireStore();
                                            buttonController.animateWaitOFF();

                                            setState(() {
                                              useExtraSpace = true;
                                            });
                                            scrollController.animateTo(0,
                                                duration:
                                                    Duration(milliseconds: 500),
                                                curve: Curves.linear);
                                            EdgeAlert.show(context,
                                                title: 'Done',
                                                description: 'Data uploaded',
                                                gravity: EdgeAlert.BOTTOM,
                                                duration: 2,
                                                backgroundColor:
                                                    Colors.green[300]);
                                          } else {
                                            EdgeAlert.show(context,
                                                title: 'Can\'t Connect',
                                                description:
                                                    'Need internet to publish',
                                                gravity: EdgeAlert.BOTTOM,
                                                duration: 2,
                                                backgroundColor:
                                                    Colors.blue[300]);
                                          }
                                        },
                                      );
                                    }
                                  });
                                },
                                textColor: Colors.green[300],
                                title: 'Confirm',
                              ),
                            ),
                          ],
                        ),
                      ),
                      useExtraSpace
                          ? SizedBox(
                              height: SizeConfig.safeBlockVertical * 45,
                            )
                          : SizedBox()
                      // SizedBox(height:SizeConfig.safeBlockVertical*20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> addElementToFireStore() async {
    if (widget.isCreatingCat == true) {
      await Firestore.instance.collection('categories').add({
        'name': categoryNameTextEditingController.text
                .substring(0, 1)
                .toUpperCase() +
            categoryNameTextEditingController.text.substring(1),
        'searchKey':
            categoryNameTextEditingController.text.substring(0, 1).toUpperCase()
      });
    }
    await Firestore.instance
        .collection(widget.isCreatingCat
            ? categoryNameTextEditingController.text
                    .substring(0, 1)
                    .toUpperCase() +
                categoryNameTextEditingController.text.substring(1)
            : selectedCategoryName)
        .add({
      'name': nameTextEditingController.text.substring(0, 1).toUpperCase() +
          nameTextEditingController.text.substring(1),
      'NameSearchKey':
          nameTextEditingController.text.substring(0, 1).toUpperCase(),
      'gadi': gadiTextEditingController.text.substring(0, 1).toUpperCase() +
          gadiTextEditingController.text.substring(1),
      'GadiSearchKey':
          gadiTextEditingController.text.substring(0, 1).toUpperCase(),
      'part number':
          partNoTextEditingController.text.substring(0, 1).toUpperCase() +
              partNoTextEditingController.text.substring(1),
      'PartNumberSearchKey':
          partNoTextEditingController.text.substring(0, 1).toUpperCase(),

      /// less important
      'mrp': mrpTextEditingController.text,
      'location': locationTextEditingController.text,
      'inch': inchTextEditingController.text,
      'hole': holeTextEditingController.text,
      'size': sizeTextEditingController.text,
      'cross': crossTextEditingController.text,
      'teeth': teethTextEditingController.text,
      'bolt size': boltSizeTextEditingController.text,
      'size inch': sizeInchTextEditingController.text,
    }).then((docReference) {
      clearFields();
    }).catchError((onError) {
      print('error');
      print(onError.toString());
    }).timeout(Duration(seconds: 15), onTimeout: () {
      buttonController.animateWaitOFF();
      EdgeAlert.show(context,
          title: 'Not properly updated',
          description: 'there was a time out, please try again later',
          gravity: EdgeAlert.BOTTOM,
          duration: 2,
          backgroundColor: Colors.orange);
    });

    print('Done');
  }

  void clearFields() {
    categoryNameTextEditingController.clear();
    nameTextEditingController.clear();
    mrpTextEditingController.clear();
    gadiTextEditingController.clear();
    partNoTextEditingController.clear();
    locationTextEditingController.clear();
    inchTextEditingController.clear();
    holeTextEditingController.clear();
    sizeTextEditingController.clear();
    crossTextEditingController.clear();
    teethTextEditingController.clear();
    boltSizeTextEditingController.clear();
    sizeInchTextEditingController.clear();
  }

  Future<bool> verifyFields() async {
    if (widget.isCreatingCat == true) {
      if (categoryNameTextEditingController.text.isEmpty == true) {
        EdgeAlert.show(context,
        icon: Icons.warning,
            title: 'can\'t upload',
            description: 'Category name cannot be empty',
            gravity: EdgeAlert.BOTTOM,
            duration: 2,
            backgroundColor: Colors.orange);
        return false;
      }
    }
    if (nameTextEditingController.text.isEmpty == true) {
      EdgeAlert.show(context,
      icon: Icons.warning,
          title: 'can\'t upload',
          description: 'name field cannot be empty',
          gravity: EdgeAlert.BOTTOM,
          duration: 2,
          backgroundColor: Colors.orange);
      return false;
    }
    if (partNoTextEditingController.text.isEmpty == true) {
      EdgeAlert.show(context,
      icon: Icons.warning,
          title: 'can\'t upload',
          description: ' part number cannot be empty',
          gravity: EdgeAlert.BOTTOM,
          duration: 2,
          backgroundColor: Colors.orange);
      return false;
    }
    if (gadiTextEditingController.text.isEmpty == true) {
      EdgeAlert.show(context,
      icon: Icons.warning,
          title: 'can\'t upload',
          description: 'Gadi cannot be empty',
          gravity: EdgeAlert.BOTTOM,
          duration: 2,
          backgroundColor: Colors.orange);
      return false;
    }

    return true;
  }
}

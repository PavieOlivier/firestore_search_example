import 'dart:async';

import 'package:battery/battery.dart';
import 'package:firestore_search_example/MainHelper/sizeConfig.dart';
import 'package:connectivity/connectivity.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/material.dart';

class DeviceInfo extends StatefulWidget {
  const DeviceInfo({
    Key key,
  }) : super(key: key);

  @override
  _DeviceInfoState createState() => _DeviceInfoState();
}

class _DeviceInfoState extends State<DeviceInfo> {
  int batLevel = 0;
  bool batListener = true;
  IconData internetIcon;
  Color internetConnectionColor;
  Timer timer;
  DateTime _dateTime;
  bool isTImeLoaded;

  @override
  void initState() {
    super.initState();
    isTImeLoaded = false;
    internetIcon = Icons.perm_scan_wifi;
    internetConnectionColor = Colors.red;
    getBat();
    startConnectionChecker();
    timer = Timer.periodic(Duration(seconds: 1), setTime);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          left: SizeConfig.safeBlockHorizontal * 4,
          right: SizeConfig.safeBlockHorizontal * 4),
      child: Stack(
        children: <Widget>[
          Positioned(
            right: 0,
            bottom: 0,
            top: 0,
            child: Container(
              width: SizeConfig.safeBlockHorizontal * 70,
              // color: Colors.yellow,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Expanded(
                      flex: 3,
                      child: StreamBuilder<DataConnectionStatus>(
                          stream: DataConnectionChecker().onStatusChange,
                          builder: (context, snapshot) {
                            if (snapshot.data ==
                                DataConnectionStatus.connected) {
                              internetConnectionColor = Colors.lightGreen;
                            }
                            if (snapshot.data ==
                                DataConnectionStatus.disconnected) {
                              internetConnectionColor = Colors.redAccent;
                            }
                            return Icon(
                              internetIcon,
                              color: internetConnectionColor,
                            );
                          })),
                  Expanded(
                    flex: 3,
                    child: Text(
                      '$batLevel%',
                      style: TextStyle(
                          fontSize: SizeConfig.safeBlockHorizontal * 6,
                          color: Colors.white,
                          decoration: TextDecoration.none),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Text(
                      isTImeLoaded
                          ? '${_dateTime.hour}:${_dateTime.minute}'
                          : '',
                      style: TextStyle(
                          fontSize: SizeConfig.safeBlockHorizontal * 7,
                          color: Colors.white,
                          decoration: TextDecoration.none),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      'Dima Motor Stock List',
                      style: TextStyle(
                          fontSize: SizeConfig.safeBlockHorizontal * 3,
                          color: Colors.white,
                          decoration: TextDecoration.none),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Future startBatteryBroadCast() async {
    while (batListener == true) {
      await Battery().batteryLevel.then((batteryValue) {
        if (batteryValue != batLevel) {
          batLevel = batteryValue;
          setState(() {});
        }
      });

      await Future.delayed(Duration(seconds: 10));
    }
  }

  void getBat() async {
    batLevel = await Battery().batteryLevel;

    setState(() {});
    startBatteryBroadCast();
  }

  void setTime(Timer time) {
    if (mounted) _dateTime = DateTime.now();
    setState(() {
      isTImeLoaded = true;
    });
  }

  Future startConnectionChecker() async {
    Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) async {
      if (result == ConnectivityResult.mobile) {
        await DataConnectionChecker().hasConnection.then((isInternetconnected) {
          if (isInternetconnected == true) {
            internetIcon = Icons.network_cell;
            internetConnectionColor = Colors.green;
            if (mounted) setState(() {});
          } else {
            internetIcon = Icons.network_locked;
            internetConnectionColor = Colors.red;
            if (mounted) setState(() {});
          }
        });
      } else if (result == ConnectivityResult.wifi) {
        await DataConnectionChecker().hasConnection.then((isInternetconnected) {
          if (isInternetconnected == true) {
            internetIcon = Icons.wifi;
            internetConnectionColor = Colors.green;
            if (mounted) setState(() {});
          } else {
            internetIcon = Icons.wifi_lock;
            internetConnectionColor = Colors.red;
            if (mounted) setState(() {});
          }
        });
      } else if (result == ConnectivityResult.none) {
        if (mounted)
          setState(() {
            internetIcon = Icons.signal_wifi_off;
            internetConnectionColor = Colors.red;
          });
      }
    });
  }
}

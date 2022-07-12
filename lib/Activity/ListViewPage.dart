import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_app/HelperClass/DbHelper.dart';
import 'package:flutter_app/HelperClass/SharedPrefUtils.dart';
import 'package:flutter_app/ModelClass/employee.dart';
import 'package:full_screen_image/full_screen_image.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SecondView extends StatefulWidget {
  @override
  SecondViewState createState() => SecondViewState();
}

class SecondViewState extends State<SecondView> {
  final GlobalKey btmSheetKey = GlobalKey();
  var bottomSheetController;

  Future<List<Employee>> getBoolList() async {
    var dbHelper = DbHelper();
    var dbClient = await dbHelper.db;
    List<Map> list = await dbClient!.query('Employee');
    List<Employee> employees = [];
    for (int i = 0; i < list.length; i++) {
      employees.add(new Employee(
          list[i]["lang"], list[i]["image"], list[i]["dropdownItem"]));
    }
    print('length >>' + employees.length.toString());
    return employees;
  }

  @override
  void initState() {
    super.initState();
    setState(() {});
  }
  void closeBtmSht(){
    print("btmSheetbtmSheet>>"+"btmSheet.toString()");
    if(bottomSheetController!=null){
      bottomSheetController.close();
    bottomSheetController=null;
    }
    this.setState(() {
      if(bottomSheetController!=null){
        bottomSheetController.close();
        bottomSheetController=null;
      }

    });

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            centerTitle: true,
/*            leading: GestureDetector(
              onTap: () { */ /* Write listener code here */ /* },
              child: Icon(
                Icons.menu,  // add custom icons also
              ),
            ),*/
            iconTheme: const IconThemeData(color: Colors.white),
            title: Text(
              'Second View',
              style: TextStyle(color: Colors.white),
            ),
            brightness: Brightness.dark),
        body: Column(children: [
          Expanded(
            child: Column(
//      mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FutureBuilder<List<Employee>>(
                    future: getBoolList(),
                    builder: (context, future) {
                      if (future.hasData && future.data!.isNotEmpty) {

                        List<Employee>? list = future.data;
                        return ListView.builder(
                            itemCount: list!.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return
                                  /* Container(child: Text(list[index].lang.toString()));*/
                                  Card(
                                      color: Colors.white,
                                      child: Row(
                                        children: <Widget>[
                                          new Container(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              alignment: Alignment.topLeft,
                                              child: FullScreenWidget(
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(16),
//                                          child: Image.memory(Base64Decoder().convert(list[index].image.toString()),fit: BoxFit.fill,width: 80,height: 80,alignment: Alignment.center)
                                                  /* child: PhotoView(
                                            imageProvider:MemoryImage(Base64Decoder().convert(list[index].image.toString()))
                          )*/
                                                  child: InteractiveViewer(
                                                    panEnabled: false,
                                                    // Set it to false to prevent panning.
                                                    boundaryMargin:
                                                        EdgeInsets.all(80),
                                                    minScale: 0.5,
                                                    maxScale: 4,
                                                    child: Image.memory(
                                                        Base64Decoder().convert(
                                                            list[index]
                                                                .image
                                                                .toString()),
                                                        fit: BoxFit.fill,
                                                        width: 80,
                                                        height: 80,
                                                        alignment:
                                                            Alignment.center),
                                                  ),
                                                ),
                                              )),
                                          new Expanded(
                                              child: new Container(
                                            padding: const EdgeInsets.all(10.0),
                                            alignment: Alignment.topLeft,
                                            child: Text(
                                              list[index]
                                                  .dropdownItem
                                                  .toString(),
                                              style: null,
                                              textAlign: TextAlign.left,
                                              maxLines: 5,
                                            ),
                                          )),
                                        ],
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                      ));
                            });
                      } else {
                        //`snapShot.hasData` can be false if the `snapshot.data` is null
                        return new Align(
                            alignment: Alignment.center,
                            child: Container(
                                alignment: AlignmentDirectional.center,
                                height: 50,
                                margin: EdgeInsets.fromLTRB(0, 200, 0, 0),
                                padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                child: RaisedButton(
                                  textColor: Colors.white,
                                  color: Colors.green,
                                  child: Text('No Data Found!'),
                                  onPressed: () {},
                                )));
                      }
                    }),
              ],
            ),
          ),
          Container(
              alignment: AlignmentDirectional.bottomEnd,
              height: 50,
              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: RaisedButton(
                textColor: Colors.white,
                color: Colors.green,
                child: Text('Next'),
                onPressed: () {
                  bottomSheetController =showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (context) {
                        return NotificationListener<DraggableScrollableNotification>(
                            onNotification: (notification) {
                              MySharedPreferences.instance.setBtmSheet("BtmSheet", notification.extent);

                              print("${notification.extent}");

                          return false;
                        },
                        child:  DraggableScrollableSheet(
                          key: btmSheetKey,
                          initialChildSize: 0.5,
                          maxChildSize: 1,
                          builder: (BuildContext context, ScrollController scrollController) {
                            return SingleChildScrollView(
                              controller: scrollController,
                              child: Container(
                                height: MediaQuery.of(context).size.height,
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                    topLeft: const Radius.circular(10),
                                    topRight: const Radius.circular(10),
                                  ),
                                ),
//                                child: Image.asset("assets/images/logo.png"),
                                child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  ListTile(
                                    leading: new Icon(Icons.photo),
                                    title: new Text('Photo'),
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                  ListTile(
                                    leading: new Icon(Icons.music_note),
                                    title: new Text('Music'),
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                  ListTile(
                                    leading: new Icon(Icons.videocam),
                                    title: new Text('Video'),
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                  ListTile(
                                    leading: new Icon(Icons.share),
                                    title: new Text('Share'),
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                ],
                              ),
                              ),
                            );
                          },
                        ));
                      });                },
              )),
        ]));
  }
}

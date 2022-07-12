import 'dart:convert';
import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/Activity/Camera.dart';
import 'package:flutter_app/Api/rest_api.dart';
import 'package:flutter_app/HelperClass/DbHelper.dart';
import 'package:flutter_app/HelperClass/SharedPrefUtils.dart';
import 'package:flutter_app/ModelClass/Tag.dart';
import 'package:flutter_app/ModelClass/employee.dart';
import 'package:flutter_app/Resources/CustomColors.dart';
import 'package:flutter_app/Utils/utils.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'ListViewPage.dart';

String arrayObjsText =
    '{"tags": [{"name": "dart", "id": "12"}, {"name": "flutter", "id": "25"}, {"name": "json", "id": "8"}]}';

var tagObjsJson = jsonDecode(arrayObjsText)['tags'] as List;

class Home extends StatefulWidget {
  String imgPath = "";
  String lang = "";

  Home({required this.imgPath, required this.lang});

  @override
  DropDownWidget createState() => DropDownWidget(imgPath: imgPath, lang: lang);
}

class DropDownWidget extends State {
  List<Tag> tagObjs =
      tagObjsJson.map((tagJson) => Tag.fromJson(tagJson)).toList();
  String _userName = '';
  String _password = '';
  String dropdownValue = "";
  String dropdownItem = "";
  String imgPath = "";
  String lang = "";
  String newimgPath = "";
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  bool flag = false;
  final GlobalKey dropdownKey = GlobalKey();
  FocusNode dropdown = FocusNode();

  @override
  void initState() {
    super.initState();
    dropdown = FocusNode();
    print("savedDropdownValue >>" + lang);
    if (lang.isEmpty) {
      dropdownValue = tagObjs[0].id;
      dropdownItem = tagObjs[0].name;
    } else {
      dropdownValue = lang;
      getItem(dropdownValue);
    }
//    dropdownValue =tagObjs[0].id;

    MySharedPreferences.instance
        .getUserNameValue("UserName")
        .then((value) => setState(() {
              _userName = value;
            }));
    MySharedPreferences.instance
        .getPasswordValue("Password")
        .then((value) => setState(() {
              _password = value;
            }));
  }

  DropDownWidget({required this.imgPath, required this.lang});
  void drpDnState(){
    print("flagflag>>"+flag.toString());
    Navigator.of(context).pop(dropdownKey.currentContext); // Closes the dropdown
    setState(() {
      Navigator.of(context).pop(dropdownKey.currentContext); // Closes the dropdown
     print("flagflag>>"+flag.toString());
//    dropdown.unfocus();
  });
  }
  @override
  Widget build(BuildContext context) {
//    dropdownValue =tagObjs[0].id;
    Uint8List _bytesImage = Base64Decoder().convert(imgPath);

    return  new  Scaffold(
        key: scaffoldKey,
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
              'First View',
              style: TextStyle(color: Colors.white),
            ),
            brightness: Brightness.dark),
        body: SingleChildScrollView(
            child: Column(children: <Widget>[
          Container(
              alignment: Alignment.topLeft,
              padding: EdgeInsets.all(10),
              child: Text(
                'Select Item',
                style: TextStyle(fontSize: 20),
              )),
          Padding(
              padding: const EdgeInsets.only(
                  left: 40, right: 40, bottom: 24, top: 12),
              child: Container(
                  height: 55, //gives the height of the dropdown button
                  width: MediaQuery.of(context)
                      .size
                      .width, //gives the width of the dropdown button
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.green, width: 1),
                      borderRadius: BorderRadius.all(Radius.circular(3)),
                      color: Color(0xFFF2F2F2)),
                  padding:
                      EdgeInsets.only(top: 0, left: 0, bottom: 0, right: 10),
                  margin: EdgeInsets.only(top: 0, left: 0, bottom: 0, right: 0),
                  // padding: const EdgeInsets.symmetric(horizontal: 13), //you can include padding to control the menu items
                  child: Theme(
                      data: Theme.of(context).copyWith(
                          canvasColor: Colors
                              .white, // background color for the dropdown items
                          buttonTheme: ButtonTheme.of(context).copyWith(
                            alignedDropdown:
                                true, //If false (the default), then the dropdown's menu will be wider than its button.
                          )),
                      child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            focusNode: dropdown,
                            key: dropdownKey,
                        value: dropdownValue,
                        icon: Image.asset(
                          'assets/images/down_arrow.png',
                          width: 20,
                          height: 20,
                          color: Colors.green,
                        ),
                        iconSize: 6,
                        elevation: 2,
                        style: const TextStyle(color: Colors.green),
                        underline: Container(
                          height: 2,
                          color: Colors.green,
                        ),
                        onTap: (){
                              setState(() {
                                flag=true;
                                MySharedPreferences.instance.setDrnFlag("DrnFlag", flag);
                              });
                        },
                        isExpanded: flag,
                        onChanged: (String? newValue) {
                          print(tagObjs);
                          print("userName >>" + _userName);
                          print("password >>" + _password);
                          dropdownValue = newValue!;
                          print("dropdownValue >>" + dropdownValue);
                          getItem(dropdownValue);
                          flag=false;
                          MySharedPreferences.instance.setLang("Lang", dropdownValue);
                          MySharedPreferences.instance.setDrnFlag("DrnFlag", flag);

//              callGet();
                          setState(() {
                            flag=false;
                            dropdownValue = newValue;
                            print("dropdownValue >>" + dropdownValue);
                            MySharedPreferences.instance.setLang("Lang", dropdownValue);
                            MySharedPreferences.instance.setDrnFlag("DrnFlag", flag);
                            getItem(dropdownValue);
                          });
                        },
                        items: tagObjs.map((Tag map) {
                          return new DropdownMenuItem<String>(
                            value: map.id,
                            child: new Text(map.name,
                                style: new TextStyle(
                                    color: ColorConstants.PrimaryDarkColor)),
                          );
                        }).toList(),
                      ))))),
          new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                InkWell(
                    onTap: () {
                      print("Container clicked");
                      /* onButtonTap(
               CameraWidget(),
             );*/
/*                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => CameraWidgetScreen(
                          lang: dropdownValue,
                        ),
                      ));*/    _getCameras();

                    },
                    child: Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.all(10),
                        child: imgPath.isEmpty
                            ? Image.network(
                                'https://images.indianexpress.com/2021/02/Green-solution.jpg',
                                width: 200,
                                height: 150,
                                fit: BoxFit.fill,
                                alignment: Alignment.center,
                              )
                            :
                            /*Image.file(File(imgPath)),width: 200,height: 150,*/ Image
                                .memory(
                                _bytesImage,
                                fit: BoxFit.fill,
                                width: 200,
                                height: 150,
                                alignment: Alignment.center,
                              ))),
              ]),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                RaisedButton(
                  child: Text("Add"),
                  onPressed: () {
                    MySharedPreferences.instance
                        .getImage("Image")
                        .then((value) => setState(() {
                              imgPath = value;
                            }));
                    print("dropdownValue >>" +
                        dropdownValue +
                        "dropdownItem >>" +
                        dropdownItem +
                        "imgPath >>" +
                        imgPath);
                    if (!imgPath.isEmpty) {
                      var employee =
                          Employee(dropdownValue, imgPath, dropdownItem);
                      var dbHelper = DbHelper();
                      dbHelper.saveEmployee(employee);
//                showSnackBar("Data saved successfully");
                    } else {
                      Fluttertoast.showToast(
                          msg: "Capture image!",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 1);
                    }
                  },
                ),
                SizedBox(width: 5),
                RaisedButton(
                  child: Text("Get"),
                  onPressed: () {
                    callGet();
                  },
                ),
              ],
            ),
          ),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                RaisedButton(
                  child: Text("Delete"),
                  onPressed: () {
                    print("dropdownValue >>" + dropdownValue);
                    var dbHelper = DbHelper();
                    dbHelper.delete(dropdownValue);
                    showSnackBar("Data Deleted successfully");
                  },
                ),
                SizedBox(width: 5),
                RaisedButton(
                  child: Text("Update"),
                  onPressed: () {
                    MySharedPreferences.instance
                        .getImage("Image")
                        .then((value) => setState(() {
                              imgPath = value;
                            }));
//                MySharedPreferences.instance.getLang("Lang").then((value) => setState(() { dropdownValue = value;}));

                    print("dropdownValue >>" +
                        dropdownValue +
                        "dropdownItem >>" +
                        dropdownItem +
                        "imgPath >>" +
                        imgPath);
                    var employee =
                        Employee(dropdownValue, imgPath, dropdownItem);
                    var dbHelper = DbHelper();
                    dbHelper.update(employee);
//                showSnackBar("Data Updated successfully");
                  },
                ),
              ],
            ),
          ),
          Visibility(
              visible: false,
              child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => SecondView(),
                    ));
                  },
                  child: new Container(
                    margin: EdgeInsets.all(30),
                    child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text("Go",
                              style: new TextStyle(
                                  color: ColorConstants.PrimaryDarkColor,
                                  fontSize: 20)),
                          Icon(
                            Icons.arrow_forward,
                            color: Colors.green,
                          ),
                        ]),
                  )))
        ])));
  }

  void showSnackBar(String text) {
    scaffoldKey.currentState!
        .showSnackBar(new SnackBar(content: new Text(text)));
  }

  void callGet() {
    print("dropdownValue >>" + dropdownValue);
    var dbHelper = DbHelper();
    Future<List<Employee>> employees = dbHelper.getEmployees(dropdownValue);
    employees.then((data) {
      print('data length >>' + data.length.toString());
      if (data.length > 0) {
        newimgPath = data[0].image;
        setState(() {
          imgPath = newimgPath;
        });
        print("imgPath>>" + newimgPath);
      } else {
        showSnackBar("No Data Found!");
      }
    }, onError: (e) {
      print(e);
    });
  }


  void getItem(String dropdownValue) {
    for (int i = 0; i < tagObjs.length; i++) {
      if (tagObjs[i].id.toString() == dropdownValue) {
        dropdownItem = tagObjs[i].name;
      }
    }
    print("dropdownItem >>" + dropdownItem);
  }

  Future _getCameras() async{
    final cameras = await availableCameras();
    final cam = cameras.first;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => TakePictureScreen(camera: cam,lang: lang)),
    );
  }

}



import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Activity/Home.dart';
import 'package:flutter_app/Activity/ListViewPage.dart';
import 'package:flutter_app/HelperClass/SharedPrefUtils.dart';
import 'package:flutter_app/Utils/app_bottom_navigation.dart';
import 'package:provider/provider.dart';

import 'HomeScreen.dart';

  class FirstHome extends StatefulWidget {
    String imgPath = "";
    String lang = "";
    FirstHome({required this.imgPath, required this.lang});

    @override
  FirstHomeState createState() => FirstHomeState(imgPath: imgPath,lang: lang);
  }


  class FirstHomeState extends State<FirstHome> {
    DropDownWidget dropDownWidget = DropDownWidget(imgPath: '', lang: '');

    SecondViewState secondViewState=new SecondViewState();
    String imgPath = "";
    String lang = "";
    FirstHomeState({required this.imgPath, required this.lang});
    // This widget is the root of your application.
  Map<int, Color> color = {
    50: const Color.fromRGBO(250, 202, 88, .1),
    100: const Color.fromRGBO(250, 202, 88, .2),
    200: const Color.fromRGBO(250, 202, 88, .3),
    300: const Color.fromRGBO(250, 202, 88, .4),
    400: const Color.fromRGBO(250, 202, 88, .5),
    500: const Color.fromRGBO(250, 202, 88, .6),
    600: const Color.fromRGBO(250, 202, 88, .7),
    700: const Color.fromRGBO(250, 202, 88, .8),
    800: const Color.fromRGBO(250, 202, 88, .9),
    900: const Color.fromRGBO(250, 202, 88, 1),
  };
  bool flag = false;
  bool _cameraOn = false;
  String Lang = "";
    String img = "";
    double btmSheet=0;


    Future<bool> onWillPop() async {
    print("back>>"+"HomeScreenState");
    MySharedPreferences.instance.getDrnFlag("DrnFlag").then((value) => setState(() {flag = value;}));
    MySharedPreferences.instance.getCamFlag("CamFlag").then((value) => setState(() {_cameraOn = value;}));
    MySharedPreferences.instance.getBtmSheet("BtmSheet").then((value) => setState(() {btmSheet = value;}));

    if(_cameraOn) {
      print("_cameraOn>>"+_cameraOn.toString());
      MySharedPreferences.instance.getLang("Lang").then((value) => setState(() {Lang = value;}));
      MySharedPreferences.instance.getImage("Image").then((value) => setState(() {img = value;}));
      print("image>>"+img);
      print("lang>>"+Lang);
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => FirstHome(imgPath: img,lang: Lang)));

      return false;

    }else if (flag){
        print("flag>>"+flag.toString());
        MySharedPreferences.instance.getLang("Lang").then((value) => setState(() {Lang = value;}));
        MySharedPreferences.instance.getImage("Image").then((value) => setState(() {img = value;}));
        print("image>>"+img);
        print("lang>>"+Lang);
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => FirstHome(imgPath: img,lang: Lang)));
        dropDownWidget.drpDnState();
        return false;
      }else if(btmSheet>0){
      print("btmSheet>>"+btmSheet.toString());
      secondViewState.closeBtmSht();
      return false;
    } else{
     // This dialog will exit your app on saying yes
        return (await showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Are you sure?'),
            content: new Text('Do you want to exit an App'),
            actions: <Widget>[
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text('No'),
              ),
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: new Text('Yes'),
              ),
            ],
          ),
        )) ??
            false;
      }

  }

 /* Future<bool> onWillPop() async {
    print("back>>"+"FirstHomeState");

    // This dialog will exit your app on saying yes
    return (await showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text('Are you sure?'),
        content: new Text('Do you want to Logout'),
        actions: <Widget>[
          new FlatButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: new Text('No'),
          ),
          new FlatButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: new Text('Yes'),
          ),
        ],
      ),
    )) ??
        false;

  }*/

  @override
  Widget build(BuildContext context) {
    final MaterialColor colorCustom = MaterialColor(0xFFFACA58, color);
    return WillPopScope(
        onWillPop: onWillPop,
        child: new MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: BottomNavigatorProvider())
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: colorCustom,
        ),
        home: HomeScreen(imgPath: imgPath,lang: lang,),
      ),
    ));
  }
}



import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Activity/ThirdView.dart';
import 'package:flutter_app/Activity/fourth_view.dart';
import 'package:flutter_app/HelperClass/SharedPrefUtils.dart';
import 'package:flutter_app/Utils/app_bottom_navigation.dart';
import 'package:provider/provider.dart';

import 'Home.dart';
import 'ListViewPage.dart';


  class HomeScreen extends StatefulWidget {
    String imgPath = "";
    String lang = "";
    HomeScreen({required this.imgPath, required this.lang});

    @override
  HomeScreenState createState() => HomeScreenState(imgPath: imgPath,lang: lang);
  }

  class HomeScreenState extends State<HomeScreen> {
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

  final arrBottomItems = [
    tabItem('First View', Icons.home),
    tabItem('Second View', Icons.category),
    tabItem('Third View', Icons.favorite),
    tabItem('Fourth View', Icons.search),
  ];
  String imgPath = "";
  String lang = "";
  static const exitTimeInMillis = 2000;
  bool flag = false;

  HomeScreenState({required this.imgPath, required this.lang});
  @override
  void initState() {
    super.initState();
  }
  Future<bool> onWillPop() async {
    print("back>>"+"HomeScreenState");
    MySharedPreferences.instance.getDrnFlag("DrnFlag").then((value) => setState(() {flag = value;}));

    if(flag){
      print("flag>>"+flag.toString());
      return false;
    }else{
      print("flag>>"+flag.toString());
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

  @override
  Widget build(BuildContext context) {
    final MaterialColor colorCustom = MaterialColor(0xFFFACA58, color);
    return  new Scaffold(
      /*appBar: AppBar(
          centerTitle: true,
          leading: GestureDetector(
            onTap: () { *//* Write listener code here *//* },
            child: Icon(
              Icons.menu,  // add custom icons also
            ),
          ),
          iconTheme: const IconThemeData(color: Colors.white),
          title: Consumer<BottomNavigatorProvider>(
            builder: (ctx, item, child) {
              if (item.selectedIndex == 0) {
                return const Text(
                  'First View',
                  style: TextStyle(color: Colors.white),
                );
              } else if (item.selectedIndex == 1) {
                return const Text('Second View',
                    style: TextStyle(color: Colors.white));
              } else if (item.selectedIndex == 2) {
                return const Text('Third View',
                    style: TextStyle(color: Colors.white));
              } else if (item.selectedIndex == 3) {
                return const Text('Fourth View',
                    style: TextStyle(color: Colors.white));
              } else {
                return null;
              }
            },
          ),
          brightness: Brightness.dark),*/
      body: Center(
        child: Consumer<BottomNavigatorProvider>(
          builder: (ctx, item, child) {
            switch (item.selectedIndex) {
              case 0:
                return Home(imgPath: imgPath,lang: lang);
                break;
              case 1:
                return SecondView();
                break;
              case 2:
                return ThirdView();
                break;
              case 3:
                return FourthView();
                break;
              default:
                return Home(imgPath: imgPath,lang: lang);
                break;
            }
          },
        ),
      ),
      bottomNavigationBar: BottomNavigation(
          arrBottomItems: arrBottomItems,
          backgroundColor: colorCustom,
          showSelectedLables: true,
          showUnselectedLables: true,
          color: Colors.black,
          selectedColor: Colors.white),
    );
  }

}
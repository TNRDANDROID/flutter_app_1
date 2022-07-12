import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_app/Activity/Home.dart';
import 'package:flutter_app/HelperClass/SharedPrefUtils.dart';

import 'Activity/FirstHome.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Splash Screen',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}
class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3),
            ()=>Navigator.pushReplacement(context,
            MaterialPageRoute(builder:
                (context) =>
                SecondScreen()
            )
        )
    );
  }
  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        child:FlutterLogo(size:MediaQuery.of(context).size.height)
    );
  }
}
class SecondScreen extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends State<SecondScreen> {
  final _formKey = GlobalKey<FormState>();
  String _userName = '';
  String _password = '';
  TextEditingController passwordController = TextEditingController();

  onButtonTap(Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => page));
  }
  @override
  void initState() {
    super.initState();
    MySharedPreferences.instance.setImage("Image", "");
    MySharedPreferences.instance.setLang("Lang", "");

  }
  Future<bool> onWillPop() async {
    print("back>>"+"_CameraWidgetState");

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
  @override
  Widget build(BuildContext context) {

    return WillPopScope(
        onWillPop: onWillPop,
        child: new Scaffold(
        appBar: AppBar(
          title: Text('Flutter'),
        ),
        body: Form(
        key: _formKey,
            child:Padding(
            padding: EdgeInsets.all(0),
          child: Container(
            decoration: BoxDecoration(
            gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: FractionalOffset.bottomCenter,
//            colors: [Colors.red, Colors.orange],
            colors: [Colors.white, Colors.white],
            stops: [0, 1],
            ),
            ),
            child: ListView(
              children: <Widget>[
/*                Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(10),
                    child: Text(
                      'TutorialKart',
                      style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.w500,
                          fontSize: 30),
                    )),*/
                Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.all(10),
                    padding: EdgeInsets.all(10),
                    child: Text(
                      'Sign in',
                      style: TextStyle(fontSize: 20),
                    )),
                Container(
                  padding: EdgeInsets.all(10),
                  child: TextFormField(
                    decoration: InputDecoration(labelText: 'Username'),
                    validator: (value) {
                      if (value.toString().trim().isEmpty) {
                        return 'This field is required';
                      }
                      if (value.toString().trim().length < 2) {
                        return 'Username must be at least 2 characters in length';
                      }
                      // Return null if the entered username is valid
                      return null;
                    },
                    onChanged: (value) => _userName = value,
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 40),
                  child: TextFormField(
                    decoration: InputDecoration(labelText: 'Password'),
                    obscureText: true,
                    validator: (value) {
                      if (value.toString().trim().isEmpty) {
                        return 'This field is required';
                      }
                      if (value.toString().trim().length < 4) {
                        return 'Password must be at least 4 characters in length';
                      }
                      // Return null if the entered password is valid
                      return null;
                    },
                    onChanged: (value) => _password = value,
                  ),
                ),
                FlatButton(
                  onPressed: (){
                    //forgot password screen
                  },
                  textColor: Colors.black,
                  child: Text('Forgot Password'),
                ),
                Container(
                    height: 50,
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: RaisedButton(
                      textColor: Colors.white,
                      color: Colors.green,
                      child: Text('Login'),
                      onPressed: () {
                        final isValid = _formKey.currentState!.validate();
                        if (!isValid) {
                          print(passwordController.text);
                          MySharedPreferences.instance.setUserNameValue("UserName", _userName);
                          MySharedPreferences.instance.setPasswordValue("Password", _password);
                          MySharedPreferences.instance.setLang("Lang", "");
                          onButtonTap(
                              FirstHome(imgPath: '', lang: '',),
//                            Home(imgPath: "",lang: ""),
                          );

/*                          Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => Home(imgPath: "",),
                              ));*/                        }

                      },
                    )),
                Container(
                    child: Row(
                      children: <Widget>[
                        Text('Does not have account?'),
                        FlatButton(
                          textColor: Colors.black,
                          child: Text(
                            'Sign Up',
                            style: TextStyle(fontSize: 20),
                          ),
                          onPressed: () {
                            //signup screen
                          },
                        )
                      ],
                      mainAxisAlignment: MainAxisAlignment.center,
                    ))
              ],
            ))))));
  }

}

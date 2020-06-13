import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'main.dart';

class Splash extends StatefulWidget {
  const Splash({Key key}) : super(key: key);

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {

  @override
  void initState() {
    
    super.initState();
    Future.delayed(Duration(seconds: 60),(){
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (BuildContext context) => HomePage())
      );
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: <Widget>[
        Center(
          child: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
              colors: [
                Colors.blue[800],
                Colors.blue[300],
                Colors.blue[200],
                Colors.blue[100]
              ],
            )),
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Shimmer.fromColors(
                      baseColor: Colors.red[300],
                      highlightColor: Colors.blue[900],
                      child: Text(
                        'الأمين',
                        style: TextStyle(
                          fontSize: 40,
                          shadows: [
                            Shadow(
                              blurRadius: 18,
                              color: Colors.black38,
                              offset: Offset.fromDirection(120, 12),
                            ),
                          ],
                        ),
                        textDirection: TextDirection.rtl,
                      ),
                    ),
                    Shimmer.fromColors(
                      baseColor: Colors.red[300],
                      highlightColor: Colors.blue[900],
                      child: Text(
                        'আল আমিন',
                        style: TextStyle(
                            fontSize: 35,
                            fontWeight: FontWeight.bold,
                            
                            shadows: [
                              Shadow(
                                blurRadius: 18,
                                color: Colors.black38,
                                offset: Offset.fromDirection(120, 12),
                              ),
                            ]),
                      ),
                    ),
                    Shimmer.fromColors(
                      baseColor: Colors.red[300],
                      highlightColor: Colors.blue[900],
                      child: Text(
                        'AL AMIN',
                        style: TextStyle(
                            fontSize: 30,
                            color: Colors.indigo,
                            shadows: [
                              Shadow(
                                blurRadius: 18,
                                color: Colors.black38,
                                offset: Offset.fromDirection(120, 12),
                              ),
                            ]),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Container(
                child: Center(
                    child: CircleAvatar(
                      radius: 60,
                      child: Image(
                        image: AssetImage('assets/images/logo-quran2.png'),
                      ),
                    )),
              ),
            ),
            Expanded(
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            width: 100,
                            height: 80,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage('assets/images/bd.png'))),
                          ),
                          Text(
                            'BANGLA',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            width: 100,
                            height: 80,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image:
                                        AssetImage('assets/images/usa.png'))),
                          ),
                          Text(
                            'ENGLISH',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ],
    ));
  }
}
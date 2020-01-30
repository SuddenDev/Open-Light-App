import 'package:flutter/material.dart';
import 'package:neumorphic/neumorphic.dart';
import 'package:open_light_app/utils/themes.dart';

import 'package:open_light_app/screens/home/home_slider.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  
  double _valTemperature = 0;
  double _valBrightness = 0;
  
  // TODO:Replace with isDark function
  
  
  @override
  Widget build(BuildContext context) {

    final Brightness brightnessValue = MediaQuery.of(context).platformBrightness;
    bool isDark = brightnessValue == Brightness.dark;

    List<BoxShadow> softUiShadow = false ? softUiShadowsDark : softUiShadowsLight;


    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(120.0),
          child: Container(
              child: Padding(
                  padding: EdgeInsets.only(top: 56.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Image.asset(
                        'assets/logo_a_light.png',
                        fit: BoxFit.contain,
                        height: 40,
                      ),
                    ],
                  )),
            ),
        ),
        body: Container(
          margin: EdgeInsets.only(top: MediaQuery.of(context).size.height / 10),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(top: 16.0, bottom: 16.0),
                    margin: EdgeInsets.only(
                        right: MediaQuery.of(context).size.height / 20),
                    width: MediaQuery.of(context).size.width / 5.5,
                    height: MediaQuery.of(context).size.height * .5,
                    decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.all(Radius.circular(16.0)),
                        boxShadow: softUiShadow,
                        ),
                    child: Center(
                      child: HomeSlider(
                        sliderHeight: MediaQuery.of(context).size.height * 0.45,
                        sliderSegments: 17,
                        sliderWidth: MediaQuery.of(context).size.width / 8.5,
                        color: Colors.grey[200],
                        backgroundColor: Colors.blueGrey[200].withAlpha(100),
                        innerShadowTopColor: Colors.blueGrey[400],
                        innerShadowBottomColor: Colors.blueGrey[50],
                        onChanged: (double val) => _valBrightness = val,
                        onChangeStart: (double val) => _valBrightness = val,
                      )
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                        left: MediaQuery.of(context).size.height / 20),
                    width: MediaQuery.of(context).size.width / 5.5,
                    height: MediaQuery.of(context).size.height * .5,
                    decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.all(Radius.circular(16.0)),
                        boxShadow: softUiShadow,
                    ),
                    child: Center(
                      child: HomeSlider(
                        sliderWidth: MediaQuery.of(context).size.width / 8.5,
                        sliderHeight: MediaQuery.of(context).size.height * 0.45,
                        sliderSegments: 17,
                        color: Color.lerp(Colors.lightBlue[50], Colors.amber[100], _valTemperature),
                        backgroundColor: Colors.blueGrey[200].withAlpha(100),
                        innerShadowTopColor: Colors.blueGrey[400],
                        innerShadowBottomColor: Colors.blueGrey[50],
                        startValue: 0.5,
                        onChanged: (double val) => setState(() => _valTemperature = val),
                        onChangeStart: (double val) => setState(() => _valTemperature = val),
                      )
                    ),
                  ),
                ],
              ),
              Neumorphic(
                margin: EdgeInsets.only(top: 64.0),
                padding: EdgeInsets.all(16.0),
                bevel: 20,
                status: NeumorphicStatus.convex,
                decoration: NeumorphicDecoration(
                  borderRadius: BorderRadius.circular(64),
                  color: Theme.of(context).primaryColor
                ),
                child: Icon(
                  Icons.lightbulb_outline,
                  size: 40.0,
                  color: Colors.blueGrey.shade300,
                ),
              ),
            ],
          ),
        ));
  }
}


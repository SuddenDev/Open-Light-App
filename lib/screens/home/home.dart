import 'package:flutter/material.dart';
// import 'package:flutter_xlider/flutter_xlider.dart';

import 'package:open_light_app/screens/home/home_slider.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  
  double _valTemperature = 0;
  double _valBrightness = 0;

  final _softUiShadowsDark = [
    BoxShadow(
      color: new Color(0x22000000),
      blurRadius: 12.0, // has the effect of softening the shadow
      spreadRadius: 1.0, // has the effect of extending the shadow
      offset: Offset(
          5.0, // horizontal, move right 10
          5.0 // vertical, move down 10
          ),
    ),
    BoxShadow(
      color: new Color(0x66ffffff),
      blurRadius: 12.0,
      spreadRadius: 1.0,
      offset: Offset(
          -5.0, // horizontal, move right 10
          -5.0 // vertical, move down 10
          ),
    )
  ];

  final _softUiShadowsLight = [
    BoxShadow(
      color: new Color(0x22000000),
      blurRadius: 12.0, // has the effect of softening the shadow
      spreadRadius: 1.0, // has the effect of extending the shadow
      offset: Offset(
          5.0, // horizontal, move right 10
          5.0 // vertical, move down 10
          ),
    ),
    BoxShadow(
      color: new Color(0x66ffffff),
      blurRadius: 12.0,
      spreadRadius: 1.0,
      offset: Offset(
          -5.0, // horizontal, move right 10
          -5.0 // vertical, move down 10
          ),
    )
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(120.0),
          child: AlineAppBar(softUiShadows: _softUiShadowsLight),
        ),
        body: Container(
          margin: EdgeInsets.only(top: MediaQuery.of(context).size.height / 8),
          height: MediaQuery.of(context).size.height * .5,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(top: 16.0, bottom: 16.0),
                margin: EdgeInsets.only(
                    right: MediaQuery.of(context).size.height / 20),
                width: MediaQuery.of(context).size.width / 10,
                decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.all(Radius.circular(32.0)),
                    boxShadow: _softUiShadowsLight),
                child: Center(
                  child: HomeSlider(
                    sliderHeight: MediaQuery.of(context).size.height * 0.45,
                    sliderSegments: 17,
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
                width: 95.0,
                decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.all(Radius.circular(32.0)),
                    boxShadow: _softUiShadowsLight
                ),
                child: Center(
                  child: HomeSlider(
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
        ));
  }
}

class AlineAppBar extends StatelessWidget {
  const AlineAppBar({
    Key key,
    @required List<BoxShadow> softUiShadows,
  })  : _softUiShadows = softUiShadows,
        super(key: key);

  final List<BoxShadow> _softUiShadows;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
          padding: EdgeInsets.only(top: 56.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Image.asset(
                'assets/aline_logo@2x.png',
                fit: BoxFit.contain,
                height: 36,
              ),
            ],
          )),
    );
  }
}

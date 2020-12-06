import 'package:flutter/material.dart';
import 'package:screen/screen.dart';
import 'package:screen_light/main_bloc.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  MainBloc mainBloc;
  bool setting = false;

  @override
  void initState() {
    super.initState();
    mainBloc = MainBloc();
  }

  @override
  void dispose() {
    super.dispose();
    mainBloc.dispose();
  }

  double _opacity = 1;
  double maxBrightness = 1;
  @override
  Widget build(BuildContext context) {
    Screen.setBrightness(maxBrightness);
    return Scaffold(
      body: Stack(
        children: [
          StreamBuilder<List<double>>(
              stream: mainBloc.colors,
              builder: (context, snapshot) {
                final colors = snapshot.data;
                print(colors);
                if (colors != null) {
                  return Container(
                    color: Color.fromRGBO(colors.first.toInt(),
                        colors[1].toInt(), colors.last.toInt(), _opacity),
                  );
                } else {
                  return Container(
                    color: Colors.green,
                  );
                }
              }),
          Align(
            alignment: Alignment.topRight,
            child: Container(
              padding: EdgeInsets.all(8),
              margin: EdgeInsets.all(16),
              child: IconButton(
                  icon: Icon(
                    setting ? Icons.visibility_off : Icons.visibility,
                    size: 24,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    if (setting) {
                      mainBloc.saveColor();
                    }

                    setState(() {
                      setting = !setting;
                    });
                  }),
            ),
          ),
          Center(
              child: setting
                  ? Container(
                      height: 250,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          StreamBuilder<double>(
                            stream: mainBloc.red,
                            builder: (context, snapshot) {
                              return buildSlider(snapshot.data ?? 0, Colors.red,
                                  (value) {
                                mainBloc.redChange(value);
                              });
                            },
                          ),
                          StreamBuilder<double>(
                            stream: mainBloc.green,
                            builder: (context, snapshot) {
                              return buildSlider(
                                  snapshot.data ?? 0, Colors.green, (value) {
                                mainBloc.greenChange(value);
                              });
                            },
                          ),
                          StreamBuilder<double>(
                            stream: mainBloc.blue,
                            builder: (context, snapshot) {
                              return buildSlider(
                                  snapshot.data ?? 0, Colors.blue, (value) {
                                mainBloc.blueChange(value);
                              });
                            },
                          ),
                        ],
                      ),
                    )
                  : Container())
        ],
      ),
    );
  }

  Widget buildSlider(double initValue, Color color, ChangeCallback callback) {
    return RotatedBox(
      quarterTurns: 1,
      child: Slider(
          activeColor: color,
          inactiveColor: Colors.white,
          min: 0,
          max: 255,
          value: initValue,
          onChanged: callback),
    );
  }
}

typedef ChangeCallback = void Function(double value);

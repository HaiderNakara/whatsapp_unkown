import 'dart:async';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:receive_sharing_intent/receive_sharing_intent.dart';

import 'components/default_button.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      themeMode: ThemeMode.system,
      darkTheme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

TextEditingController number = TextEditingController();
TextEditingController numberCode = TextEditingController(text: "+91");

class _MyHomePageState extends State<MyHomePage> {
  StreamSubscription? _intentDataStreamSubscription;
  String? _sharedText;

  @override
  void initState() {
    super.initState();
    _intentDataStreamSubscription =
        ReceiveSharingIntent.getTextStream().listen((String value) {
      print(value);
      setState(() {
        number.text = value;
      });
    }, onError: (err) {
      print("getLinkStream error: $err");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Something went wrong"),
        ),
      );
    });
    ReceiveSharingIntent.getInitialText().then((String? value) {
      setState(() {
        if (value != null) {
          number.text = value;
        }
      });
    });
    number.addListener(() {
      setState(() {});
    });
    numberCode.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _intentDataStreamSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        children: <Widget>[
          Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.only(left: 16.0, top: 70.0, right: 16.0),
                  child: Text(
                    "Enter the phone number",
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 20.0),
                  child: SizedBox(
                    height: 120.0,
                    width: 120.0,
                  ),
                ),
                Row(
                  children: <Widget>[
                    Flexible(
                      child: Container(),
                      flex: 1,
                    ),
                    Flexible(
                      child: TextFormField(
                        textAlign: TextAlign.center,
                        controller: numberCode,
                        style: const TextStyle(
                          fontSize: 20.0,
                        ),
                      ),
                      flex: 3,
                    ),
                    Flexible(
                      child: Container(),
                      flex: 1,
                    ),
                    Flexible(
                      child: TextFormField(
                        decoration: const InputDecoration(hintText: "Number"),
                        controller: number,
                        textAlign: TextAlign.start,
                        autofocus: false,
                        enabled: true,
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.done,
                        style: const TextStyle(
                          fontSize: 20.0,
                        ),
                      ),
                      flex: 9,
                    ),
                    Flexible(
                      child: Container(),
                      flex: 1,
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(40.0),
                  child: DefaulfButton(
                    press:
                        number.text.length == 10 && numberCode.text.isNotEmpty
                            ? () async {
                                if (!await launch('https://wa.me/' +
                                    numberCode.text +
                                    number.text)) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      duration: Duration(seconds: 1),
                                      content: Text("Something went wrong"),
                                    ),
                                  );
                                }
                              }
                            : null,
                    text: "Open",
                  ),
                ),
              ])
        ],
      ),
    );
  }
}

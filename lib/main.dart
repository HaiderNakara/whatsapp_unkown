import 'dart:async';
import 'dart:io';
import 'package:clipboard/clipboard.dart';
import 'package:flutter/foundation.dart';
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
TextEditingController message = TextEditingController();
TextEditingController numberCode = TextEditingController(text: "+91");
bool isMessaging = false;

class _MyHomePageState extends State<MyHomePage> {
  StreamSubscription? _intentDataStreamSubscription;
  String? _sharedText;
  longPress() {
    setState(() {
      isMessaging = !isMessaging;
    });
  }

  clean(String number) {
    try {
      if (number.contains(RegExp(r'[a-zA-Z]'))) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Invalid Number")));
        return "";
      }
      if (number.startsWith("+91")) {
        number = number.replaceFirst("+91", "");
        number = number.replaceAll(RegExp(r'[^\d]'), '');
        return number;
      }
      number = number.replaceAll(RegExp(r'[^\d]'), '');
      return number;
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Invalid Number")));
      return "";
    }
  }

  @override
  void initState() {
    super.initState();
    // check if the platform is android
    if (kIsWeb) {
    } else if (Platform.isAndroid) {
      _intentDataStreamSubscription =
          ReceiveSharingIntent.getTextStream().listen((String value) {
        setState(() {
          number.text = clean(value);
        });
      }, onError: (err) {
        print("getLinkStream error: $err");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Something went wrong"),
          ),
        );
      });
      ReceiveSharingIntent.getInitialText().then((String? value) {
        setState(() {
          if (value != null) {
            number.text = clean(value);
          }
        });
      });
    }
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
      appBar: AppBar(
        actions: [
          // if (isMessaging)
          //   IconButton(
          //     icon: const Icon(
          //       Icons.message,
          //       color: Colors.white,
          //     ),
          //     onPressed: () {
          //       setState(() {
          //         isMessaging = !isMessaging;
          //       });
          //     },
          //   ),
          IconButton(
            icon: const Icon(Icons.paste),
            onPressed: () {
              FlutterClipboard.paste().then((String? value) {
                if (value != null) {
                  setState(() {
                    number.text = clean(value);
                  });
                }
              });
            },
          ),
        ],
      ),
      body: ListView(
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        children: <Widget>[
          Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding:
                      const EdgeInsets.only(left: 16.0, top: 70.0, right: 16.0),
                  child: GestureDetector(
                    onLongPress: longPress,
                    child: Text(
                      !isMessaging
                          ? "Enter the phone number"
                          : "Enter the phone number and message",
                      style: const TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 20.0),
                  child: SizedBox(
                    height: 120.0,
                    width: 120.0,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
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
                ),
                if (isMessaging)
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 20.0, left: 40.0, right: 40.0),
                    child: TextFormField(
                      controller: message,
                      decoration: const InputDecoration(
                        hintText: "Message",
                      ),
                      maxLines: 3,
                      keyboardType: TextInputType.multiline,
                      textInputAction: TextInputAction.newline,
                      style: const TextStyle(
                        fontSize: 20.0,
                      ),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.all(40.0),
                  child: DefaulfButton(
                    longPress:
                        number.text.length == 10 && numberCode.text.isNotEmpty
                            ? () => {
                                  setState(() {
                                    isMessaging = !isMessaging;
                                  }),
                                }
                            : null,
                    press:
                        number.text.length == 10 && numberCode.text.isNotEmpty
                            ? () async {
                                if (!await launch(!isMessaging
                                    ? 'https://wa.me/' +
                                        numberCode.text +
                                        number.text
                                    : 'https://wa.me/' +
                                        numberCode.text +
                                        number.text +
                                        '?text=' +
                                        Uri.encodeComponent(message.text))) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      duration: Duration(seconds: 1),
                                      content: Text("Something went wrong"),
                                    ),
                                  );
                                }
                              }
                            : null,
                    text: !isMessaging ? "Open" : "Message",
                  ),
                ),
              ])
        ],
      ),
    );
  }
}

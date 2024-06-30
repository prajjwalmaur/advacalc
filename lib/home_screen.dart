import 'dart:convert';
// import 'dart:ffi';

import 'package:advacalc/advan_screen.dart';
import 'package:advacalc/snakbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:shared_preferences/shared_preferences.dart';

// import 'package:auto_size_text/auto_size_text.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late SharedPreferences _pref;
  final TextEditingController _variableController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String userInput = "";
  String result = "0";
  Map<String, dynamic> data = {};
  bool mode = false;
  double screen_width = 0;
  bool clickResult = false;
  List<dynamic> buttons = [
    "AC",
    "(",
    ")",
    "/",
    "7",
    "8",
    "9",
    "x",
    "4",
    "5",
    "6",
    "-",
    "1",
    "2",
    "3",
    "+",
    "0",
    ".",
    "DEL",
    "="
  ];

  @override
  void initState() {
    super.initState();
    intialstep();
  }

  Future<void> intialstep() async {
    _pref = await SharedPreferences.getInstance();
    data = await jsonDecode(_pref.getString("data") ?? "{}");
  }

  bool storVar() {
    if (_formKey.currentState!.validate()) {
      data[_variableController.text] = result;
      _pref.setString("data", jsonEncode(data));
      _variableController.clear();
      showCustomSnackBar(context, "Saved");
      return true;
    }
    return false;
  }

  void _showStartDialog() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                softWrap: true,
                overflow: TextOverflow.ellipsis,
                'Enter the Name of Variable : ',
                style: TextStyle(fontSize: 15.sp),
              ),
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.red, width: 3),
                ),
                child: IconButton(
                  iconSize: 15,
                  icon: Icon(Icons.close, color: Colors.red),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                ),
              ),
            ],
          ),
          content: SizedBox(
            height: 120,
            width: MediaQuery.of(context).size.width - 40,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Form(
                  key: _formKey,
                  child: TextFormField(
                    controller: _variableController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      labelText: 'Variable Name',
                      prefixIcon:
                          const Icon(Icons.person, color: Colors.blueGrey),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Variable Name can not Empty';
                      }
                      if (value.contains(" ")) {
                        return 'Variable Name contains Space';
                      }
                      if (data[value] != null) {
                        return "Variable Name already exist with value ${data[value]}";
                      }
                      RegExp regExp = RegExp(r'[a-zA-Z][a-zA-Z0-9]*');
                      if (!regExp.hasMatch(value)) {
                        return "Variable name is invalid";
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  softWrap: true,
                  "Value : ${result}",
                  style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 15.sp),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 30),
                Container(
                  width: MediaQuery.of(context).size.width - 80,
                  child: ElevatedButton(
                    onPressed: () {
                      if (storVar()) {
                        Navigator.pop(context, true);
                      }
                    },
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.deepPurple),
                    ),
                    child: const Text(
                      'Save',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );

    if (confirmed ?? false) {}
  }

  void _showBackDialog() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Are you sure?'),
          content: const Text(
            'Are you sure you want to exit the app?',
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Nevermind'),
              onPressed: () => Navigator.pop(context, false),
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Exit'),
              onPressed: () => Navigator.pop(context, true),
            ),
          ],
        );
      },
    );

    if (confirmed ?? false) {
      SystemNavigator.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
        double fontSize = orientation == Orientation.portrait ? 20.sp : 10.sp;
        double resultFontSize =
            orientation == Orientation.portrait ? 17.sp : 8.sp;
        double buttonHeight = MediaQuery.of(context).size.height / 12;
        double buttonWidth = MediaQuery.of(context).size.width / 4;

        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.black,
            automaticallyImplyLeading: false,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  overflow: TextOverflow.ellipsis,
                  "Switch to Advance mode : ",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: fontSize,
                  ),
                ),
                Switch(
                  value: mode,
                  inactiveThumbColor: Colors.red,
                  inactiveTrackColor: Colors.white,
                  activeColor: Colors.white,
                  activeTrackColor: Colors.green,
                  onChanged: (bool value) {
                    if (value) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const AdvancePage()));
                    }
                  },
                ),
              ],
            ),
          ),
          backgroundColor: Colors.black,
          body: PopScope(
            canPop: false,
            onPopInvoked: (bool didPop) {
              if (didPop) {
                return;
              }
              _showBackDialog();
            },
            child: Column(
              mainAxisAlignment: (orientation == Orientation.portrait)
                  ? MainAxisAlignment.spaceBetween
                  : MainAxisAlignment.start,
              children: <Widget>[
                if (orientation == Orientation.portrait)
                  Container(
                    // color: Colors.amber,
                    height: 10,
                  ),
                Container(
                  // color: Colors.amber,
                  padding: (orientation == Orientation.portrait)
                      ? EdgeInsets.all(20)
                      : EdgeInsets.all(1),
                  alignment: Alignment.centerRight,
                  child: Text(
                    maxLines: fontSize == 20.sp ? 5 : 1,
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                    userInput,
                    style: TextStyle(color: Colors.white, fontSize: fontSize),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          // color: Colors.blueAccent,
                          padding: (orientation == Orientation.portrait)
                              ? EdgeInsets.all(20)
                              : EdgeInsets.all(1),
                          alignment: Alignment.centerRight,
                          child: Text(
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                            result,
                            style: TextStyle(
                                color: Colors.white, fontSize: resultFontSize),
                          ),
                        ),
                        if (clickResult)
                          IconButton(
                              color: Colors.white,
                              onPressed: () {
                                _showStartDialog();
                              },
                              icon: Icon(Icons.save)),
                      ],
                    ),
                    Divider(
                      color: Colors.white,
                    ),
                    Container(
                      padding: (orientation == Orientation.portrait)
                          ? EdgeInsets.all(5)
                          : EdgeInsets.all(1),
                      height: MediaQuery.of(context).size.height * 0.5,
                      child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: buttonWidth / buttonHeight,
                        ),
                        itemCount: buttons.length,
                        itemBuilder: (BuildContext context, int index) {
                          return CustomBut(buttons[index], buttonHeight);
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget CustomBut(String text, double buttonHeight) {
    return InkWell(
      hoverDuration: Duration(milliseconds: 200),
      splashColor: Colors.cyan,
      onTap: () {
        setState(() {
          handleCalc(text);
        });
      },
      child: Ink(
        decoration: BoxDecoration(
          color: getTextBgColor(text),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.white.withOpacity(0.2),
              blurRadius: 4,
              spreadRadius: 0.5,
              offset: Offset(-3, -3),
            ),
          ],
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
                fontSize: buttonHeight / 2,
                fontWeight: FontWeight.bold,
                color: getColor(text)),
          ),
        ),
      ),
    );
  }

  getColor(String text) {
    if (text == "/" ||
        text == "(" ||
        text == ")" ||
        text == "+" ||
        text == "x" ||
        text == "-" ||
        text == "DEL") {
      return Colors.orange;
    }
    return Colors.white;
  }

  getTextBgColor(String text) {
    if (text == "AC") {
      return Colors.orangeAccent;
    }
    if (text == "=") {
      return Colors.greenAccent;
    }

    return Colors.black;
  }

  handleCalc(String text) {
    if (text == "AC") {
      userInput = "";
      result = "0";
      setState(() {
        clickResult = false;
      });
      return;
    }
    if (text == "DEL") {
      if (userInput.isNotEmpty) {
        userInput = userInput.substring(0, userInput.length - 1);
        return;
      }
      return;
    }
    if (text == "=") {
      result = calculateEx();
      setState(() {
        clickResult = true;
      });
      if (result.endsWith(".0")) {
        result = result.replaceAll(".0", "");
      }
      return;
    }
    userInput = userInput + text;
  }

  String calculateEx() {
    try {
      var exp = Parser().parse(userInput.replaceAll("x", "*"));
      var eval = exp.evaluate(EvaluationType.REAL, ContextModel());
      return eval.toString();
    } catch (e) {
      showCustomSnackBar(context, e.toString());
      print(e.toString());
      return "Not valid !!!";
    }
  }
}

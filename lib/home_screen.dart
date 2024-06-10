import 'dart:convert';
// import 'dart:ffi';

import 'package:advacalc/advan_screen.dart';
import 'package:advacalc/snakbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  String result = "";
  Map<String, dynamic> data = {};
  bool mode = false;
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
    // TODO: implement initState
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
              const Text('Enter the Name of Variable : '),
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.red, width: 3),
                ),
                child: IconButton(
                  icon: Icon(Icons.close, color: Colors.red),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                ),
              ),
            ],
          ),
          content: SizedBox(
            height: 300,
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
                      if (data[value] != null) {
                        return "Variable Name already exist with value ${data[value]}";
                      }
                      return null;
                    },
                  ),
                )
              ],
            ),
          ),
          actions: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 30), // Add some space between buttons
                Container(
                  width: MediaQuery.of(context).size.width - 80,
                  // decoration: BoxDecoration(
                  //   color: Colors.green,
                  //   borderRadius: BorderRadius.circular(10),
                  // ),
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
            'Are you sure you want to exit the app?', // Clearer exit message
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Nevermind'),
              onPressed: () => Navigator.pop(context, false), // Cancel dialog
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Exit'),
              onPressed: () => Navigator.pop(context, true), // Exit app
            ),
          ],
        );
      },
    );

    if (confirmed ?? false) {
      SystemNavigator.pop(); // Exit the app using SystemNavigator.pop()
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: MediaQuery.of(context).size.height / 3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        "Switch to Advance mode : ",
                        style: TextStyle(fontSize: 20, color: Colors.white),
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
                  Container(
                    padding: EdgeInsets.all(20),
                    alignment: Alignment.centerRight,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Text(
                        userInput,
                        style: TextStyle(fontSize: 32, color: Colors.white),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Container(
                            padding: EdgeInsets.all(20),
                            alignment: Alignment.centerRight,
                            child: Text(
                              result,
                              style:
                                  TextStyle(fontSize: 40, color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                          iconSize: 40,
                          onPressed: () {
                            _showStartDialog();
                          },
                          icon: Icon(Icons.download)),
                    ],
                  ),
                ],
              ),
            ),
            Divider(
              color: Colors.white,
            ),
            Expanded(
              child: Container(
                  padding: EdgeInsets.all(10),
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12),
                    itemCount: buttons.length,
                    itemBuilder: (BuildContext context, int index) {
                      return CustomBut(buttons[index]);
                    },
                  )),
            )
          ],
        ),
      ),
    );
  }

  Widget CustomBut(String text) {
    return InkWell(
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
                fontSize: 30,
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
      Colors.greenAccent;
    }

    return Colors.black;
  }

  handleCalc(String text) {
    if (text == "AC") {
      userInput = "";
      result = "0";
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
      return e.toString();
    }
  }
}

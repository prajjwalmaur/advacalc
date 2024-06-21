import 'dart:convert';
import 'package:advacalc/bottom_nav.dart';
import 'package:advacalc/drawer.dart';
import 'package:advacalc/help_screen.dart';
import 'package:advacalc/snakbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdvancePage extends StatefulWidget {
  const AdvancePage({super.key});

  @override
  State<AdvancePage> createState() => _AdvancePageState();
}

class _AdvancePageState extends State<AdvancePage> {
  late SharedPreferences _pref;
  Map<String, dynamic> data = {};
  final TextEditingController _variableController = TextEditingController();
  final GlobalKey<FormState> _formKey2 = GlobalKey<FormState>();
  final TextEditingController _expController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  List<String> variables = [];
  String result = "";

  bool click = false;

  final Set<String> knownFunctions = {
    'π',
    'nrt',
    '!',
    'sqrt',
    'log',
    'cos',
    'sin',
    'tan',
    'arccos',
    'arcsin',
    'arctan',
    'abs',
    'ceil',
    'floor',
    'sgn',
    'ln',
    'e',
  };

  @override
  void initState() {
    super.initState();
    intialstep();
  }

  Future<void> intialstep() async {
    _pref = await SharedPreferences.getInstance();
    setState(() {
      data = jsonDecode(_pref.getString("data") ?? "{}");
    });
  }

  void calculatexp() {
    if (_formKey.currentState!.validate()) {
      Parser parser = Parser();

      try {
        // Parse the expression
        Expression expression = parser.parse(_expController.text);
        print("fs");

        // Define the variables in a context model
        ContextModel cm = ContextModel();
        for (var element in variables) {
          cm.bindVariable(
              Variable(element), Number(double.parse(data[element])));
        }
        setState(() {
          result = expression.evaluate(EvaluationType.REAL, cm).toString();
        });
      } catch (e) {
        showCustomSnackBar(context, e.toString());
      }
      // Evaluate the expression with the context model
    }
  }

  void _showStartDialog() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Enter the Name of Variable : ',
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
              Container(
                // width: 20,
                // height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.red, width: 2),
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
              children: [
                Form(
                  key: _formKey2,
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
                ),
                Text(
                  "Value : ${result}",
                  style: TextStyle(fontWeight: FontWeight.bold),
                  softWrap: true,
                ),
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

  bool storVar() {
    if (_formKey2.currentState!.validate()) {
      data[_variableController.text] = result;
      _pref.setString("data", jsonEncode(data));
      showCustomSnackBar(context, "Saved");
      return true;
    }
    return false;
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
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          softWrap: true,
          "Expression Calculator 🧮",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
        ),
      ),
      body: PopScope(
        canPop: false,
        onPopInvoked: (bool didPop) {
          if (didPop) {
            return;
          }
          _showBackDialog();
        },
        child: Container(
          padding: EdgeInsets.all(10),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 20,
                ),
                Container(
                  margin: EdgeInsets.all(10),
                  padding: EdgeInsets.all(10),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.blue, // Border color
                      width: 2, // Border width
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        softWrap: true,
                        "You can use following : ",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: const Color.fromARGB(255, 0, 0, 0)),
                      ),
                      Text(
                        softWrap: true,
                        "1. Numbers ",
                        style: TextStyle(
                            fontSize: 16,
                            color: const Color.fromARGB(255, 0, 0, 0)),
                      ),
                      Text(
                        softWrap: true,
                        "2. Variables names ",
                        style: TextStyle(
                            fontSize: 16,
                            color: const Color.fromARGB(255, 0, 0, 0)),
                      ),
                      Text(
                        softWrap: true,
                        "3. Operators ",
                        style: TextStyle(
                            fontSize: 16,
                            color: const Color.fromARGB(255, 0, 0, 0)),
                      ),
                      Text(
                        softWrap: true,
                        "4. Brackets: (), {} ",
                        style: TextStyle(
                            fontSize: 16,
                            color: const Color.fromARGB(255, 0, 0, 0)),
                      ),
                      Text(
                        softWrap: true,
                        "5. Function: log(), sin(), sqrt()...",
                        style: TextStyle(
                            fontSize: 16,
                            color: const Color.fromARGB(255, 0, 0, 0)),
                      ),
                      Text(
                        softWrap: true,
                        "E.g. : 2 * ( lenth + width ) ",
                        style: TextStyle(
                            fontSize: 16,
                            color: const Color.fromARGB(255, 0, 0, 0)),
                      ),
                      RichText(
                        text: new TextSpan(
                          children: [
                            new TextSpan(
                              text: 'You can also take ',
                              style: new TextStyle(color: Colors.black),
                            ),
                            new TextSpan(
                              text: 'Help.',
                              style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const HelpPage()),
                                  );
                                },
                            ),
                          ],
                        ),
                      ),
                      // ListTile(
                      //   leading:
                      //       const Icon(Icons.help_outline, color: Colors.white),
                      //   title: const Text(
                      //     'Help',
                      //     style: const TextStyle(
                      //         fontWeight: FontWeight.bold, color: Colors.white),
                      //   ),
                      //   onTap: () {
                      //     Navigator.push(
                      //       context,
                      //       MaterialPageRoute(
                      //           builder: (context) => const HelpPage()),
                      //     );
                      //   },
                      // ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  margin: EdgeInsets.all(10),
                  child: Form(
                    key: _formKey,
                    child: TextFormField(
                      controller: _expController,
                      keyboardType: TextInputType.multiline,
                      maxLines: null, // This makes the TextFormField expandable
                      decoration: InputDecoration(
                        labelText: 'Enter Expression',
                        prefixIcon:
                            const Icon(Icons.calculate, color: Colors.blueGrey),
                        filled: true,
                        fillColor: Colors.white,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: Colors
                                .blue, // Set border color when not focused
                            width: 2.0,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: Colors.blue, // Set border color when focused
                            width: 2.0,
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Expression can not be empty';
                        }
                        RegExp regExp = RegExp(r'[a-zA-Z]+');
                        Iterable<Match> matches = regExp.allMatches(value);

                        // Extract words from matches
                        List<String> words = [];
                        for (Match match in matches) {
                          if (!knownFunctions.contains(match.group(0)!)) {
                            words.add(match.group(0)!);
                          }
                        }

                        for (var i = 0; i < words.length; i++) {
                          if (data[words[i]] == null) {
                            return "${words[i]} is not defined";
                          }
                        }
                        setState(() {
                          variables = words;
                        });

                        return null;
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 10), // Add some space between buttons
                Container(
                  margin: EdgeInsets.all(10),
                  width: MediaQuery.of(context).size.width - 80,
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        click = true;
                      });
                      calculatexp();
                    },
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.deepPurple),
                    ),
                    child: const Text(
                      softWrap: true,
                      'Calculate',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                if (click)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            softWrap: true,
                            "Result: ",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                          Text(
                            softWrap: true,
                            result.endsWith(".0")
                                ? result.substring(0, result.length - 2)
                                : result,
                          ),
                        ],
                      ),
                      IconButton(
                          iconSize: 20,
                          onPressed: () {
                            _showStartDialog();
                          },
                          icon: Icon(Icons.download)),
                    ],
                  ),
                const SizedBox(height: 2),
                if (variables.length > 0)
                  Container(
                    margin: EdgeInsets.all(10),
                    child: Column(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width - 20,
                          child: Row(
                            children: [
                              Expanded(
                                child: Container(
                                  padding: EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    color: Colors.blue,
                                    border: Border(
                                      top: BorderSide(
                                          color: Color.fromARGB(
                                              255, 198, 198, 198),
                                          width: 4),
                                      left: BorderSide(
                                          color: Color.fromARGB(
                                              255, 198, 198, 198),
                                          width: 4),
                                      right: BorderSide(
                                          color: Color.fromARGB(
                                              255, 198, 198, 198),
                                          width: 4),
                                      bottom: BorderSide(
                                          color: Color.fromARGB(
                                              255, 198, 198, 198),
                                          width: 4),
                                    ),
                                    // borderRadius:
                                    //     BorderRadius.circular(12), // Rounded corners
                                  ),
                                  child: Center(
                                    child: Text(
                                      softWrap: true,
                                      "Vaiable",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  padding: EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    color: Colors.blue,
                                    border: Border(
                                      top: BorderSide(
                                          color: Color.fromARGB(
                                              255, 198, 198, 198),
                                          width: 4),
                                      // left: BorderSide(color: Color.fromARGB(255, 198, 198, 198), width: 4),
                                      right: BorderSide(
                                          color: Color.fromARGB(
                                              255, 198, 198, 198),
                                          width: 4),
                                      bottom: BorderSide(
                                          color: Color.fromARGB(
                                              255, 198, 198, 198),
                                          width: 4),
                                    ),
                                    // borderRadius:
                                    //     BorderRadius.circular(12), // Rounded corners
                                  ),
                                  child: Center(
                                    child: Text(
                                        softWrap: true,
                                        "Value",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15)),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        ...variables.map((key) {
                          dynamic value = data[key];
                          return Container(
                            width: MediaQuery.of(context).size.width - 20,
                            child: Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    padding: EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      border: Border(
                                        left: BorderSide(
                                            color: Color.fromARGB(
                                                255, 198, 198, 198),
                                            width: 4),
                                        right: BorderSide(
                                            color: Color.fromARGB(
                                                255, 198, 198, 198),
                                            width: 4),
                                        bottom: BorderSide(
                                            color: Color.fromARGB(
                                                255, 198, 198, 198),
                                            width: 4),
                                      ),
                                      // borderRadius:
                                      //     BorderRadius.circular(12), // Rounded corners
                                    ),
                                    child: Center(
                                      child: Text(
                                        softWrap: true,
                                        key,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    padding: EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      border: Border(
                                        // left: BorderSide(color: Color.fromARGB(255, 198, 198, 198), width: 4),
                                        right: BorderSide(
                                            color: Color.fromARGB(
                                                255, 198, 198, 198),
                                            width: 4),
                                        bottom: BorderSide(
                                            color: Color.fromARGB(
                                                255, 198, 198, 198),
                                            width: 4),
                                      ),
                                      // borderRadius:
                                      //     BorderRadius.circular(12), // Rounded corners
                                    ),
                                    child: Center(
                                      child: Text(
                                          softWrap: true,
                                          value.toString(),
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15)),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigation(),
      endDrawer: CustomDrawer(),
    );
  }
}

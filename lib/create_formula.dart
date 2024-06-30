import 'dart:convert';
import 'package:advacalc/bottom_nav.dart';
import 'package:advacalc/cal_formula.dart';
// import 'package:advacalc/cal_formula.dart';
import 'package:advacalc/drawer.dart';
import 'package:advacalc/help_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreateFormulaPage extends StatefulWidget {
  const CreateFormulaPage({super.key});

  @override
  State<CreateFormulaPage> createState() => _CreateFormulaPageState();
}

class _CreateFormulaPageState extends State<CreateFormulaPage> {
  late SharedPreferences _pref;
  final TextEditingController _expController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _instructionController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  List<String> variables = [];
  String expres = "";
  bool tryIt = false;

  @override
  void initState() {
    super.initState();
    intialstep();
  }

  Future<void> intialstep() async {
    _pref = await SharedPreferences.getInstance();
  }

  void extractVariables() {
    if (_formKey.currentState!.validate()) {
      expres = _expController.text;

      // Check if the expression is valid
      try {
        Parser parser = Parser();

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
        };
        RegExp regExp = RegExp(r'[a-zA-Z_][a-zA-Z0-9_]*');
        Iterable<Match> matches = regExp.allMatches(expres);

        // Extract words from matches and filter out known functions
        Set<String> words = matches
            .map((match) => match.group(0)!)
            .where((word) => !knownFunctions.contains(word))
            .toSet();

        setState(() {
          variables = words.toList();
        });

        expres = expres.replaceAll('e', '_');
        if (variables.contains('e')) {
          expres = expres.replaceAll(
              RegExp(r'(?<=[\s\+\-\*\/(]|^)_(?=[\s\+\-\*\/)]|$)'), 'e(1)');
          setState(() {
            variables.remove('e');
          });
          // print("hjghvhg");
        }
        if (variables.contains('PI')) {
          setState(() {
            variables.remove("PI");
          });
        }

        expres = expres.replaceAllMapped(RegExp(r'log\((\d+)\)'), (match) {
          return 'log(10,${match.group(1)})';
        });
        expres = expres.replaceAllMapped(RegExp(r'nrt\((\d+)\)'), (match) {
          return 'nrt(2,${match.group(1)})';
        });

        Expression exp = parser.parse(expres);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Invalid expression: ${e.toString()}")),
        );
      }
    }
  }

  void saveFormula() {
    if (variables.isNotEmpty) {
      Map<String, dynamic> formulaData = {
        "title": _titleController.text,
        "instruction": _instructionController.text,
        "exp": expres,
      };

      // Retrieve and update the formula list safely
      List<dynamic> myFormula =
          jsonDecode(_pref.getString("myFormula") ?? "[]");

      myFormula.add(formulaData);
      _pref.setString("myFormula", jsonEncode(myFormula));

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Formula saved successfully!")),
      );
      setState(() {
        expres = "";
        variables = [];
        _expController.clear();
        _titleController.clear();
        _instructionController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          softWrap: true,
          "Create Expression 📝",
          style: TextStyle(
              fontSize: 30, fontWeight: FontWeight.bold, color: Colors.blue),
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 20,
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _titleController,
                      decoration: InputDecoration(
                        labelText: 'Enter Title',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Title cannot be empty';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _instructionController,
                      decoration: InputDecoration(
                        labelText: 'Enter Instructions',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Instructions cannot be empty';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
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
                            "Take care of following things : ",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 0, 0, 0)),
                          ),
                          Text(
                            softWrap: true,
                            "1. Numbers ",
                            style: TextStyle(
                                fontSize: 16,
                                color: Color.fromARGB(255, 0, 0, 0)),
                          ),
                          Text(
                            softWrap: true,
                            "2. Variables names ",
                            style: TextStyle(
                                fontSize: 16,
                                color: Color.fromARGB(255, 0, 0, 0)),
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
                            "4. Parentheses brackets ( ) ",
                            style: TextStyle(
                                fontSize: 16,
                                color: const Color.fromARGB(255, 0, 0, 0)),
                          ),
                          Text(
                            softWrap: true,
                            "E.g. : 2 * ( lenth + width ) \nFor exponentiation: 2^3 which should result in 8 \nFor square root: sqrt(16) which should result in 4\nFor Modulus: abs(-5) which should result in 5\nFor subtraction: 5-2 which should result in 3\nFor multiplication: 3*4 which should result in 12\nFor division: 10/2 which should result in 5\nYou can also use sqrt, sin, cos, tan, log, etc.",
                            style: TextStyle(
                                fontSize: 14,
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
                                            builder: (context) =>
                                                const HelpPage()),
                                      );
                                    },
                                ),
                              ],
                            ),
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Note :  ",
                                style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold),
                              ),
                              Column(
                                children: [
                                  Text(
                                    "Please give space before",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                    softWrap: true,
                                  ),
                                  Text(
                                    "and after to Variable.",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                    softWrap: true,
                                  ),
                                  Text(
                                    "E.g : P * R * T ",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                    softWrap: true,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: _expController,
                      decoration: InputDecoration(
                        labelText: 'Enter Expression',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Expression cannot be empty';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: extractVariables,
                child: const Text('Extract Variables'),
              ),
              const SizedBox(height: 20),
              if (variables.isNotEmpty)
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
                            "Extracted Variables: ",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 0, 0, 0)),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: List.generate(variables.length, (i) {
                              return Text(
                                "${i + 1}. ${variables[i]}",
                                softWrap: true,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Color.fromARGB(255, 0, 0, 0),
                                ),
                              );
                            }),
                          ),
                          const SizedBox(height: 20),
                          if (!tryIt)
                            Center(
                              child: ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    tryIt = true;
                                  });
                                },
                                child: const Text(
                                  'Try it',
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          if (tryIt)
                            CalFormulaPage(
                                exp: _expController.text,
                                title: _titleController.text,
                                instuction: _instructionController.text),
                          const SizedBox(height: 20),
                          Center(
                            child: ElevatedButton(
                              onPressed: saveFormula,
                              child: const Text(
                                'Save Formula',
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ])),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigation(),
      endDrawer: CustomDrawer(),
    );
  }
}

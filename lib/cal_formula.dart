// import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:math_expressions/math_expressions.dart';

class CalFormulaPage extends StatefulWidget {
  const CalFormulaPage({
    super.key,
    required this.exp,
    required this.title,
    required this.instuction,
  });

  final String exp;
  final String title;
  final String instuction;

  @override
  State<CalFormulaPage> createState() => _CalFormulaPageState();
}

class _CalFormulaPageState extends State<CalFormulaPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late Map<String, TextEditingController> _controllers;
  bool click = false;
  String result = "";
  bool isCal = false;
  List<String> variables = [];

  @override
  void initState() {
    super.initState();
    extractVariables();
  }

  void extractVariables() {
    final Set<String> knownFunctions = {
      'sqrt',
      'sin',
      'cos',
      'tan',
      'log',
      'exp',
      'abs',
      'acos',
      'asin',
      'atan',
      'ceil',
      'cosh',
      'floor',
      'sinh',
      'tanh'
    };
    RegExp regExp = RegExp(r'[a-zA-Z_][a-zA-Z0-9_]*');
    Iterable<Match> matches = regExp.allMatches(widget.exp);

    // Extract words from matches and filter out known functions
    Set<String> words = matches
        .map((match) => match.group(0)!)
        .where((word) => !knownFunctions.contains(word))
        .toSet();

    setState(() {
      variables = words.toList();
    });
    _controllers = {
      for (var variable in variables) variable: TextEditingController()
    };
  }

  @override
  void dispose() {
    _controllers.forEach((key, controller) => controller.dispose());
    super.dispose();
  }

  void calculatexp() {
    if (_formKey.currentState!.validate()) {
      Parser parser = Parser();
      Expression expression;

      try {
        // Parse the expression
        expression = parser.parse(widget.exp);

        // Define the variables in a context model
        ContextModel cm = ContextModel();
        variables.forEach((variable) {
          // Ensure the value is not null or empty before parsing
          String? value = _controllers[variable]?.text;
          if (value != null && value.isNotEmpty) {
            cm.bindVariable(Variable(variable), Number(double.parse(value)));
          }
        });

        // Evaluate the expression with the context model
        setState(() {
          result = expression.evaluate(EvaluationType.REAL, cm).toString();
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error in expression: ${e.toString()}")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.blue, // Border color
          width: 4, // Border width
        ),
        borderRadius: BorderRadius.circular(10), // Rounded corners
      ),
      margin: EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              width: MediaQuery.of(context).size.width - 7,
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              padding: EdgeInsets.all(10),
              child: Text(
                widget.title,
                style: TextStyle(color: Colors.white, fontSize: 20),
                softWrap: true,
              )),
          const SizedBox(height: 5),
          Container(
            width: MediaQuery.of(context).size.width - 8,
            margin: EdgeInsets.all(15),
            child: Column(
              children: [
                Text(
                  "Formula used : ${widget.exp}",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                if (click) const SizedBox(height: 10),
                if (click) Text(widget.instuction),
                if (click) const SizedBox(height: 10),
                if (click)
                  Form(
                    key: _formKey,
                    child: Column(
                      children: variables.map((variable) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: TextFormField(
                            controller: _controllers[variable],
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: variable,
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return '$variable cannot be empty';
                              }
                              if (double.tryParse(value) == null) {
                                return '$variable must be a number';
                              }
                              return null;
                            },
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                if (click) const SizedBox(height: 30),
                if (click)
                  ElevatedButton(
                    onPressed: () {
                      calculatexp();
                      setState(() {
                        isCal = true;
                      });
                    },
                    child: const Text('Calculate'),
                  ),
                if (click) const SizedBox(height: 20),
                if (isCal)
                  Row(
                    children: [
                      const Text(
                        "Result: ",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Flexible(
                        child: Text(
                          result.endsWith(".0")
                              ? result.substring(0, result.length - 2)
                              : result,
                          softWrap: true,
                          overflow: TextOverflow.visible,
                        ),
                      ),
                    ],
                  ),
                if (!click)
                  SizedBox(
                    height: 10,
                  ),
                if (!click)
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        click = true;
                      });
                    },
                    child: const Text('Try it'),
                  ),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

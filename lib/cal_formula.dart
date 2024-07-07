// import 'dart:math';
import 'package:flutter/material.dart';
import 'dart:math' as math;
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
  List<String> lst = [];
  bool isDegree = false;

  @override
  void initState() {
    super.initState();
    extractVariables();
  }

  void extractVariables() {
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
    Iterable<Match> matches = regExp.allMatches(widget.exp);

    // Extract words from matches and filter out known functions
    Set<String> words = matches
        .map((match) => match.group(0)!)
        .where((word) => !knownFunctions.contains(word))
        .toSet();

    setState(() {
      variables = words.toList();
    });

    _controllers = {};

    for (var element in variables) {
      if (element != "e" && element != "PI") {
        lst.add(element);
        _controllers[element] = TextEditingController();
      }
    }
  }

  @override
  void dispose() {
    _controllers.forEach((key, controller) => controller.dispose());
    super.dispose();
  }

  Future<bool> _showTrignometry() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'For Trigonometric function: ',
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
                  icon: const Icon(Icons.close, color: Colors.red),
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
            child: const Column(
              children: [
                Text(
                  "In which unit You have entered all value ??",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
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
                const SizedBox(height: 20), // Add some space between buttons
                SizedBox(
                  width: MediaQuery.of(context).size.width - 80,
                  // decoration: BoxDecoration(
                  //   color: Colors.green,
                  //   borderRadius: BorderRadius.circular(10),
                  // ),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context, false);
                    },
                    style: ButtonStyle(
                      backgroundColor:
                          WidgetStateProperty.all(Colors.deepPurple),
                    ),
                    child: const Text(
                      'Radian',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 10), // Add some space between buttons
                SizedBox(
                  width: MediaQuery.of(context).size.width - 80,
                  // decoration: BoxDecoration(
                  //   color: Colors.green,
                  //   borderRadius: BorderRadius.circular(10),
                  // ),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context, true);
                    },
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(Colors.green),
                    ),
                    child: const Text(
                      'Degree',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );

    if (confirmed ?? false) {
      setState(() {
        isDegree = true;
      });
    } else {
      setState(() {
        isDegree = false;
      });
    }
    return false;
  }

  void calculatexp() async {
    if (_formKey.currentState!.validate()) {
      Parser parser = Parser();

      try {
        // Parse the expression
        ContextModel cm = ContextModel();
        cm.bindVariable(Variable('π'), Number(math.pi));
        String expres = widget.exp;

        if (expres.contains(RegExp(r'\b(sin|cos|tan|arccos|arcsin|arctan)\b',
            caseSensitive: false))) {
          await _showTrignometry();
        }

        if (expres
            .contains(RegExp(r'\b(cot|sec|csc)\b', caseSensitive: false))) {
          await _showTrignometry();

          expres = expres.replaceAllMapped(
              RegExp(r'cot\(([\da-zA-Z\s\+\*\-\/\(\)\{\}\^]+)\)'), (match) {
            return '(1 / tan(${match.group(1)} ))';
          });
          expres = expres.replaceAllMapped(
              RegExp(r'sec\(([\da-zA-Z\s\+\*\-\/\(\)\{\}\^]+)\)'), (match) {
            return '( 1 / cos(${match.group(1)}))';
          });
          expres = expres.replaceAllMapped(
              RegExp(r'csc\(([\da-zA-Z\s\+\*\-\/\(\)\{\}\^]+)\)'), (match) {
            return '( 1 / sin(${match.group(1)} )';
          });
        }

        if (isDegree) {
          expres = expres.replaceAllMapped(
              RegExp(r'sin\(([\da-zA-Z\s\+\*\-\/\(\)\{\}\^]+)\)'), (match) {
            return 'sin(${match.group(1)} * π / 180 )';
          });
          expres = expres.replaceAllMapped(
              RegExp(r'cos\(([\da-zA-Z\s\+\*\-\/\(\)\{\}\^]+)\)'), (match) {
            return 'cos(${match.group(1)} * π / 180 )';
          });
          expres = expres.replaceAllMapped(
              RegExp(r'tan\(([\da-zA-Z\s\+\*\-\/\(\)\{\}\^]+)\)'), (match) {
            return 'tan(${match.group(1)} * π / 180 )';
          });
          expres = expres.replaceAllMapped(
              RegExp(r'arccos\(([\da-zA-Z\s\+\*\-\/\(\)\{\}\^]+)\)'), (match) {
            return 'arccos(${match.group(1)} * π / 180 )';
          });
          expres = expres.replaceAllMapped(
              RegExp(r'arcsin\(([\da-zA-Z\s\+\*\-\/\(\)\{\}\^]+)\)'), (match) {
            return 'arcsin(${match.group(1)} * π / 180 )';
          });
          expres = expres.replaceAllMapped(
              RegExp(r'arctan\(([\da-zA-Z\s\+\*\-\/\(\)\{\}\^]+)\)'), (match) {
            return 'arctan(${match.group(1)} * π / 180 )';
          });
        }

        expres = expres.replaceAll('e', '_');
        if (variables.contains('e')) {
          expres = expres.replaceAll(
              RegExp(r'(?<=[\s\+\-\*\/(\^\{]|^)_(?=[\s\+\-\*\/)\^\}]|$)'),
              'e(1)');
          setState(() {
            variables.remove('e');
          });
          // print("hjghvhg");
        }
        if (variables.contains('PI')) {
          cm.bindVariable(Variable('PI'), Number(math.pi));
          setState(() {
            variables.remove("PI");
          });
        }

        expres = expres.replaceAllMapped(
            RegExp(r'log\(([\da-zA-Z\s\+\*\-\/\(\)\{\}\^]+)\)'), (match) {
          return 'log(10,${match.group(1)})';
        });
        expres = expres.replaceAllMapped(
            RegExp(r'nrt\(([\da-zA-Z\s\+\*\-\/\(\)\{\}\^]+)\)'), (match) {
          return 'nrt(2,${match.group(1)})';
        });

        for (var variable in variables) {
          // Ensure the value is not null or empty before parsing
          if (variable != 'e' && variable != "PI") {
            String? value = _controllers[variable]?.text;
            if (value != null && value.isNotEmpty) {
              cm.bindVariable(Variable(variable), Number(double.parse(value)));
            }
          }
        }

        Expression expression = parser.parse(expres);
        // Evaluate the expression with the context model
        setState(() {
          result = expression.evaluate(EvaluationType.REAL, cm).toString();
        });
      } catch (e) {
        // ignore: use_build_context_synchronously
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
      margin: const EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              width: MediaQuery.of(context).size.width - 7,
              decoration: const BoxDecoration(
                color: Colors.blue,
              ),
              padding: const EdgeInsets.all(10),
              child: Text(
                widget.title,
                style: const TextStyle(color: Colors.white, fontSize: 20),
                softWrap: true,
              )),
          const SizedBox(height: 5),
          Container(
            width: MediaQuery.of(context).size.width - 8,
            margin: const EdgeInsets.all(15),
            child: Column(
              children: [
                Text(
                  "Formula used : ${widget.exp}",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                  softWrap: true,
                ),
                if (click) const SizedBox(height: 10),
                if (click) Text(widget.instuction),
                if (click) const SizedBox(height: 10),
                if (click)
                  Form(
                    key: _formKey,
                    child: Column(
                      children: lst.map((variable) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: TextFormField(
                            controller: _controllers[variable],
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: variable,
                              border: const OutlineInputBorder(),
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
                  const SizedBox(
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
                const SizedBox(
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

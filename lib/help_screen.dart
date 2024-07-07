import 'package:advacalc/bottom_nav.dart';
import 'package:advacalc/drawer.dart';
import 'package:flutter/material.dart';

class HelpPage extends StatefulWidget {
  const HelpPage({super.key});

  @override
  State<HelpPage> createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
  final Map<String, List<String>> symbol = {
    "PI": ["π use for PI value 3.1415926..", "PI * 7^2\n= 153.938"],
    "x+a": ["For finding Addition of x to a", "7+2\n= 9"],
    "x-a": ["For finding Subtraction of x to a", "7-2\n= 5"],
    "x*a": ["For finding Multiplication x to a", "7*2\n= 14"],
    "x/a": ["For finding Division x to a", "7/2\n= 3.5"],
    "x^a": ["For finding x to power a", "7^2\n= 49"],
    'x!': ["For finding factorial of x", "5!\n = 120"],
    "π": ["π use for PI value 3.1415926..", "π * 7^2\n= 153.938"],
    "e": ["e use for Euler's Number 'e'..", "e\n= 2.718281828459045…"],
  };

  final Map<String, List<String>> data = {
    'log(x)': [
      "Logarithm of x to 10 base",
      "log of 1000 to base 10\nlog(1000)\n= 3"
    ],
    'ln(x)': [
      "Natural logarithm (logarithm to the base e)",
      "ln(2)\n= 0.693147"
    ],
    // 'e(x)': ["Euler's Number 'e' to power x", "e(1)\n = 2.718281828459045…"],
    'nrt(n,x)': [
      "For finding nth root of x",
      "Cube root of 64\nnrt(3, 64)\n= 4"
    ],
    'nrt(x)': [
      "For finding square root of x",
      "Square root of 16\nnrt(16)\n= 4"
    ],
    'sqrt(x)': ["For finding square root of x", "sqrt(64)\n=8"],
    'log(b,x)': [
      "Logarithm of x to 'b' base",
      "log of 64 to base 4\nlog(4,64)\n= 3"
    ],
    'cos(x)': ["Cosine function (or cos function)", "cos( π/3 )\n=0.5"],
    'sin(x)': ["Sine function", "sin( π/3 )\n= 0.86602"],
    'tan(x)': ["Tangent function", "tan( π/4 )\n= 1"],
    'arccos(x)': ["Inverse of the cosine function", "arccos( -1 )\n = π"],
    'arcsin(x)': [
      "Inverse of the sine function",
      "arcsin( 0.86602 )\n= 1.047186( π/3)"
    ],
    'arctan(x)': [
      "Inverse of tangent function",
      "arctan( 100 )\n= 1.5607966601082315"
    ],
    'abs(x)': ["Absolute value of x", "abs( -5)\n = 5"],
    'ceil(x)': [
      "Smallest integer greater than or equal to x",
      "ceil(3.2)\n= 4"
    ],
    'floor(x)': ["Greatest integer less than or equal to x", "floor(3.9)\n= 3"],
    'sgn(x)': [
      "Signum function has the value -1, +1 or 0 according to whether the sign of a given real number is positive or negative, or the given number is itself zero.",
      "sgn( -3.5)\n= -1"
    ],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          "Help 📂",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(10),
          child: Column(
            children: [
              const SizedBox(height: 20),
              Table(
                border: TableBorder.all(
                  color: const Color.fromARGB(255, 198, 198, 198),
                  width: 1,
                ),
                children: const [
                  TableRow(
                    decoration: BoxDecoration(color: Colors.blue),
                    children: [
                      Center(
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'Symbol',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: Colors.white),
                          ),
                        ),
                      ),
                      Center(
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'Description',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: Colors.white),
                          ),
                        ),
                      ),
                      Center(
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'Example',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: symbol.length,
                itemBuilder: (context, index) {
                  String key = symbol.keys.elementAt(index);
                  List<String> value = symbol[key]!;
                  return Table(
                    border: TableBorder.all(
                      color: const Color.fromARGB(255, 198, 198, 198),
                      width: 1,
                    ),
                    children: [
                      TableRow(
                        children: [
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                key,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                            ),
                          ),
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                value[0],
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                            ),
                          ),
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                value[1],
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 10),
              Table(
                border: TableBorder.all(
                  color: const Color.fromARGB(255, 198, 198, 198),
                  width: 1,
                ),
                children: const [
                  TableRow(
                    decoration: BoxDecoration(color: Colors.blue),
                    children: [
                      Center(
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'Function',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: Colors.white),
                          ),
                        ),
                      ),
                      Center(
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'Description',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: Colors.white),
                          ),
                        ),
                      ),
                      Center(
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'Example',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: data.length,
                itemBuilder: (context, index) {
                  String key = data.keys.elementAt(index);
                  List<String> value = data[key]!;
                  return Table(
                    border: TableBorder.all(
                      color: const Color.fromARGB(255, 198, 198, 198),
                      width: 1,
                    ),
                    children: [
                      TableRow(
                        children: [
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                key,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                            ),
                          ),
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                value[0],
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                            ),
                          ),
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                value[1],
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const BottomNavigation(),
      endDrawer: const CustomDrawer(),
    );
  }
}

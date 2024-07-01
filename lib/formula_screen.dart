import 'dart:convert';
import 'package:advacalc/bottom_nav.dart';
import 'package:advacalc/cal_formula.dart';
import 'package:advacalc/drawer.dart';
import 'package:advacalc/snakbar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';

class FormulaPage extends StatefulWidget {
  const FormulaPage({super.key});

  @override
  State<FormulaPage> createState() => _FormulaPageState();
}

class _FormulaPageState extends State<FormulaPage> {
  TextEditingController searchController = TextEditingController();
  String searchQuery = "";
  int no = 0;

  Future<void> loadMoreFormulas() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No internet connection')),
      );
      return;
    }

    final response = await http.get(Uri.parse(
        'https://meruprastaar.com/api/formula/formula.php?no=${no.toString()}'));
    if (response.statusCode == 200) {
      no += 1;
      List<dynamic> newFormulas = await jsonDecode(response.body);
      // print(newFormulas.toString());
      // print(newFormulas[0].toString());
      formulas.addAll(newFormulas);
      Iterable inReverse = formulas.reversed;

      setState(() {
        formulas = inReverse.toList();
      });
      // print(formulas);
    } else if (response.statusCode == 204) {
      showCustomSnackBar(context, "All formula downloaded");
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load formulas')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          "Formula Book 📖",
          softWrap: true,
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: 20),

          // SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(10),
            child: TextField(
              controller: searchController,
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
              decoration: InputDecoration(
                labelText: 'Search Formula',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: loadMoreFormulas,
            child: const Text('Load More Formula'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: formulas.length,
              itemBuilder: (context, index) {
                String title = formulas[index]["title"];
                if (title.toLowerCase().contains(searchQuery.toLowerCase())) {
                  return CalFormulaPage(
                    exp: formulas[index]["exp"],
                    title: title,
                    instuction: formulas[index]["instruction"],
                  );
                } else {
                  return Container(); // Return an empty container if it doesn't match
                }
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigation(),
      endDrawer: CustomDrawer(),
    );
  }

  List<dynamic> formulas = [
    {
      "title": "Parameter of Rectangle",
      "instruction": "All variables must have same unit",
      "exp": "2*(Length + Width)"
    },
    {
      "title": "Area of Rectangle",
      "instruction": "All variables must have same unit",
      "exp": "Length * Width"
    },
    {
      "title": "Perimeter of a Square",
      "instruction": "All variables must have same unit",
      "exp": " 4*  side"
    },
    {
      "title": "Area of a Square",
      "instruction": "All variables must have same unit",
      "exp": "side ^ 2"
    },
    {
      "title": "Area of a Rright angle Triangle",
      "instruction": "All variables must have same unit",
      "exp": "0.5 * base * height"
    },
    {
      "title": "Area of a Trapezoid",
      "instruction": "All variables must have same unit",
      "exp": "0.5 * ( base1 + base2 ) * heigth"
    },
    {
      "title": "Area of a Circle",
      "instruction": "All variables must have same unit",
      "exp": "PI * radius ^ 2"
    },
    {
      "title": "Circumference of a Circle",
      "instruction": "All variables must have same unit",
      "exp": "2 * PI * radius"
    },
    {
      "title": "Surface Area of a Cube",
      "instruction": "All variables must have same unit",
      "exp": "6 * side ^2"
    },
    {
      "title": "Curved surface area of a Cylinder",
      "instruction": "All variables must have same unit",
      "exp": "2 * PI * radius * height"
    },
    {
      "title": "Total surface area of a Cylinder",
      "instruction": "All variables must have same unit",
      "exp": "2 * PI * radius * ( radius + height )"
    },
    {
      "title": "Volume of a Cylinder",
      "instruction": "All variables must have same unit",
      "exp": "PI * radius ^ 2 * height"
    },
    {
      "title": "Curved surface area of a cone",
      "instruction": "All variables must have same unit",
      "exp": "PI * radius * lheight"
    },
    {
      "title": "Total surface area of a cone 1 ",
      "instruction": "All variables must have same unit",
      "exp": "PI * radius * ( radius + lheight)"
    },
    {
      "title": "Total surface area of a cone 2 ",
      "instruction": "All variables must have same unit",
      "exp": "PI * radius * (radius + sqrt ( h2 + r2 ) )"
    },
    {
      "title": "Volume of a Cone",
      "instruction": "All variables must have same unit",
      "exp": " 1/3 * PI * radius ^ 2 * height"
    },
    {
      "title": "Surface Area of a Sphere",
      "instruction": "All variables must have same unit",
      "exp": "4 * PI * radius ^2"
    },
    {
      "title": "Volume of a Sphere",
      "instruction": "All variables must have same unit",
      "exp": "4/3  * PI * radius ^ 3"
    },
    {
      "title": "Area of Ellipse",
      "instruction": "All variables must have same unit",
      "exp": "PI * a * b"
    },

    // Add more formulas here
  ];
}

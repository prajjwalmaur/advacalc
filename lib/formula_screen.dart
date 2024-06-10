import 'dart:convert';
import 'package:advacalc/bottom_nav.dart';
import 'package:advacalc/cal_formula.dart';
import 'package:advacalc/drawer.dart';
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
    // Add more formulas here
  ];

  Future<void> loadMoreFormulas() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No internet connection')),
      );
      return;
    }

    final response = await http
        .get(Uri.parse('https://meruprastaar.com/api/formula/formula.php'));
    if (response.statusCode == 200) {
      List<dynamic> newFormulas = jsonDecode(response.body);
      setState(() {
        formulas = newFormulas;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load formulas')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 20),
          const Text(
            "Formula Book 📖",
            softWrap: true,
            style: TextStyle(
                fontSize: 30, fontWeight: FontWeight.bold, color: Colors.blue),
          ),
          SizedBox(height: 20),
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
}
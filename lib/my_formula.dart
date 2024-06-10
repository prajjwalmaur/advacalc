import 'dart:convert';

import 'package:advacalc/bottom_nav.dart';
import 'package:advacalc/cal_formula.dart';
import 'package:advacalc/drawer.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyFormulaPage extends StatefulWidget {
  const MyFormulaPage({super.key});

  @override
  State<MyFormulaPage> createState() => _MyFormulaPageState();
}

class _MyFormulaPageState extends State<MyFormulaPage> {
  late SharedPreferences _pref;
  List<dynamic> formulas = [];
  TextEditingController searchController = TextEditingController();
  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    initialStep();
  }

  Future<void> initialStep() async {
    _pref = await SharedPreferences.getInstance();
    String formulaString = _pref.getString("myFormula") ?? "[]";
    setState(() {
      formulas = jsonDecode(formulaString);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          const Text(
            softWrap: true,
            "My Formula Book 📖",
            style: TextStyle(
                fontSize: 30, fontWeight: FontWeight.bold, color: Colors.blue),
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              controller: searchController,
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
              decoration: InputDecoration(
                labelText: 'Search',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: formulas.length,
              itemBuilder: (context, index) {
                var formula = formulas[index];
                String title = formula["title"];
                if (title.toLowerCase().contains(searchQuery.toLowerCase())) {
                  return CalFormulaPage(
                    exp: formula["exp"],
                    title: title,
                    instuction: formula["instruction"],
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

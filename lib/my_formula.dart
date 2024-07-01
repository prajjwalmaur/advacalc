import 'dart:convert';

import 'package:advacalc/bottom_nav.dart';
import 'package:advacalc/cal_formula.dart';
import 'package:advacalc/create_formula.dart';
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
    formulas = jsonDecode(formulaString);
    Iterable inReverse = formulas.reversed;

    setState(() {
      formulas = inReverse.toList();
    });
  }

  Future<void> deleteFormula(int index) async {
    setState(() {
      formulas.removeAt(index);
    });
    await _pref.setString("myFormula", jsonEncode(formulas));
  }

  Future<void> showDeleteConfirmationDialog(
      int index, String exp, String inst, String tit) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Formula'),
          content: Text('Are you sure you want to delete this formula?'),
          actions: <Widget>[
            TextButton(
              child: Text('Delete'),
              onPressed: () {
                deleteFormula(index);
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Edit'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CreateFormulaPage(
                            express: exp,
                            instruc: inst,
                            tit: tit,
                          )),
                );
              },
            ),
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          "My Formula Book 📖",
          softWrap: true,
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
        ),
      ),
      body: Column(
        children: [
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
                  return GestureDetector(
                    onLongPress: () => showDeleteConfirmationDialog(
                        index, formula["exp"], formula["instruction"], title),
                    child: CalFormulaPage(
                      exp: formula["exp"],
                      title: title,
                      instuction: formula["instruction"],
                    ),
                  );
                } else {
                  return Container(); // Return an empty container if it doesn't match
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const CreateFormulaPage(
                      express: "",
                      tit: "",
                      instruc: "",
                    )),
          );
        },
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigation(),
      endDrawer: CustomDrawer(),
    );
  }
}

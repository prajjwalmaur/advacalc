import 'dart:convert';

import 'package:advacalc/bottom_nav.dart';
import 'package:advacalc/drawer.dart';
import 'package:advacalc/snakbar.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorePage extends StatefulWidget {
  const StorePage({super.key});

  @override
  State<StorePage> createState() => _StorePageState();
}

class _StorePageState extends State<StorePage> {
  late SharedPreferences _pref;
  Map<String, dynamic> data = {};
  String searchQuery = "";

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

  Future<void> addVariable(String key, String value) async {
    setState(() {
      data[key] = value;
    });
    await _pref.setString("data", jsonEncode(data));
  }

  Future<void> updateVariable(String key, String newValue) async {
    setState(() {
      data[key] = newValue;
    });
    await _pref.setString("data", jsonEncode(data));
  }

  Future<void> deleteVariable(String key) async {
    setState(() {
      data.remove(key);
    });
    await _pref.setString("data", jsonEncode(data));
    showCustomSnackBar(context, "Deleted");
  }

  void _showAddVariableDialog() {
    final TextEditingController keyController = TextEditingController();
    final TextEditingController valueController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Variable'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: keyController,
                decoration: const InputDecoration(labelText: 'Variable Name'),
              ),
              TextField(
                controller: valueController,
                decoration: const InputDecoration(labelText: 'Value'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final String key = keyController.text;
                final String value = valueController.text;
                if (key.isNotEmpty && value.isNotEmpty) {
                  addVariable(key, value);
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _showUpdateVariableDialog(String key, dynamic value) {
    final TextEditingController valueController = TextEditingController();
    valueController.value = value;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Update Variable: $key'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: valueController,
                decoration: const InputDecoration(labelText: 'New Value'),
                keyboardType: TextInputType.number,
              ),
              // Text("Old value : $value")
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final String newValue = valueController.text;
                if (newValue.isNotEmpty) {
                  updateVariable(key, newValue);
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Update'),
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
          softWrap: true,
          "Stored Variabes 📦",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
        ),
      ),
      body: Container(
        margin: EdgeInsets.all(10),
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: TextField(
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
            Table(
              border: TableBorder.all(
                color: Color.fromARGB(255, 198, 198, 198),
                width: 2,
              ),
              children: [
                TableRow(
                  decoration: BoxDecoration(color: Colors.blue),
                  children: [
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Variable',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                      ),
                    ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Value',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                      ),
                    ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Actions',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Expanded(
              child: ListView(
                children: data.entries
                    .where((entry) => entry.key
                        .toLowerCase()
                        .contains(searchQuery.toLowerCase()))
                    .map((entry) {
                  String key = entry.key;
                  dynamic value = entry.value;
                  return Table(
                    border: TableBorder.all(
                      color: Color.fromARGB(255, 198, 198, 198),
                      width: 2,
                    ),
                    children: [
                      TableRow(
                        children: [
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                key,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                            ),
                          ),
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                value.toString(),
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                            ),
                          ),
                          Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.edit),
                                  onPressed: () {
                                    _showUpdateVariableDialog(key, value);
                                  },
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: () {
                                    deleteVariable(key);
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddVariableDialog,
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigation(),
      endDrawer: CustomDrawer(),
    );
  }
}

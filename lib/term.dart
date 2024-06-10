import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class TermPage extends StatefulWidget {
  const TermPage({super.key});

  @override
  State<TermPage> createState() => _TermPageState();
}

class _TermPageState extends State<TermPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Term and Conditions"),
      ),
      body: const Column(
        children: [
          Text("Last updated: 07-06-2024"),
          Text(
              "Please read these terms and conditions carefully before using Our Service."),
          Text(
            "Interpretation and Definitions",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text(
            "Interpretation",
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
          Text(
              "The words of which the initial letter is capitalized have meanings defined under the following conditions."),
          Text(
            "Definitions",
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
          Text('''For the purposes of these Terms and Conditions:

1. Company refers to PathWalla, Gachibowlli Hyderabad ( 500046 ).
2. Service refers to the Application.
3. You means the individual accessing or using the Service, or the company, or other legal entity on behalf of which such individual is accessing or using the Service, as applicable.'''),
        ],
      ),
    );
  }
}

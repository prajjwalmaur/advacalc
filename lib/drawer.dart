// import 'package:advacalc/contact_screen.dart';
import 'package:advacalc/create_formula.dart';
import 'package:advacalc/formula_screen.dart';
import 'package:advacalc/help_screen.dart';
import 'package:advacalc/my_formula.dart';
import 'package:advacalc/stored_data.dart';
import 'package:advacalc/term.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
// import 'package:shared_preferences/shared_preferences.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({Key? key}) : super(key: key);
  @override
  State<CustomDrawer> createState() => CustomDrawerState();
}

class CustomDrawerState extends State<CustomDrawer> {
  void _launchEmail() async {
    final Uri params = Uri(
      scheme: 'mailto',
      path: 'contact@meruprastaar.com',
      query:
          'subject=Contact to AdvaCalc&body=Hi there,', // Add subject and body if needed
    );
    if (await canLaunchUrl(params)) {
      await launchUrl(params);
    } else {
      throw 'Could not launch gmail';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          bottomLeft: Radius.circular(20.0),
        ),
      ),
      shadowColor: Colors.black87,
      backgroundColor: Color.fromARGB(255, 0, 0, 0),
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          SizedBox(
            height: 50,
          ),
          DrawerHeader(
            duration: Duration(seconds: 1),
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 255, 255, 255),
            ),
            child: Image.asset("assets/images/Advance.png"),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(children: [
                // ListTile(
                //   leading: const Icon(Icons.notifications),
                //   title: const Text('Notification'),
                //   onTap: () {
                //     Navigator.pop(context);
                //   },
                // ),
                // ListTile(
                //   leading: const Icon(Icons.settings),
                //   title: const Text('Setting'),
                //   onTap: () {
                //     Navigator.pop(context);
                //   },
                // ),
                ListTile(
                  leading: const Icon(Icons.storage, color: Colors.white),
                  title: const Text(
                    'Stored Varables',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const StorePage()),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.book, color: Colors.white),
                  title: const Text(
                    'My Formula',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const MyFormulaPage()),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.edit, color: Colors.white),
                  title: const Text(
                    'Create Formula',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  onTap: () {
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
                ),
                ListTile(
                  leading: const Icon(Icons.auto_stories, color: Colors.white),
                  title: const Text(
                    'Formulas',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const FormulaPage()),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.share, color: Colors.white),
                  title: const Text(
                    'Share APP',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  onTap: () {
                    Share.share('Check out my website https://pathwalla.com');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.help_outline, color: Colors.white),
                  title: const Text(
                    'Help',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const HelpPage()),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.phone, color: Colors.white),
                  title: const Text(
                    'Contact Us',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  onTap: _launchEmail,
                ),
                ListTile(
                  leading: const Icon(Icons.history, color: Colors.white),
                  title: const Text(
                    'Term and Conditions',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const TermPage()),
                    );
                  },
                ),
                // ListTile(
                //   leading: const Icon(Icons.logout, color: Colors.white),
                //   title: const Text(
                //     'Logout',
                //     style: const TextStyle(
                //         fontWeight: FontWeight.bold, color: Colors.white),
                //   ),
                //   onTap: () async {
                //     // await _prefs.remove("token");
                //     // Navigator.pushReplacement(
                //     //   context,
                //     //   MaterialPageRoute(
                //     //       builder: (context) => const LoginPage()),
                //     // );
                //   },
                // ),
              ]),
            ],
          ),
        ],
      ),
    );
  }
}

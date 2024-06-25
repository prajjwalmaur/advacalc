// import 'package:advacalc/bottom_nav.dart';
// import 'package:advacalc/drawer.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:emailjs/emailjs.dart' as emailjs;

// class ContactPage extends StatefulWidget {
//   @override
//   _ContactPageState createState() => _ContactPageState();
// }

// class _ContactPageState extends State<ContactPage> {
//   final _formKey = GlobalKey<FormState>();
//   final _nameController = TextEditingController();
//   final _emailController = TextEditingController();
//   final _subjectController = TextEditingController();
//   final _descriptionController = TextEditingController();
//   final _phoneController = TextEditingController();

//   Future<void> sendEmail({
//     required String from_name,
//     required String email_sender,
//     required String subject_sender,
//     required String message_sender,
//     String? from_phone,
//   }) async {
//     try {
//       await emailjs.send(
//         'service_26bubwh',
//         'template_v3op5pf',
//         {
//           'from_name': from_name,
//           'email_sender': email_sender,
//           'subject_sender': subject_sender,
//           'message_sender': message_sender,
//           'from_phone': from_phone ?? '',
//         },
//         const emailjs.Options(
//             publicKey: '6RgX1afl8XLUt-cUb',
//             privateKey: '3ozbjQk9CzY3xDWJoT71q',
//             limitRate: const emailjs.LimitRate(
//               id: 'app',
//               throttle: 10000,
//             )),
//       );
//       print('SUCCESS!');
//     } catch (error) {
//       if (error is emailjs.EmailJSResponseStatus) {
//         print('ERROR... $error');
//       }
//       print(error.toString());
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         title: Text(
//           'Contact Us 📡',
//           style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: ListView(
//             children: [
//               TextFormField(
//                 controller: _nameController,
//                 decoration: InputDecoration(labelText: 'Name'),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter your name';
//                   }
//                   return null;
//                 },
//               ),
//               TextFormField(
//                 controller: _emailController,
//                 decoration: InputDecoration(labelText: 'Email'),
//                 keyboardType: TextInputType.emailAddress,
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter your email';
//                   } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
//                     return 'Please enter a valid email';
//                   }
//                   return null;
//                 },
//               ),
//               TextFormField(
//                 controller: _subjectController,
//                 decoration: InputDecoration(labelText: 'Subject'),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter a subject';
//                   }
//                   return null;
//                 },
//               ),
//               TextFormField(
//                 controller: _descriptionController,
//                 decoration: InputDecoration(labelText: 'Description'),
//                 maxLines: 5,
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter a description';
//                   }
//                   return null;
//                 },
//               ),
//               TextFormField(
//                 controller: _phoneController,
//                 decoration: InputDecoration(labelText: 'Phone (Optional)'),
//                 keyboardType: TextInputType.phone,
//               ),
//               SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: () {
//                   if (_formKey.currentState?.validate() ?? false) {
//                     sendEmail(
//                       from_name: _nameController.text,
//                       email_sender: _emailController.text,
//                       subject_sender: _subjectController.text,
//                       message_sender: _descriptionController.text,
//                       from_phone: _phoneController.text.isNotEmpty
//                           ? _phoneController.text
//                           : null,
//                     );
//                   }
//                 },
//                 child: Text('Submit'),
//               ),
//             ],
//           ),
//         ),
//       ),
//       endDrawer: CustomDrawer(),
//       bottomNavigationBar: BottomNavigation(),
//     );
//   }

//   @override
//   void dispose() {
//     _nameController.dispose();
//     _emailController.dispose();
//     _subjectController.dispose();
//     _descriptionController.dispose();
//     _phoneController.dispose();
//     super.dispose();
//   }
// }

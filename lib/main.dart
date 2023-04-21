import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const appTitle = 'Login to Hectre';

    return MaterialApp(
      title: appTitle,
      home: Scaffold(
        appBar: AppBar(
          title: const Text(appTitle),
        ),
        body: const MyCustomForm(),
      ),
    );
  }
}

// Create a Form widget.
class MyCustomForm extends StatefulWidget {
  const MyCustomForm({super.key});

  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

// Create a corresponding State class.
// This class holds data related to the form.
class MyCustomFormState extends State<MyCustomForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a GlobalKey<FormState>,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();

  // Create a text controller and use it to retrieve the current value
  // of the TextField.
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: TextField(
              controller: usernameController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'User name',
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: TextField(
              controller: passwordController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Password',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: ElevatedButton(
              // onPressed: () {
              //   // Validate returns true if the form is valid, or false otherwise.
              //   if (_formKey.currentState!.validate()) {
              //     // If the form is valid, display a snackbar. In the real world,
              //     // you'd often call a server or save the information in a database.
              //     ScaffoldMessenger.of(context).showSnackBar(
              //       const SnackBar(content: Text('Processing Data')),
              //     );
              //   }

              //   showDialog(
              //     context: context,
              //     builder: (context) {
              //       return AlertDialog(
              //         // Retrieve the text the that user has entered by using the
              //         // TextEditingController.
              //         content: Text(usernameController.text + " " + passwordController.text),
              //       );
              //     },
              //   );
              // },
              onPressed: () async {
                      // Use a JSON encoded string to send
                final response = await http.post(
                  Uri.parse('https://jsonplaceholder.typicode.com/albums'),
                  headers: <String, String>{
                    'Content-Type': 'application/json; charset=UTF-8',
                  },
                  body: jsonEncode(<String, String>{
                    'title': "abc",
                  }),
                );

                if (response.statusCode == 201) {
                  _showDialog('Successfully signed in.');
                  print(jsonDecode(response.body));
                } else if (response.statusCode == 401) {
                  _showDialog('Unable to sign in.');
                  print(jsonDecode(response.body));
                } else {
                  _showDialog('Something went wrong. Please try again.');
                  print(jsonDecode(response.body));
                }
              },
              child: const Text('Login'),
            ),
          ),
        ],
      ),
    );
  }

  void _showDialog(String message) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(message),
        actions: [
          TextButton(
            child: const Text('OK'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }
}
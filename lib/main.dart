import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// void main() => runApp(const MyApp());
void main() {
  runApp(
    MaterialApp(
      title: 'Named Routes Demo',
      // Start the app with the "/" named route. In this case, the app starts
      // on the FirstScreen widget.
      initialRoute: '/',
      routes: {
        // When navigating to the "/" route, build the FirstScreen widget.
        '/': (context) => const MyApp(),
        // When navigating to the "/second" route, build the SecondRoute widget.
        '/second': (context) => const SecondRoute(),
      },
    ),
  );
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // @override
  // Widget build(BuildContext context) {
  //   const appTitle = 'Welcome to Hectre';

  //   return MaterialApp(
  //     title: appTitle,
  //     home: Scaffold(
  //       appBar: AppBar(
  //         title: const Text(appTitle),
  //       ),
  //       body: const MyCustomForm(),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome to Hectre'),
        automaticallyImplyLeading: false,
      ),
      body: const MyCustomForm(),
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

  Future<void> _login() async {

    final prefs = await SharedPreferences.getInstance();

    final response = await http.post(
      // NOTE: this return 201
      // Uri.parse('https://jsonplaceholder.typicode.com/albums'),
      // headers: <String, String>{
      //   'Content-Type': 'application/json; charset=UTF-8',
      // },
      // body: jsonEncode(<String, String>{
      // 'title': usernameController.text + " " + passwordController.text,
      // }),

      // NOTE: this return 200
      headers: <String, String>{
        "Content-Type": "application/x-www-form-urlencoded",
      },
      Uri.parse('https://develop-app.hectre.com/api/login'),
      encoding: Encoding.getByName('utf-8'),
      body: {
        "Email": usernameController.text,
        "Password": passwordController.text
      },
    );

    // if (response.statusCode == 201) {  // for jsonplaceholder.typicode.com
    if (response.statusCode == 200) { // for hectre login
      // _showDialog('Successfully signed in.');
      var responseBody = jsonDecode(response.body);
      print("responseBody: ");
      print(responseBody);
      if (responseBody["code"] == 0) {
          var token = responseBody["message"]["content"];
          print("token: ");
          print(token);
          await prefs.setString('token', token);
          // _showDialogMessageFromDisk(prefs);
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(builder: (context) => const SecondRoute()),
          // );
          // Navigate to the second screen using a named route.
          Navigator.pushNamed(context, '/second');
      } else {
         _showDialog(responseBody["message"]["content"]);
      }
      
    } else if (response.statusCode == 401) {
      print(jsonDecode(response.body));
      _showDialog('Unable to sign in.');
    } else {
      print(response.statusCode);
      print(jsonDecode(response.body));
      _showDialog('Something went wrong. Please try again.');
    }
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
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: Center(
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
                onPressed: _login,
                child: const Text('Login'),
              ),
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

  void _showDialogMessageFromDisk(SharedPreferences sharedPreferences) {
    var token = sharedPreferences.getString('token') ?? "There's no token in disk";

    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(token),
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

class SecondRoute extends StatelessWidget {
  const SecondRoute({super.key});

  @override
  Widget build(BuildContext context) {

    var items = List<String>.generate(10000, (i) => 'Item $i');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lot management'),
        automaticallyImplyLeading: false, // hide back button
        // leading: IconButton(
        //   onPressed: (){
        //     Navigator.pop(context);
        //   },
        //   icon:Icon(Icons.arrow_back_ios), 
        //   //replace with our own icon data.
        // )
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: items.length,
              prototypeItem: ListTile(
                title: Text(items.first),
              ),
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(items[index]),
                );
              },
            ),
          ),
          SizedBox(height: 50),
          SafeArea(
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: ElevatedButton(
                    onPressed: () {
                      // Navigate back to first route when tapped.
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const CreateLot()),
                      );
                    },
                    child: const Text('Create lot'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/');
                    },
                    child: const Text('Log out'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}



class CreateLot extends StatefulWidget {
  const CreateLot({super.key});

  @override
  State<CreateLot> createState() => _CreateLotState();
}

class _CreateLotState extends State<CreateLot> {

  final lotNameController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    lotNameController.dispose();
    super.dispose();
  }

  Future<void> _createLot() async {

    final response = await http.post(
      Uri.parse('https://jsonplaceholder.typicode.com/albums'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'title': lotNameController.text,
      }),
    );

    if (response.statusCode == 201) {
      // _showDialog('Successfully signed in.');
      var responseBody = jsonDecode(response.body);
      var token = responseBody["title"];
      print(responseBody);
      
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text("Create lot successfully"),
              actions: [
                TextButton(
                  child: const Text('OK then exit'),
                  onPressed: () => {
                    // Navigate to the second screen using a named route.
                    Navigator.pushNamed(context, '/second')
                  },
                ),
                TextButton(
                  child: const Text('Add other lot'),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            );
          },
        );

    } else if (response.statusCode == 401) {
      // _showDialog('Unable to sign in.');
      print(jsonDecode(response.body));
    } else {
      // _showDialog('Something went wrong. Please try again.');
      print(jsonDecode(response.body));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enter the information for new lot'),
        automaticallyImplyLeading: false, // hide back button
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: TextField(
              controller: lotNameController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter lot name',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: Center(
              child: ElevatedButton(
              //   onPressed: () => {
              //     print("aaa")}
              //   ,
                onPressed: _createLot,
                child: const Text('Create'),
              ),
            ),
          ),
          
        ],
      ),
    );
  }
}

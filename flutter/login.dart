import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_application_1/home.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _header(context),
                _inputField(context),
                _forgotPassword(context),
                _signup(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _header(context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 40), // Add margin to the bottom
      child: const Center(
        child: Column(
          children: [
            Text(
              "Be aware of any exposure",
              style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center, // Center the text
            ),
            Text("Enter your credentials to login"),
          ],
        ),
      ),
    );
  }

  _inputField(context) {
    return Column(
      
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: _usernameController,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            hintText: "Username",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide.none,
            ),
            fillColor: Theme.of(context).primaryColor.withOpacity(0.1),
            filled: true,
            prefixIcon: const Icon(Icons.person),
          ),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: _passwordController,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            hintText: "Password",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide.none,
            ),
            fillColor: Theme.of(context).primaryColor.withOpacity(0.1),
            filled: true,
            prefixIcon: const Icon(Icons.lock),
          ),
          obscureText: true,
        ),
        const SizedBox(height: 10),
        ElevatedButton(
         
          onPressed: () {
            print('Username: ${_usernameController.text}');
            print('Password: ${_passwordController.text}');
            _authenticateUser();
          },
          style: ElevatedButton.styleFrom(
            shape: const StadiumBorder(),
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
          child: const Text(
            "Login",
            style: TextStyle(fontSize: 20),
          ),
        )
      ],
    );
  }

  _forgotPassword(context) {
    return TextButton(
      onPressed: () {},
      child: const Text("Forgot password?"),
    );
  }

  _signup(context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Don't have an account? "),
        TextButton(
          onPressed: () {},
          child: const Text("Sign Up"),
        ),
      ],
    );
  }

  Future<void> _authenticateUser() async {
    final String username = _usernameController.text;
    final String password = _passwordController.text;

    const String apiUrl = 'http://192.168.1.106:3000/auth'; // Replace with your server URL

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        body: jsonEncode({
          'email': username,
          'password': password,
        }),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        // Authentication successful
        // Store user info locally using shared_preferences
        print('Response body: ${response.body}');
        _storeUserInfoLocally(username, response.body);
        _navigateToNextScreen();
        // Navigate to the next screen or perform other actions
        // For example, you can use Navigator to navigate to a new screen
        // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen()));
      } else {
        // Authentication failed
        // Handle the error, show a message, or perform other actions
        print('Authentication failed. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (error) {
      // Handle any network or server errors
      print('Error during authentication: $error');
    }
  }

  Future<void> _storeUserInfoLocally(String username, String body) async {
    try {
      Map<String, dynamic> parsedJson = json.decode(body);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('username', parsedJson['username']);
      prefs.setString('ID', parsedJson['_id']);
      prefs.setString('email', parsedJson['email']);
    } catch (e) {
      print('Error parsing JSON: $e');
    }
  }

  void _navigateToNextScreen() {
  // Use Navigator to navigate to the next screen
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Home()));
  }
}

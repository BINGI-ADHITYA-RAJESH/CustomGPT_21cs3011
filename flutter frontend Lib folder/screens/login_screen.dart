import 'package:flutter/material.dart';
import 'package:miners_app/screens/signup_screen.dart';
import 'package:miners_app/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Loginpage extends StatefulWidget {
  const Loginpage({super.key});

  @override
  State<Loginpage> createState() => _LoginpageState();
}

class _LoginpageState extends State<Loginpage> {
  final _formkey = GlobalKey<FormState>();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  bool islogin = false;


signInWithEmailAndPassword()async {try {
   await FirebaseAuth.instance.signInWithEmailAndPassword(
    email: _email.text,
    password: _password.text
  );
} on FirebaseAuthException catch (e) {
  if (e.code == 'user-not-found') {
    //
  } else if (e.code == 'wrong-password') {
     //
  }
   // ignore: use_build_context_synchronously
   ScaffoldMessenger.of(context).clearSnackBars();
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message ?? 'Authentication failed.'),
        ),
      );
}}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formkey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.all(2),
                    width: 300,
                    height: 200,
                    child: Image.asset('assets/images/gptlogo.png', fit: BoxFit.fill,),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  TextFormField(
                    controller: _email,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      icon: Icon(Icons.email),
                    ),
                    validator: (text) {
                      if (text == null || text.trim().isEmpty) {
                        return 'Email is empty';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _password,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      icon: Icon(Icons.security),
                    ),
                    validator: (text) {
                      if (text == null || text.trim().isEmpty) {
                        return 'Password is empty';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (_formkey.currentState!.validate()) {
                        signInWithEmailAndPassword();
                      }
                    },
                    child: const Text('Login',style: TextStyle(color: Color.fromARGB(255, 5, 144, 9)),),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const SignUppage()));
                        },
                        child: const Text('SignUp',style: TextStyle(color: Color.fromARGB(255, 5, 144, 9)),),
                      ),
                      const SizedBox(
                        width: 180,
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const Homepage()));
                        },
                        child: const Text('Skip for now',style: TextStyle(color: Color.fromARGB(255, 5, 144, 9)),),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignUppage extends StatefulWidget {
  const SignUppage({super.key});

  @override
  State<SignUppage> createState() => _SignUppageState();
}

class _SignUppageState extends State<SignUppage> {
  final _formkey = GlobalKey<FormState>();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  bool issignedin = false;

  createUserWithEmailAndPassword() async {
    try {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _email.text,
        password: _password.text,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        //
      } else if (e.code == 'email-already-in-use') {
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
    } catch (e) {//
    }
    setState(() {
      issignedin = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
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
                        labelText: 'Email', icon: Icon(Icons.email)),
                    validator: (text) {
                      if (text == null || text.trim().isEmpty) {
                        return 'Email is empty';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _password,
                    decoration: const InputDecoration(
                        labelText: 'Password', icon: Icon(Icons.security)),
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
                        createUserWithEmailAndPassword();
                        if(issignedin){
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('User Signed In')));
                        }
                      }
                    },
                    child: const Text('SignUp'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

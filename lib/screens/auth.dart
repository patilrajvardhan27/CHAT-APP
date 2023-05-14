import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

final _firebase = FirebaseAuth.instance;

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() {
    return _AuthScreenState();
  }
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  var _isLogin = true;
  var enteredEmail = '';
  var enterPassw = '';

  Future<void> _Submit() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    _formKey.currentState!.save();
    try {
      if (_isLogin) {
        final userCredentials = await _firebase.signInWithEmailAndPassword(
            email: enteredEmail, password: enterPassw);
      } else {
        final userCredentials = await _firebase.createUserWithEmailAndPassword(
            email: enteredEmail, password: enterPassw);
      }
    } on FirebaseAuthException catch (error) {
      if (error.code == 'email-already-in-use') {
        //...
      }
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.message ?? 'Authentication failed.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.only(
              top: 30,
              bottom: 20,
              left: 20,
              right: 20,
            ),
            width: 200,
            child: Image.asset('assets/chat.png'),
          ),
          Card(
            margin: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        decoration:
                            InputDecoration(labelText: 'Email Adderess'),
                        keyboardType: TextInputType.emailAddress,
                        autocorrect: false,
                        textCapitalization: TextCapitalization.none,
                        validator: (value) {
                          if (value == null ||
                              value.trim().isEmpty ||
                              !value.contains('@')) {
                            return 'Please enter a valid email address';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          enteredEmail = value!;
                        },
                      ),
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Password'),
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.trim().length < 6) {
                            return 'Password must be atleast 6 characters long';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          enterPassw = value!;
                        },
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      ElevatedButton(
                        onPressed: _Submit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.primaryContainer,
                        ),
                        child: Text(_isLogin ? 'Login' : 'Sign Up'),
                      ),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _isLogin = !_isLogin;
                          });
                        },
                        child: Text(_isLogin
                            ? 'Create an Account'
                            : 'I already have an acoount'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

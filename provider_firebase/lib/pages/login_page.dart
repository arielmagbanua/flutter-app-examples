import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // text editing controllers for the email and password
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // users collection reference
  final _usersRef = FirebaseFirestore.instance.collection('users');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  helperText: 'The email of the user',
                  border: OutlineInputBorder(),
                ),
                controller: _emailController,
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                keyboardType: TextInputType.text,
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
                obscuringCharacter: '*',
                decoration: const InputDecoration(
                  labelText: 'Password',
                  helperText: 'The password of the user',
                  border: OutlineInputBorder(),
                ),
                controller: _passwordController,
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () async {
                  await _loginWithEmailAndPassword(
                    _emailController.text,
                    _passwordController.text,
                  );
                },
                child: const Text('LOGIN'),
              ),
              ElevatedButton(
                onPressed: () {
                  // navigate to the register or signup page
                  // Navigator.of(context).pushNamed(
                  //   RegisterPage.routeName,
                  // );
                },
                child: const Text('SIGN-UP'),
              ),
              const SizedBox(height: 32.0),
              Text(
                'Supported Social Media Login',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16.0),
              ElevatedButton.icon(
                icon: const FaIcon(FontAwesomeIcons.google),
                label: const Text('SIGN-IN WITH GOOGLE'),
                onPressed: () async {
                  await _loginWithGoogle();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Login user using email and password.
  Future<UserCredential> _loginWithEmailAndPassword(
    String email,
    String password,
  ) {
    return FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  /// Login user using google account.
  Future<UserCredential> _loginWithGoogle() async {
    // trigger the authentication flow
    final googleUser = await GoogleSignIn().signIn();

    // obtain the auth details from the request
    final googleAuth = await googleUser?.authentication;

    // create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // once signed in, return the UserCredential
    final userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);

    // the data of the user
    final userDoc = <String, dynamic>{
      'name': userCredential.user!.displayName,
      'email': userCredential.user!.email,
    };

    // create a user doc to user collection
    _usersRef.doc(userCredential.user!.uid).set(
          userDoc,
          SetOptions(merge: true),
        );

    return userCredential;
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kisanseva/screen/dashboard.dart';
import 'package:kisanseva/screen/forgetPassword.dart';
import 'package:kisanseva/screen/registerpage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({ Key? key }) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailId = TextEditingController();
  final TextEditingController _password = TextEditingController();
  late SharedPreferences _prefs;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool load = true;

  _showToast(BuildContext context, String show) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: Text(show),
        action: SnackBarAction(label: 'Close', onPressed: scaffold.hideCurrentSnackBar),
      ),
    );
  }

  Future<void> _init() async {
    _prefs = await SharedPreferences.getInstance();

    if (_prefs.getString("user_id") != null) {
      Navigator.pushAndRemoveUntil(
        context, 
        MaterialPageRoute(builder: (context) => Dashboard(userId: _prefs.getString("user_id")!,)), 
        (route) => false
      );
    } else {
      if (this.mounted) {
        setState(() {
          load = false;
        });
      }
    }
  }

  buildShowDialog(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Center(
          child: CircularProgressIndicator(),
        );
      }
    );
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: load?Center(child: CircularProgressIndicator(),):
      SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Kisan Seva",
                style: TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.w800,
                  color: Colors.green
                ),
              ),
              const SizedBox(height: 25,),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      AutofillGroup(
                        child: TextFormField(
                          controller: _emailId,
                          autofillHints: const [AutofillHints.email],
                          keyboardType: TextInputType.text,
                          validator: (value) {
                            RegExp validateEmail = RegExp(r'\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}\b');
                            if (!validateEmail.hasMatch(_emailId.text)) {
                              return "Invalid Email!!!";
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            hintText: "xyz@gmail.com",
                            labelText: "Enter Email",
                          ),
                        ),
                      ),
                      TextFormField(
                        obscureText: true,
                        controller: _password,
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (_password.text.length <= 3) {
                            return "Invalid Password";
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          hintText: "******",
                          labelText: "Enter Password",
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: 100,
                height: 42,
                child: ElevatedButton(
                  child: const Text("Login"),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      try {
                        buildShowDialog(context);
                        UserCredential userCredential = await _auth.signInWithEmailAndPassword(email: _emailId.text, password: _password.text);
                        await _prefs.setString("user_id", userCredential.user!.uid);
                        
                        Navigator.pop(context);
                        Navigator.pushAndRemoveUntil(
                          context, 
                          MaterialPageRoute(builder: (context) => Dashboard(userId: userCredential.user!.uid,)), 
                          (route) => false
                        );
                      } on FirebaseAuthException catch (e) {
                        if (e.code == 'user-not-found') {
                          _showToast(context, "Email ID Not Found");
                        } else if (e.code == 'wrong-password') {
                          _showToast(context, 'Wrong password');
                        }
                      }
                      Navigator.pop(context);
                    }
                  },
                ),
              ),
              const SizedBox(height: 14,),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      child: const Text(
                        "Forgot Password",
                        style: TextStyle(
                          fontSize: 14
                        ),
                      ),
                      onTap: () => {
                        Navigator.push(
                          context, 
                          MaterialPageRoute(builder: (context) => ForgetPassword()),
                        )
                      },
                    ),
                    InkWell(
                      child: const Text(
                        "Register",
                        style: TextStyle(
                          fontSize: 14
                        ),
                      ),
                      onTap: () => {
                        Navigator.push(
                          context, 
                          MaterialPageRoute(builder: (context) => Register()),
                        )
                      },
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
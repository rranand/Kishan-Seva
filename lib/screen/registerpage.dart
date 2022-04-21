import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'loginPage.dart';

class Register extends StatefulWidget {
  const Register({ Key? key }) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _name = TextEditingController();
  final TextEditingController _emailId = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _passwordR = TextEditingController();
  final TextEditingController _phone = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  _showToast(BuildContext context, String show) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: Text(show),
        action: SnackBarAction(label: 'Close', onPressed: scaffold.hideCurrentSnackBar),
      ),
    );
  }

  buildShowDialog(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
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
                          controller: _name,
                          autofillHints: const [AutofillHints.name],
                          keyboardType: TextInputType.name,
                          validator: (value) {
                            if (_name.text.length <= 3) {
                              return "Invalid Name";
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            hintText: "Kisan Seva",
                            labelText: "Enter Name",
                          ),
                        ),
                      ),
                      AutofillGroup(
                        child: TextFormField(
                          controller: _emailId,
                          autofillHints: const [AutofillHints.email],
                          keyboardType: TextInputType.emailAddress,
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
                          if (_password.text.length <= 5) {
                            return "Password should be more than 5 letters";
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          hintText: "******",
                          labelText: "Enter Password",
                        ),
                      ),
                      TextFormField(
                        obscureText: true,
                        controller: _passwordR,
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (_passwordR.text.length <= 5) {
                            return "Password should be more than 5 letters";
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          hintText: "******",
                          labelText: "Repeat Password",
                        ),
                      ),
                      TextFormField(
                        controller: _phone,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (_phone.text.length != 10) {
                            return "Invalid Phone Number";
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          hintText: "1234567890",
                          labelText: "Enter Phone Number",
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
                  child: const Text("Register"),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      if (_password.text == _passwordR.text) {
                        try {
                          buildShowDialog(context);
                          UserCredential user = await _auth.createUserWithEmailAndPassword(email: _emailId.text, password: _password.text);
                          DatabaseReference ref = await FirebaseDatabase.instance.ref("Users/"+user.user!.uid.toString());
                          await ref.set({
                            "name": _name.text,
                            "password": _password.text,
                            "phone": _phone.text,
                            "email": _emailId.text
                          });
                          Navigator.pop(context);
                          _showToast(context, 'Registration Successful');
                          Navigator.pushAndRemoveUntil(
                            context, 
                            MaterialPageRoute(builder: (context) => Login()), 
                            (route) => false
                          );
                        } on FirebaseAuthException catch (e) {
                          Navigator.pop(context);
                          if (e.code == 'weak-password') {
                            _showToast(context, "Weak Password");
                            if (this.mounted) {
                              setState(() {
                                _password.text = "";
                                _passwordR.text = "";
                              });
                            }
                          } else if (e.code == 'email-already-in-use') {
                            Navigator.pop(context);
                            _showToast(context, 'Email Already Registered');
                          }
                        } catch (e) {
                          Navigator.pop(context);
                          _showToast(context, "Some Unknown Occurred");
                        }
                      } else {
                        _showToast(context, "Password do not match");
                        if (this.mounted) {
                          setState(() {
                            _password.text = "";
                            _passwordR.text = "";
                          });
                        }
                      }
                    }
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
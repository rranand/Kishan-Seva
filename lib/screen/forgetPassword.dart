import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kisanseva/screen/loginPage.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({ Key? key }) : super(key: key);

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailId = TextEditingController();
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
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: 140,
                height: 42,
                child: ElevatedButton(
                  child: const Text("Recover Password"),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      try {
                        await _auth.sendPasswordResetEmail(email: _emailId.text);
                        _showToast(context, "Password Resent Sent Successfully");
                        Navigator.pushAndRemoveUntil(
                          context, 
                          MaterialPageRoute(builder: (context) => Login()), 
                          (route) => false
                        );
                      } on FirebaseAuthException catch (e) {
                        if (e.code == 'user-not-found') {
                          _showToast(context, "Email ID Not Found");
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
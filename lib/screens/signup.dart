import 'package:flutter/material.dart';
import 'package:palets_app/components/rounded_button.dart';
import 'package:palets_app/components/rounded_input_field.dart';
import 'package:palets_app/components/rounded_password_field.dart';
import 'package:palets_app/models/company_model.dart';
import 'package:palets_app/services/database_helper.dart';

import '../constants.dart';
import '../main.dart';

class Signup extends StatefulWidget {
  final String type;
  final String phoneNumber;
  const Signup({Key? key, required this.type, required this.phoneNumber})
      : super(key: key);

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final isLoading = false;

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    final _name = TextEditingController();
    final _usernameController = TextEditingController();
    final _passwordController1 = TextEditingController();
    final _passwordController2 = TextEditingController();
    final _address1 = TextEditingController();
    final _address2 = TextEditingController();
    final _pin = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('SignUp'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: double.infinity,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 0, vertical: 5),
                child: widget.type == 'user'
                    ? Text(
                        "Personal Information",
                        style: TextStyle(
                          fontSize: 20,
                          color: kPrimaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    : Text(
                        "Company Information",
                        style: TextStyle(
                          fontSize: 20,
                          color: kPrimaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
              RoundedInputField(
                hintText:
                    widget.type == 'user' ? "Enter name" : "Enter Company name",
                onChanged: (value) {},
                username: _name,
              ),
              RoundedInputField(
                icon: Icons.location_city,
                hintText: "Enter Address1",
                onChanged: (value) {},
                username: _address1,
              ),
              RoundedInputField(
                icon: Icons.location_city,
                hintText: "Enter Address2",
                onChanged: (value) {},
                username: _address2,
              ),
              RoundedInputField(
                icon: Icons.pin,
                hintText: "Enter PIN Code",
                onChanged: (value) {},
                username: _pin,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Text(
                  "Login Information",
                  style: TextStyle(
                    fontSize: 20,
                    color: kPrimaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              RoundedInputField(
                hintText: "Enter Username",
                onChanged: (value) {},
                username: _usernameController,
              ),
              RoundedPasswordField(
                hintText: 'Enter Password',
                password: _passwordController1,
                onChanged: (value) {},
              ),
              RoundedPasswordField(
                hintText: 'Enter Password again',
                password: _passwordController2,
                onChanged: (value) {},
              ),
              RoundedButton(
                  child: isLoading
                      ? const SizedBox(
                          height: 14.0,
                          width: 14.0,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.0,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          "Submit",
                          style: TextStyle(color: Colors.white),
                        ),
                  press: () async {
                    if (_name.text == '' ||
                        _usernameController.text == '' ||
                        _passwordController1.text == '' ||
                        _passwordController2.text == '' ||
                        _address1.text == '' ||
                        _address2.text == '' ||
                        _pin.text == '') {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Fill all details"),
                        ),
                      );
                    } else if (_passwordController1.text !=
                        _passwordController2.text) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content:
                              Text("Password does not match, Please try again"),
                        ),
                      );
                    } else {
                      CompanyModel companyModel = CompanyModel(
                          name: _name.text,
                          phone: widget.phoneNumber,
                          address1: _address1.text,
                          address2: _address2.text,
                          pin: _pin.text);
                      await DatabaseHelper.instance.signUp(
                          companyModel: companyModel,
                          userName: _usernameController.text,
                          password: _passwordController2.text);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Signed up successfully"),
                        ),
                      );
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => MyHomePage()),
                          ModalRoute.withName('/'));
                    }
                  }),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:palets_app/components/rounded_button.dart';
import 'package:palets_app/components/rounded_input_field.dart';
import 'package:palets_app/screens/signup.dart';

class OtpPage extends StatelessWidget {
  const OtpPage({Key? key, required this.phoneNumber}) : super(key: key);
  final isLoading = false;
  final String phoneNumber;
  @override
  Widget build(BuildContext context) {
    String val = 'Single User';
    TextEditingController _usernameController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: const Text('SignUp In EasyDigits'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RoundedInputField(
              icon: Icons.confirmation_number,
              textType: TextInputType.phone,
              hintText: "Enter Received OTP",
              onChanged: (value) {},
              username: _usernameController,
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
                      "Verify OTP",
                      style: TextStyle(color: Colors.white),
                    ),
              press: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return StatefulBuilder(
                        builder: (context, setState) {
                          return AlertDialog(
                            title: Text("Select type of user"),
                            content: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Row(
                                  children: [
                                    Radio(
                                      value: 'Single User',
                                      groupValue: val,
                                      onChanged: (value) {
                                        setState(() {
                                          val = value.toString();
                                        });
                                      },
                                      activeColor: Colors.purple,
                                    ),
                                    const Text("Single User"),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Radio(
                                      value: 'Company',
                                      groupValue: val,
                                      onChanged: (value) {
                                        setState(() {
                                          val = value.toString();
                                        });
                                      },
                                      activeColor: Colors.purple,
                                    ),
                                    const Text("Company"),
                                  ],
                                ),
                              ],
                            ),
                            contentPadding: EdgeInsets.fromLTRB(24, 20, 24, 0),
                            actions: [
                              TextButton(
                                child: Text("Cancel"),
                                onPressed: () => Navigator.pop(context),
                              ),
                              TextButton(
                                child: Text("OK"),
                                onPressed: () {
                                  Navigator.pop(context);
                                  val == 'Company'
                                      ? Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => Signup(
                                                    type: 'company',
                                                    phoneNumber: phoneNumber,
                                                  )))
                                      : Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => Signup(
                                                    type: 'user',
                                                    phoneNumber: phoneNumber,
                                                  )));
                                },
                              ),
                            ],
                          );
                        },
                      );
                    });
              },
            ),
            TextButton(
              onPressed: () {},
              child: const Text("Didn't receive an OTP? Resend OTP"),
            ),
          ],
        ),
      ),
    );
  }
}

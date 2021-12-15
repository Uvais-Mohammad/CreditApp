import 'package:flutter/material.dart';
import 'package:palets_app/components/rounded_button.dart';
import 'package:palets_app/components/rounded_input_field.dart';
import 'otp_page.dart';

class MobileNumber extends StatelessWidget {
  const MobileNumber({Key? key}) : super(key: key);
  final isLoading = false;
  @override
  Widget build(BuildContext context) {
    TextEditingController _phoneNumberController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: const Text('SignUp In EasyDigits'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RoundedInputField(
              icon: Icons.phone_android,
              textType: TextInputType.phone,
              hintText: "Enter Mobile Number",
              onChanged: (value) {},
              username: _phoneNumberController,
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
                      "Receive OTP",
                      style: TextStyle(color: Colors.white),
                    ),
              press: () {
                if (_phoneNumberController.text == '') {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Enter valid Mobile Number"),
                    ),
                  );
                } else {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OtpPage(
                          phoneNumber: _phoneNumberController.text,
                        ),
                      ));
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

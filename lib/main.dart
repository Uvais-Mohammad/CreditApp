import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:palets_app/screens/home.dart';
import 'package:palets_app/screens/mobile_number_page.dart';
import 'package:palets_app/services/database_helper.dart';
import 'package:palets_app/services/user_simple_preferences.dart';
import 'components/rounded_button.dart';
import 'components/rounded_input_field.dart';
import 'components/rounded_password_field.dart';
import 'constants.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await UserSimplePreferences.init();
  bool isLoggedIn = await UserSimplePreferences.isLoggedIn();
  runApp(MyApp(isLoggedIn: isLoggedIn));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  const MyApp({Key? key, required this.isLoggedIn}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'EasyCredit',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        primaryColor: kPrimaryColor,
        scaffoldBackgroundColor: Colors.white,
      ),
      routes: {
        '/': (context) => isLoggedIn
            ? Home(
                index: 1,
              )
            : MyHomePage(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
  static var timeFormatter = DateFormat('KK:mm:a');
  static var dateFormatter = DateFormat('dd-MM-yyyy');
  static var dateFormatterSql = DateFormat('yyyy-MM-dd');
  static var currencyFormat = NumberFormat("###0.00#");
}

class _MyHomePageState extends State<MyHomePage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  List<Map<String, Object?>> user = [];
  bool isLoading = false;
  bool isCompanyNotExisting = false;

  Future<bool> isCompanyNotExist() async {
    return await DatabaseHelper.instance.isCompanyNotExist();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('EasyDigits'),
      ),
      body: Stack(alignment: Alignment.center, children: [
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              RoundedInputField(
                hintText: "Username",
                onChanged: (value) {},
                username: _usernameController,
              ),
              RoundedPasswordField(
                hintText: 'Password',
                password: _passwordController,
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
                          "LOGIN",
                          style: TextStyle(color: Colors.white),
                        ),
                  press: () async {
                    if (_usernameController.text == '' ||
                        _passwordController.text == '') {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Fill all the fields"),
                        ),
                      );
                    } else if (_usernameController.text != '' &&
                        _passwordController.text != '') {
                      setState(() {
                        isLoading = true;
                      });
                      user = await DatabaseHelper.instance.login(
                          _usernameController.text, _passwordController.text);
                      if (user.isNotEmpty) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Home(
                              index: 1,
                            ),
                          ),
                        );
                        await UserSimplePreferences.setLoggedIn();
                      } else {
                        setState(() {
                          isLoading = false;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Login failed"),
                          ),
                        );
                      }
                    }
                  }),
              FutureBuilder<bool>(
                future: isCompanyNotExist(),
                builder: (context, snapshot) {
                  if (snapshot.data == true) {
                    return TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const MobileNumber()));
                        },
                        child: Text("Don't you have an account? Signup"));
                  } else {
                    return SizedBox.shrink();
                  }
                },
              ),
            ],
          ),
        ),
        const Positioned(
          child: Text(
            "Powered by Palets Software Solutions",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: kPrimaryColor,
              letterSpacing: 0.5,
            ),
          ),
          bottom: 10,
          // left: MediaQuery.of(context).size.width / 9,
        )
      ]),
    );
  }
}

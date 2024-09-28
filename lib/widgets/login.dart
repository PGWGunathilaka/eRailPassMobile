import 'package:erailpass_mobile/common/salmonbar.dart';
import 'package:erailpass_mobile/common/textbox.dart';
import 'package:erailpass_mobile/common/toast.dart';
import 'package:erailpass_mobile/context/user_model.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;

import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  static const String _title = 'Log-in';

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController passwordController = TextEditingController();
  // String? _email = "passenger0@erailpass.com";
  // String? _password = "111111";
  String? _email;
  String? _password;

  // final bool _showError = false; // Initialize _showError to false

  bool allFieldsFilled() {
    bool isValid = _email != null && _password != null;
    if (!isValid) {
      showToast("Fill all fields");
    }
    return isValid;
  }

  login(BuildContext context) async {
    UserModel userModel = Provider.of<UserModel>(context, listen: false);
    bool success = await userModel.login(_email!, _password!);
    if (success) {
      if (!context.mounted) return;
      navigateToHome(context);
    }
  }
  
  void navigateToHome(BuildContext context) async {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (BuildContext context) => const SalmonBar()),
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: Login._title,
      home: Scaffold(
        appBar: AppBar(
          title: const Text(Login._title),
          backgroundColor: const Color(0xff16c2dc),
          leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () {
                Navigator.pop(context);
              }),
        ),
        body: Stack(
          children: [
            ImageFiltered(
                imageFilter: ui.ImageFilter.blur(sigmaX: 0.0, sigmaY: 0.0),
                child: ShaderMask(
                  shaderCallback: (rect) {
                    return LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.black.withOpacity(1.0), Colors.black.withOpacity(0.0)],
                        stops: const [0.1, 0.4]).createShader(rect);
                  },
                  blendMode: BlendMode.dstOut,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: Image.asset(
                      'images/Background.jpg',
                      fit: BoxFit.cover,

                      // width: double.infinity,
                    ),
                  ),
                )),
            const AspectRatio(
              aspectRatio: 5.0,
              child: Image(
                  image: AssetImage(
                'images/logo.png',
              )),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                  ),
                  padding: const EdgeInsets.only(top: 15, left: 15, right: 15, bottom: 10),
                  child: Column(
                    children: [
                      TextBoxWidget(
                        label: 'Email',
                        keyboardType: TextInputType.emailAddress,
                        onChanged: (String val) {
                          setState(() {
                            _email = val;
                          });
                        },
                      ),
                      TextBoxWidget(
                        label: 'Password',
                        hiddenText: true,
                        onChanged: (String val) {
                          setState(() {
                            _password = val;
                          });
                        },
                      ),
                      const Text.rich(
                        TextSpan(text: "" /*'*Incorrect mobile number or password * '*/, style: TextStyle(fontStyle: FontStyle.italic, color: Colors.red)),
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xff16c2dc),
                          ),
                          onPressed: allFieldsFilled()
                              ? () => login(context)
                              : null,
                          child: const Text('Submit'),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Forgot password?',
                          ),
                          TextButton(
                            onPressed: () {},
                            child: const Text(
                              'Reset password',
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

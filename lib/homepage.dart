import 'package:erailpass_mobile/widgets/available_trains.dart';
import 'package:erailpass_mobile/widgets/login.dart';
import 'package:erailpass_mobile/widgets/signup.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          ImageFiltered(
              imageFilter: ui.ImageFilter.blur(sigmaX: 0.0, sigmaY: 0.0),
              child: ShaderMask(
                shaderCallback: (rect) {
                  return LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(1.0),
                        Colors.black.withOpacity(0.0)
                      ],
                      stops: const [
                        0.1,
                        0.5
                      ]).createShader(rect);
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
          Container(
            padding: const EdgeInsets.only(top: 25.0),
            child: const AspectRatio(
              aspectRatio: 5.0,
              child: Image(
                  image: AssetImage(
                'images/logo.png',
              )),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8),
                ),
                padding: const EdgeInsets.only(top: 15),
                child: Column(
                  children: [
                    OutlinedButton(
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => const Login()));
                      },
                      style: OutlinedButton.styleFrom(
                        // primary: Colors.white,
                        backgroundColor: const Color(0xff209ef3),
                        textStyle: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                        ),
                        padding:
                            const EdgeInsets.symmetric(horizontal: 40, vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text('LOGIN'),
                    ),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Do not have account?',
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const SignUp()),
                              );
                            },
                            child: const Text(
                              'Sign up',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              OutlinedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AvailableTrainsPageOuter()),
                  );
                },
                style: OutlinedButton.styleFrom(
                    //primary: Colors.white,
                    backgroundColor: Colors.lightGreen,
                    textStyle: const TextStyle(
                      fontSize: 20,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    )),
                child: const Text('Check Available Trains'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class LanguageButton extends StatelessWidget {
  final String label;

  const LanguageButton({
    super.key,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () {},
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.black,
        backgroundColor: Colors.white.withOpacity(0.7),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
        side: const BorderSide(width: 3, color: Colors.black),
        //padding: EdgeInsets.all(16.0),
      ),
      child: Text(label),
    );
  }
}

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zoftcares_interview/services/api_service.dart';
import 'package:zoftcares_interview/services/storage_service.dart';
import 'package:zoftcares_interview/utils/dynamic_sizing.dart';
import 'package:zoftcares_interview/utils/snackbar.dart';
import 'package:zoftcares_interview/views/home_screen.dart';
import 'package:zoftcares_interview/widgets/button.dart';
import 'package:zoftcares_interview/widgets/textfield.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  Timer? logoutTimer;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    logoutTimer?.cancel();
    super.dispose();
  }

  void scheduleAutoLogout(int tokenValidity) {
    logoutTimer = Timer(Duration(milliseconds: tokenValidity), () async {
      final apiService = ApiService();
      await apiService.clearToken();
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => LoginScreen(),
          ),
          (route) => false);
      snackbar("Session expired. Please login again.", context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SizedBox(
        height: R.maxHeight(context),
        child: Column(
          children: [
            Image.asset(
              "assets/login.png",
              fit: BoxFit.cover,
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(
                    horizontal: R.rw(16, context), vertical: R.rh(24, context)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        'Welcome back!',
                        style: TextStyle(
                            fontSize: R.rw(34, context),
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Center(
                      child: Text(
                        'Log back into your account',
                        style: TextStyle(fontSize: R.rw(14, context)),
                      ),
                    ),
                    SizedBox(height: R.rh(24, context)),
                    TextfieldWidget(
                        textcontroller: emailController,
                        headText: "Email",
                        hinttext: "Enter your email"),
                    TextfieldWidget(
                        headText: "Password",
                        hinttext: "Enter password",
                        textcontroller: passwordController),
                    const Spacer(),
                    ButtonWidget(
                      text: "Login",
                      onpressed: () async {
                        if (emailController.text.isNotEmpty &&
                            passwordController.text.isNotEmpty) {
                          await ApiService()
                              .loginApi(
                                  emailController.text, passwordController.text)
                              .then((value) async {
                            if (value!.status == false) {
                              snackbar("Invalid Credentials", context);
                            } else {
                              // final prefs =
                              //     await SharedPreferences.getInstance();
                              // await prefs.setString('accessToken',
                              //     value.data!.accessToken.toString());
                              ref
                                  .read(storageProvider)
                                  .setToken(value.data!.accessToken.toString());
                              final tokenValidityTime = value.data!.validity;

                              scheduleAutoLogout(tokenValidityTime!);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => HomeScreen(
                                      token: value.data!.accessToken.toString(),
                                    ),
                                  ));
                            }
                          });
                        } else {
                          snackbar("Please fill all fields ", context);
                        }
                      },
                    ),
                    const Spacer(),
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        text:
                            'By creating or logging into an account you are agreeing with our ',
                        style: TextStyle(
                            fontSize: R.rw(13, context),
                            color: Colors.black,
                            fontWeight: FontWeight.w400),
                        children: const <TextSpan>[
                          TextSpan(
                              text: 'Terms and Conditions',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff0028FC))),
                          TextSpan(text: ' and '),
                          TextSpan(
                              text: "Privacy Policy.",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff0028FC)))
                        ],
                      ),
                    ),
                    const Spacer(),
                    Center(
                      child: ref.watch(versionProvider).when(
                            data: (data) {
                              return Text(
                                "Version: ${data!.data!.version.toString()}",
                                style: TextStyle(
                                  fontSize: R.rw(12, context),
                                  color: Colors.grey,
                                ),
                              );
                            },
                            error: (error, stackTrace) =>
                                Text("Error: ${error.toString()}"),
                            loading: () => const CircularProgressIndicator(),
                          ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

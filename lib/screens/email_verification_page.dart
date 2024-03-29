import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dating_app/model_classes/model_userlogin.dart';
import 'package:dating_app/screens/gender_check_page.dart';
import 'package:dating_app/utils/custom_color.dart';
import 'package:dating_app/utils/validation.dart';
import 'package:dating_app/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/login_provider.dart';

class EmailVerification extends StatefulWidget {
  const EmailVerification({Key? key}) : super(key: key);

  @override
  State<EmailVerification> createState() => _EmailVerificationState();
}

class _EmailVerificationState extends State<EmailVerification> {
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late TextEditingController confirmPasswordController;
  bool _isObscure = true;
  var globalKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();

  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios,
                color: CustomColors.headingTextFontColor,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              }),
        ),
        backgroundColor: CustomColors.appBarColor,
      ),
      body: SingleChildScrollView(
        child: Align(
          alignment: Alignment.topCenter,
          child: SafeArea(
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              height: MediaQuery.of(context).size.height * 0.9,
              child: Form(
                key: globalKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //  const SizedBox(height: 50,),
                    Text(
                      "Great!\nLets get you started…",
                      textAlign: TextAlign.start,
                      style: GoogleFonts.tinos(
                        textStyle: Theme.of(context).textTheme.headline4,
                        fontWeight: FontWeight.bold,
                        color: CustomColors.headingTextFontColor,
                      ),
                    ),
                    const SizedBox(
                      height: 150,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: CustomWidget.customTextField3(
                          titleName: 'Email',
                          context: context,
                          controller: emailController,
                          textInputType: TextInputType.emailAddress,
                          validate: (value) =>
                              ModelValidation.gmailValidation(value!)),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0, top: 8),
                      child: CustomWidget.customTextField3(
                        titleName: 'Password',
                        obscureText: _isObscure,
                        textInputType: TextInputType.visiblePassword,
                        controller: passwordController,
                        validate: (value) =>
                            ModelValidation.passwordValidation(value!),
                        context: context,
                        suffix: Padding(
                          padding: const EdgeInsets.only(right: 16.0),
                          child: IconButton(
                            icon: Icon(_isObscure
                                ? Icons.visibility_off
                                : Icons.visibility),
                            onPressed: () {
                              setState(() {
                                _isObscure = !_isObscure;
                                print('$_isObscure/////////////////');
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0, top: 8),
                      child: CustomWidget.customTextField3(
                        titleName: 'confirmPassword',
                        obscureText: _isObscure,
                        textInputType: TextInputType.visiblePassword,
                        controller: confirmPasswordController,
                        validate: (value) =>
                            ModelValidation.passwordValidation(value!),
                        context: context,
                        suffix: Padding(
                          padding: const EdgeInsets.only(right: 16.0),
                          child: IconButton(
                            icon: Icon(_isObscure
                                ? Icons.visibility_off
                                : Icons.visibility),
                            onPressed: () {
                              setState(() {
                                _isObscure = !_isObscure;
                                print('$_isObscure/////////////////');
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        if (globalKey.currentState!.validate()) {
                          var userLoginData = ModelUserLogin(
                              userName: emailController.text.trim(),
                              password: passwordController.text.trim());
                          LoginProviders.signUpWithEmail(
                              emailAddress: emailController.text.trim(),
                              password: passwordController.text.trim());

                          FirebaseFirestore.instance
                              .collection('user')
                              .doc(emailController.text.toString())
                              .set(userLoginData.toMap())
                              .then((value) {
                            return Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const GenderCheckPage(),
                                ));
                          });
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                                alignment: Alignment.center,
                                height: 50,
                                width: MediaQuery.of(context).size.width * 0.5,
                                decoration: BoxDecoration(
                                    color: CustomColors.buttonBackgroundColor,
                                    borderRadius: BorderRadius.circular(50),
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.black.withOpacity(0.06),
                                          offset: const Offset(
                                            0,
                                            2,
                                          ),
                                          spreadRadius: 3,
                                          blurRadius: 1),
                                    ]),
                                child: Text('Create Account',
                                    style:
                                        CustomColors.buttonTextStyle(context))),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

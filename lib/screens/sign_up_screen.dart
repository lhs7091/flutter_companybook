import 'package:flutter/material.dart';
import 'package:flutter_companybook/service/auth.dart';
import 'package:flutter_companybook/widgets/widgets.dart';
import 'package:flutter_companybook/screens/screens.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

  bool isLoading = false;

  AuthMethods authMethods = new AuthMethods();

  final formKey = GlobalKey<FormState>();
  TextEditingController usernameTextEditingController = new TextEditingController();
  TextEditingController emailTextEditingController = new TextEditingController();
  TextEditingController passwordTextEditingController = new TextEditingController();

  signMeUp(){
    if(formKey.currentState.validate()){
      setState(() {
        isLoading = true;
      });
      authMethods.signUpwithEmailAndPassword(emailTextEditingController.text, passwordTextEditingController.text).then((value){
        //print("${value.uid}");
        Navigator.push(context, MaterialPageRoute(
          builder: (context) => LoginScreen(),
        ));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Container(
              child: Center(child:CircularProgressIndicator()),
            )
          : SingleChildScrollView(
              child:  Container(
                height: MediaQuery.of(context).size.height,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [Colors.lightBlueAccent, Colors.purpleAccent]
                  ),
                ),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Form(
                        key: formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              validator: (val){
                                return val.isNotEmpty && val.length>2 ? null : "Please provide a valid username";
                              },
                              controller: usernameTextEditingController,
                              style: simpleTextFieldStyle(),
                              decoration: textFieldInputDecoration("USERNAME"),
                            ),
                            SizedBox(height: 10.0,),
                            TextFormField(
                              validator: (val){
                                return RegExp(
                                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                    .hasMatch(val) ? null: "Please provide a valid Email address";
                              },
                              controller: emailTextEditingController,
                              style: simpleTextFieldStyle(),
                              decoration: textFieldInputDecoration("EMAIL"),
                            ),
                            SizedBox(height: 10.0,),
                            TextFormField(
                              obscureText: true,
                              validator: (val){
                                return val.isNotEmpty && val.length>5 ? null : "Please provide a valid password";
                              },
                              controller: passwordTextEditingController,
                              style: simpleTextFieldStyle(),
                              decoration: textFieldInputDecoration("PASSWORD"),
                            ),
                            SizedBox(height: 20.0,),
                          ],
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerRight,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                          child: Text(
                            "Forgot Password?",
                            style: simpleTextFieldStyle(),
                          ),
                        ),
                      ),
                      SizedBox(height: 20.0,),
                      GestureDetector(
                        onTap: (){
                          signMeUp();
                        },
                        child: Container(
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.symmetric(vertical: 20.0),
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  colors: [
                                    const Color(0xff002EF4),
                                    const Color(0xff2A75BC)
                                  ]
                              ),
                              borderRadius: BorderRadius.circular(30.0)
                          ),
                          child: Text(
                            "Sign Up",
                            style: simpleTextFieldStyle(),
                          ),
                        ),
                      ),
                      SizedBox(height: 20.0,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Already have account?",
                            style: mediumTextFieldStyle(),
                          ),
                          SizedBox(width: 10.0,),
                          Text(
                            "Login now",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              decoration: TextDecoration.underline,
                            ),

                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}

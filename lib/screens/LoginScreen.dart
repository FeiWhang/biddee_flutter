import 'package:biddee_flutter/Firebase.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        brightness: Brightness.light,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 12),
              child: Image.asset(
                'assets/logo.png',
                width: 150,
                height: 150,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 78, 0, 32),
              child: Text(
                "Login to Biddee",
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 24,
                    decoration: TextDecoration.none),
              ),
            ),
            LoginForm(
                emailController: emailController,
                passwordController: passwordController),
            Container(
              margin: new EdgeInsets.only(top: 32, bottom: 54),
              child: LoginButton(
                emailController: emailController,
                passwordController: passwordController,
              ),
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: new EdgeInsets.only(right: 8),
                    child: Text(
                      "Not a member?",
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                  TextButton(
                    child: Text("Sign up",
                        style: TextStyle(
                            fontSize: 16,
                            color: Theme.of(context).primaryColorDark,
                            fontWeight: FontWeight.w400)),
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all<EdgeInsets>(
                          EdgeInsets.fromLTRB(16, 8, 16, 8)),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                            side: BorderSide(
                                color: Theme.of(context).primaryColorDark)),
                      ),
                    ),
                    onPressed: () => {Get.toNamed('/register')},
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;

  LoginForm({this.emailController, this.passwordController});

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  GlobalKey<FormState> _emailKey = new GlobalKey<FormState>();
  GlobalKey<FormState> _passKey = new GlobalKey<FormState>();
  FocusNode focusEmail = FocusNode();
  FocusNode focusPass = FocusNode();

  @override
  void initState() {
    super.initState();
    focusEmail.addListener(() => setState(() {}));
    focusPass.addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 32, bottom: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(48, 8, 48, 8),
            decoration: focusEmail.hasFocus
                ? BoxDecoration(
                    boxShadow: [
                        BoxShadow(
                            blurRadius: 2,
                            color: Theme.of(context).primaryColor)
                      ],
                    borderRadius:
                        const BorderRadius.all(const Radius.circular(18.0)))
                : null,
            child: Form(
              key: _emailKey,
              child: TextFormField(
                controller: widget.emailController,
                focusNode: focusEmail,
                keyboardType: TextInputType.emailAddress,
                decoration: new InputDecoration(
                  prefixIcon: Icon(Icons.email),
                  border: new OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(18.0),
                      ),
                      borderSide: BorderSide.none),
                  filled: true,
                  contentPadding: const EdgeInsets.fromLTRB(24, 12, 24, 12),
                  hintStyle: new TextStyle(color: Colors.grey[500]),
                  hintText: "Email",
                  fillColor: Theme.of(context).shadowColor,
                  enabledBorder: new OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(18.0),
                      ),
                      borderSide: BorderSide.none),
                ),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(48, 8, 48, 8),
            decoration: focusPass.hasFocus
                ? BoxDecoration(
                    boxShadow: [
                        BoxShadow(
                            blurRadius: 2,
                            color: Theme.of(context).primaryColor)
                      ],
                    borderRadius:
                        const BorderRadius.all(const Radius.circular(18.0)))
                : null,
            child: Form(
              key: _passKey,
              child: TextFormField(
                controller: widget.passwordController,
                focusNode: focusPass,
                obscureText: true,
                decoration: new InputDecoration(
                  prefixIcon: Icon(Icons.lock),
                  border: new OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(18.0),
                      ),
                      borderSide: BorderSide.none),
                  filled: true,
                  contentPadding: const EdgeInsets.all(16),
                  hintStyle: new TextStyle(color: Colors.grey[500]),
                  hintText: "Password",
                  fillColor: Theme.of(context).shadowColor,
                  enabledBorder: new OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(18.0),
                      ),
                      borderSide: BorderSide.none),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class LoginButton extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;

  LoginButton({this.emailController, this.passwordController});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      child: Text("Log in",
          style: TextStyle(
              fontSize: 16, color: Colors.white, fontWeight: FontWeight.w400)),
      style: ButtonStyle(
        padding: MaterialStateProperty.all<EdgeInsets>(
            EdgeInsets.fromLTRB(18, 10, 18, 10)),
        backgroundColor: MaterialStateColor.resolveWith(
            (states) => Theme.of(context).primaryColorDark),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
          ),
        ),
      ),
      onPressed: () {
        final res = AuthenticationService().logIn(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );
        res.then(
          (value) {
            if (value == "logedin") {
              Get.offAllNamed('/main');
            } else {
              Get.dialog(CupertinoAlertDialog(
                title: Text('Failed to log in'),
                content: Text(value),
                actions: [
                  TextButton(
                    child: Text('OK'),
                    onPressed: () {
                      Get.back();
                    },
                  ),
                ],
              ));
            }
          },
        );
      },
    );
  }
}

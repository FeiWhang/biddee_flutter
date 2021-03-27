import 'package:biddee_flutter/Firebase.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/route_manager.dart';

class RegisterScreen extends StatelessWidget {
  final TextEditingController fistNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

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
              padding: const EdgeInsets.only(bottom: 32),
              child: Text(
                "Register",
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 24,
                    decoration: TextDecoration.none),
              ),
            ),
            ResgisterForm(
              emailController: emailController,
              passwordController: passwordController,
              fistNameController: fistNameController,
              lastNameController: lastNameController,
              confirmPasswordController: confirmPasswordController,
            ),
            Container(
              margin: new EdgeInsets.only(top: 32, bottom: 48),
              child: RegisterButton(
                emailController: emailController,
                passwordController: passwordController,
                fistNameController: fistNameController,
                lastNameController: lastNameController,
                confirmPasswordController: confirmPasswordController,
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
                      "Already have an account?",
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                  TextButton(
                    child: Text("Log in",
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
                    onPressed: () => {Get.back()},
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ResgisterForm extends StatefulWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final TextEditingController fistNameController;
  final TextEditingController lastNameController;

  ResgisterForm(
      {this.emailController,
      this.passwordController,
      this.fistNameController,
      this.lastNameController,
      this.confirmPasswordController});

  @override
  _ResgisterFormState createState() => _ResgisterFormState();
}

class _ResgisterFormState extends State<ResgisterForm> {
  static GlobalKey<FormState> _emailKey = new GlobalKey<FormState>();
  static GlobalKey<FormState> _passKey = new GlobalKey<FormState>();
  static GlobalKey<FormState> _confirmPassKey = new GlobalKey<FormState>();
  static GlobalKey<FormState> _firstNameKey = new GlobalKey<FormState>();
  static GlobalKey<FormState> _lastNameKey = new GlobalKey<FormState>();

  FocusNode focusEmail = FocusNode();
  FocusNode focusPass = FocusNode();
  FocusNode focusConfirmPass = FocusNode();
  FocusNode focusFirstName = FocusNode();
  FocusNode focusLastName = FocusNode();

  @override
  void initState() {
    super.initState();

    focusEmail.addListener(() => setState(() {}));
    focusPass.addListener(() => setState(() {}));
    focusConfirmPass.addListener(() => setState(() {}));
    focusFirstName.addListener(() => setState(() {}));
    focusLastName.addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(48, 8, 48, 8),
            decoration: focusFirstName.hasFocus
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
              key: _firstNameKey,
              child: TextFormField(
                controller: widget.fistNameController,
                focusNode: focusFirstName,
                decoration: new InputDecoration(
                  prefixIcon: Icon(Icons.person),
                  border: new OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(18.0),
                      ),
                      borderSide: BorderSide.none),
                  filled: true,
                  contentPadding: const EdgeInsets.fromLTRB(24, 12, 24, 12),
                  hintStyle: new TextStyle(color: Colors.grey[500]),
                  hintText: "First name",
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
            decoration: focusLastName.hasFocus
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
              key: _lastNameKey,
              child: TextFormField(
                controller: widget.lastNameController,
                focusNode: focusLastName,
                decoration: new InputDecoration(
                  prefixIcon: Icon(Icons.person),
                  border: new OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(18.0),
                      ),
                      borderSide: BorderSide.none),
                  filled: true,
                  contentPadding: const EdgeInsets.fromLTRB(24, 12, 24, 12),
                  hintStyle: new TextStyle(color: Colors.grey[500]),
                  hintText: "Last name",
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
          Container(
            margin: const EdgeInsets.fromLTRB(48, 8, 48, 8),
            decoration: focusConfirmPass.hasFocus
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
              key: _confirmPassKey,
              child: TextFormField(
                controller: widget.confirmPasswordController,
                focusNode: focusConfirmPass,
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
                  hintText: "Confirm password",
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

class RegisterButton extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final TextEditingController fistNameController;
  final TextEditingController lastNameController;

  RegisterButton(
      {this.emailController,
      this.passwordController,
      this.fistNameController,
      this.lastNameController,
      this.confirmPasswordController});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      child: Text("Sign up",
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
        if (passwordController.text != confirmPasswordController.text) {
          print("Confirm password does not match password");
        } else {
          final resAuth = AuthenticationService().register(
              email: emailController.text.trim(),
              password: passwordController.text.trim());
          resAuth.then((authValue) {
            if (authValue == "registered") {
              final resDB = DatabaseService().addUser(
                firstName: fistNameController.text.trim(),
                lastName: lastNameController.text.trim(),
                email: emailController.text.trim(),
              );
              resDB.then((dbValue) => {
                    if (dbValue == "addedNewUser")
                      {Get.toNamed('/main')}
                    else
                      {print(dbValue)}
                  });
            } else {
              print(authValue);
            }
          });
        }
      },
    );
  }
}

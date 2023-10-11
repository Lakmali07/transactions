import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:transactions/views/transactions_view.dart';

import '../constants/constants.dart';
import '../widgets/form_text_field.dart';

class LoginView extends StatefulWidget {
  static const routeName = '/login';
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  final FocusNode _usernameFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _logBtnFocus = FocusNode();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _showPassword = false;

  @override
  void dispose() {
    _passwordFocus.dispose();
    _usernameFocus.dispose();
    _logBtnFocus.dispose();
    super.dispose();
  }

  _togglePasswordVisibility() {
    setState(() {
      _showPassword = !_showPassword;
    });
  }

  _validateAndLogin() {
    if (_formKey.currentState!.validate()) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => TransactionsView()),
          (Route<dynamic> route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 7,
                offset: Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          width: 400,
          height: 430,
          padding: const EdgeInsets.symmetric(vertical: 50.0, horizontal: 20.0),
          constraints: const BoxConstraints(),
          child: Form(
            key: _formKey,
            child: ListView(children: [
              FormTextField(
                  focusNode: _usernameFocus,
                  onFieldSubmitted: (_) =>
                      FocusScope.of(context).requestFocus(_passwordFocus),
                  controller: _usernameController,
                  obscureText: false, //Hiding text
                  inputType: 'none',
                  isRequired: true,
                  filled: true,
                  labelText:
                      'Username' //Used localization to define data in one place
                  ),
              const SizedBox(height: 20.0),
              FormTextField(
                controller: _passwordController,
                focusNode: _passwordFocus,
                onFieldSubmitted: (_) =>
                    FocusScope.of(context).requestFocus(_logBtnFocus),
                obscureText: !_showPassword,
                inputType: 'none',
                isRequired: true,
                function: _togglePasswordVisibility,
                filled: true,
                labelText: 'Password',
                suffixIcon: getPasswordSuffixIcon(
                    _togglePasswordVisibility, _showPassword),
              ),
              const SizedBox(height: 30.0),
              ButtonTheme(
                minWidth: 200.0,
                height: 50.0,
                // ignore: deprecated_member_use
                child: RawKeyboardListener(
                  focusNode: _logBtnFocus,
                  autofocus: true,
                  onKey: (RawKeyEvent event) async {
                    if (event is RawKeyDownEvent) {
                      if (event.isKeyPressed(LogicalKeyboardKey.enter) ||
                          event.isKeyPressed(LogicalKeyboardKey.numpadEnter)) {
                        _validateAndLogin();
                      }
                    }
                  },
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: CustomColors.buttonColor,
                          minimumSize: Size(400, 50)),
                      // color: CustomColors.buttonColor,
                      child: const Text('Login',
                          style: TextStyle(
                              color: CustomColors.buttonTextColor,
                              fontSize: 14)),
                      onPressed: () async {
                        _validateAndLogin();
                      }),
                ),
              ),
              // loginButton(context, _formKey, _bloc),
              //forgotPasswordText(context),
              const SizedBox(height: 20),
              // StreamBuilder<Response<Login>>(
              //   stream: _bloc.loginStream,
              //   builder: (context, snapshot) {
              //     if (snapshot.hasData) {
              //       switch (snapshot.data!.status) {
              //         case Status.LOADING:
              //           return Loading(loadingMessage: snapshot.data!.message);
              //         case Status.COMPLETED:
              //           _userDetailsBloc.getUserDetails();
              //           break;
              //         case Status.ERROR:
              //           return Error(
              //               errorMessage: snapshot.data!.message.toString());
              //         default:
              //           break;
              //       }
              //     }
              //     return Container();
              //   },
              // ),
            ]),
          ),
        ),
      ),
    );
  }
}

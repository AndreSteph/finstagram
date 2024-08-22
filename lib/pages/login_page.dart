import 'package:finstagram/services/firebase_service.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> {
  double? _deviceHeight, _deviceWidth;
  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();

  FirebaseService? _firebaseService;

  String? _email;
  String? _password;

  void initState() {
    super.initState();
    _firebaseService = GetIt.instance.get<FirebaseService>();
  }

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: _deviceWidth! * 0.05,
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _titleWidget(),
                _loginform(),
                _loginButton(),
                _registerPageLink(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _titleWidget() {
    return const Text(
      'Finstagram',
      style: TextStyle(
        color: Colors.black,
        fontSize: 25,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _loginform() {
    return SizedBox(
      height: _deviceWidth! * 0.02,
      child: Form(
        key: _loginFormKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _emailForm(),
            _passwordForm(),
          ],
        ),
      ),
    );
  }

  Widget _emailForm() {
    return TextFormField(
      decoration: const InputDecoration(hintText: "Email"),
      onSaved: (_value) {
        setState(() {
          _email = _value;
        });
      },
      validator: (_value) {
        bool _result = _value!.contains(
          RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
          ),
        );
        return _result ? null : "Please enter a valid email";
      },
    );
  }

  Widget _passwordForm() {
    return TextFormField(
      obscureText: true,
      decoration: const InputDecoration(hintText: "Password"),
      onSaved: (_value) {
        setState(() {
          _password = _value;
        });
      },
      validator: (_value) => _value!.length > 5
          ? null
          : "Please enter a password of atleast 6 characters",
    );
  }

  Widget _loginButton() {
    return MaterialButton(
      onPressed: _loginUser,
      minWidth: _deviceWidth! * 0.70,
      height: _deviceHeight! * 0.06,
      color: const Color.fromRGBO(244, 67, 54, 1),
      child: const Text(
        'Login',
        style: TextStyle(
          color: Colors.white,
          fontSize: 25,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _registerPageLink() {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, 'register'),
      child: const Text(
        "Don't have an account! Register",
        style: TextStyle(
          fontSize: 15,
          color: Color.fromARGB(255, 7, 65, 112),
          fontWeight: FontWeight.w200,
        ),
      ),
    );
  }

  void _loginUser() async {
    print(_loginFormKey.currentState!.validate());
    if (_loginFormKey.currentState!.validate()) {
      _loginFormKey.currentState!.save();

      bool _result = await _firebaseService!
          .loginUser(email: _email!, password: _password!);
      // print(_email);
      // print(_password);

      if (_result) Navigator.popAndPushNamed(context, 'home');
    }
  }
}

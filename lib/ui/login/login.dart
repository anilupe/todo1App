import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';

class Login extends StatefulWidget {
  @override
  _Login createState() => _Login();
}

class _Login extends State<Login> {
  String message = '';
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _passwordVisible = false;

  @override
  void initState() {
    super.initState();
    _passwordVisible = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color_fondo_screens,
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/fondo_screens.jpg'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        elevation: 0.0,
        backgroundColor: color_fondo_screens,
        leading: IconButton(
          icon: Image.asset(
            'assets/images/iconos/back.png',
            height: 30,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/fondo_screens.jpg"),
                    fit: BoxFit.cover,
                  ),
                ),
                child: _body())
          ],
        ),
      ),
    );
  }

  Widget _body() {
    return Column(
      children: [
        const SizedBox(height: 15.0),
        textSection(),
        Image.asset(
          "assets/images/logo.png",
          scale: 4,
        ),
      ],
    );
  }

  Widget textSection() {
    return Container(
      padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    S.of(context).username_text.toUpperCase(),
                    style: login_text_style,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15.0),
            Container(
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10.0),
                    topRight: Radius.circular(10.0),
                    bottomLeft: Radius.circular(10.0),
                    bottomRight: Radius.circular(10.0),
                  ),
                  color: Colors.white),
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                child: TextFormField(
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(40),
                  ],
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  cursorColor: Colors.black,
                  style: TextStyle(color: color_botones),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 25.0),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    S.of(context).password_text.toUpperCase(),
                    style: login_text_style,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15.0),
            Container(
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10.0),
                    topRight: Radius.circular(10.0),
                    bottomLeft: Radius.circular(10.0),
                    bottomRight: Radius.circular(10.0),
                  ),
                  color: Colors.white),
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                child: TextFormField(
                  controller: passwordController,
                  cursorColor: Colors.black,
                  obscureText: !_passwordVisible,
                  style: TextStyle(color: color_botones),
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      icon: Icon(
                        // Based on passwordVisible state choose the icon
                        _passwordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: color_botones,
                      ),
                      onPressed: () {
                        setState(() {
                          _passwordVisible = !_passwordVisible;
                        });
                      },
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                FlatButton(
                  child: Text(
                    S.of(context).olvido_contra_text,
                    style: talleres_body_text_style,
                  ),
                  onPressed: () {
                    _recuperarContrasena(emailController.text);
                  },
                )
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () => {
                    signIn_service(
                        emailController.text, passwordController.text),
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(10.0),
                          topRight: Radius.circular(10.0),
                          bottomLeft: Radius.circular(10.0),
                          bottomRight: Radius.circular(10.0),
                        ),
                        color: color_fondo),
                    width: 250.0,
                    height: 45.0,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 15.0, right: 10.0),
                      child: Text(
                        S.of(context).login_text.toUpperCase(),
                        style: login_text_style,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 35),
          ],
        ),
      ),
    );
  }

  signIn_service(String username, String password) async {
    if (username.isEmpty || password.isEmpty) {
      Fluttertoast.showToast(
          msg: username_pass_empty,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: color_botones.withOpacity(0.5),
          textColor: Colors.white);
    } else {
      username = username.trim().toLowerCase();
      password = password.trim();
      c_username = username = username.trim();
      c_password = password.trim();
      var encoded2 = Uri.encodeComponent(password);
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      var url = (urlServer +
          'customer/login?user=' +
          username +
          "&" +
          "password=" +
          encoded2);
      var response = await http.post(Uri.parse(url));
      var jsonResponse;
      var data;
      var userData;
      if (response.statusCode == 200) {
        jsonResponse = json.decode(utf8.decode(response.bodyBytes));
        data = jsonResponse['detailUser'];
        if (jsonResponse != null) {
          localStorage.setString('token', jsonResponse['token']);
          c_token = jsonResponse['token'];
          send_token_service(c_token);
          localStorage.setString(
              'detailUser', json.encode(jsonResponse['detailUser']));
          localStorage.setString('email', username.trim().toLowerCase());
          localStorage.setString('password', encoded2.trim());
          var userJson;
          userJson = localStorage.getString('detailUser');
          var user = json.decode(userJson);

          userData = user;
          c_id_customer = userData[0]['idCustomer'];
          c_fullName = userData[0]['name'] + " " + userData[0]['lastname'];
          c_email = userData[0]['username'];
          c_url_photo = data[0]['photo_url'];
          c_login = true;
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (BuildContext context) => const mainScreen()),
              (Route<dynamic> route) => false);
        } else {
          Fluttertoast.showToast(
              msg: response.body,
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: color_botones.withOpacity(0.9),
              textColor: color_fondo);
        }
      } else {
        Fluttertoast.showToast(
            msg: username_pass_error,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: color_botones.withOpacity(0.9),
            textColor: color_fondo);
      }
    }
  }

  void _recuperarContrasena(String username) async {
    if (username.isEmpty) {
      Fluttertoast.showToast(
          msg: S.of(context).repit_email_text,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: color_botones.withOpacity(0.5),
          textColor: Colors.white);
    } else {
      username = username.trim();
      var url = (urlServer + 'users/reset?email=' + username);
      var response = await http
          .post(Uri.parse(url), headers: {"Content-Type": "application/json"});
      var jsonResponse;
      var data;
      var userData;
      if (response.statusCode == 200) {
        jsonResponse = json.decode(response.body);

        Fluttertoast.showToast(
            msg: S.of(context).revisar_correo_text,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: color_botones.withOpacity(0.9),
            textColor: color_fondo);
      } else {
        Fluttertoast.showToast(
            msg: S.of(context).error_text,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: color_botones.withOpacity(0.9),
            textColor: color_fondo);

        Navigator.pop(context);
      }
    }
  }
}

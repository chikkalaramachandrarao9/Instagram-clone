import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:insta/services/auth_service.dart';
import 'package:insta/screens/shared/loading.dart';

class Register extends StatefulWidget {
  final Function toggleView;
  Register({this.toggleView});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _auth = AuthService();

  final _formKey = GlobalKey<FormState>();

  bool _loading = false;

  String error = '';

  String email = '';

  String password = '';

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        title: Text(
          'Register',
          style: TextStyle(color: Colors.black),
        ),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: FlatButton.icon(
              color: Colors.grey[300],
              icon: Icon(Icons.person),
              label: Text('Signin'),
              onPressed: () => widget.toggleView(),
            ),
          ),
        ],
      ),
      body: _loading
          ? spinkit
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  child: Image.asset('images/logo.jpg'),
                ),
                Container(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: 20.0),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            decoration: InputDecoration(
                              hintText: 'Email',
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.black, width: 1.0)),
                              filled: true,
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.lime, width: 2.0),
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                            ),
                            validator: (val) =>
                                val.isEmpty ? 'Enter an email' : null,
                            onChanged: (val) {
                              setState(() => email = val);
                            },
                          ),
                        ),
                        SizedBox(height: 20.0),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            decoration: InputDecoration(
                              hintText: 'Password',
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.black, width: 1.0)),
                              filled: true,
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.lime, width: 2.0),
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                            ),
                            obscureText: true,
                            validator: (val) => val.length < 6
                                ? 'Enter a password 6+ chars long'
                                : null,
                            onChanged: (val) {
                              setState(() => password = val);
                            },
                          ),
                        ),
                        SizedBox(height: 20.0),
                        RaisedButton(
                            color: Colors.lime[400],
                            child: Text(
                              'Register',
                              style: TextStyle(color: Colors.black),
                            ),
                            onPressed: () async {
                              if (_formKey.currentState.validate()) {
                                setState(() {
                                  _loading = true;
                                });
                                dynamic result =
                                    await _auth.register(email, password);
                                if (result == null) {
                                  setState(() {
                                    _loading = false;
                                    error = 'Invalid Credintials';
                                  });
                                }
                              }
                            }),
                        SizedBox(height: 12.0),
                        Text(
                          error,
                          style: TextStyle(color: Colors.red, fontSize: 14.0),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}

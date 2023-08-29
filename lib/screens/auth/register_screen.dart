import 'package:flutter/material.dart';
import 'package:dientes_sanos/services/auth_service.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  String _email = '', _password = '', _name = '', _lastName = '';

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      await AuthService().signUp(
          email: _email, password: _password, name: _name, lastName: _lastName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TextFormField(
            decoration: InputDecoration(labelText: 'Name'),
            validator: (value) =>
                value!.isEmpty ? 'Name can\'t be empty' : null,
            onSaved: (value) => _name = value!.trim(),
          ),
          TextFormField(
            decoration: InputDecoration(labelText: 'Last Name'),
            validator: (value) =>
                value!.isEmpty ? 'Last Name can\'t be empty' : null,
            onSaved: (value) => _lastName = value!.trim(),
          ),
          TextFormField(
            decoration: InputDecoration(labelText: 'Email'),
            validator: (value) =>
                value!.isEmpty ? 'Email can\'t be empty' : null,
            onSaved: (value) => _email = value!.trim(),
          ),
          SizedBox(height: 16),
          TextFormField(
            decoration: InputDecoration(labelText: 'Password'),
            obscureText: true,
            validator: (value) =>
                value!.length < 6 ? 'Password too short' : null,
            onSaved: (value) => _password = value!,
          ),
          SizedBox(height: 24),
          ElevatedButton(
            onPressed: _submitForm,
            child: Text('Register'),
          ),
        ],
      ),
    );
  }
}

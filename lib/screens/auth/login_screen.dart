import 'package:flutter/material.dart';
import 'package:dientes_sanos/services/auth_service.dart';
import 'package:dientes_sanos/screens/pacient/main_screen.dart'; // Asegúrate de importar la pantalla de la cámara.

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String _email = '', _password = '';

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      var user = await AuthService().signIn(email: _email, password: _password);

      // Verificar si el usuario ha iniciado sesión exitosamente.
      if (user != null) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => MainScreen(),
        ));
      } else {
        // Mostrar un mensaje de error.
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Login failed. Please try again.'),
          ),
        );
      }
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
            child: Text('Login'),
          ),
        ],
      ),
    );
  }
}

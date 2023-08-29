// main.dart
import 'package:flutter/material.dart';
import 'package:dientes_sanos/screens/auth/auth_screen.dart';

import 'package:dientes_sanos/screens/auth/login_screen.dart';
import 'package:dientes_sanos/screens/auth/register_screen.dart';
import 'package:dientes_sanos/screens/pacient/historial_screen.dart'; // Asegúrate de importar la pantalla de la cámara.

import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final FirebaseOptions options = FirebaseOptions(
      apiKey: "AIzaSyDZUZmbinbDrR5Jw1_0mo7nWj2WA1eHdYI",
      authDomain: "dientes-sanos.firebaseapp.com",
      projectId: "dientes-sanos",
      storageBucket: "dientes-sanos.appspot.com",
      messagingSenderId: "873353839538",
      appId: "1:873353839538:web:72c71914e556076e0adaab");

  await Firebase.initializeApp(options: options);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Clínica Dental',
      initialRoute: '/',
      routes: {
        '/': (context) => AuthScreen(),
        '/register': (context) => RegisterScreen(),
        '/login': (context) => LoginScreen(),
        '/historial': (context) => HistorialScreen(),

        // Agregar más rutas aquí a medida que crees más pantallas
      },
    );
  }
}

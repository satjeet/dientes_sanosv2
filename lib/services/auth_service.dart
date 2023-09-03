// auth_service.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

final CollectionReference users =
    FirebaseFirestore.instance.collection('usuarios');

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> signUp(
      {required String email,
      required String password,
      required String name,
      required String lastName}) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      await users.doc(userCredential.user!.uid).set({
        'email': email,
        'name': name,
        'lastName': lastName,
        'role': 'paciente', // Rol predeterminado
        // Otros campos relevantes pueden ir aquí
      });
      // Guarda el token FCM después del registro exitoso
      await saveFCMToken(userCredential.user!.uid);
      return userCredential.user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<User?> signIn(
      {required String email, required String password}) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      // Guarda el token FCM después del registro exitoso
      await saveFCMToken(userCredential.user!.uid);
      return userCredential.user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<void> saveFCMToken(String uid) async {
    String? token = await FirebaseMessaging.instance.getToken();
    if (token != null) {
      await users.doc(uid).update({
        'token': token,
      });
    }
  }

  Stream<User?> get user => _auth.authStateChanges();
}

import 'package:flutter/material.dart';
import 'dart:html' as html;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:typed_data';
import 'package:dientes_sanos/screens/pacient/historial_screen.dart'; // Asegúrate de importar la pantalla de la cámara.

class CameraScreen extends StatefulWidget {
  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Tomar Fotografía")),
      body: Center(child: Text("Haz clic en el botón para tomar una foto")),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.camera),
        onPressed: () {
          // Create an input element that allows capture from camera
          final input = html.FileUploadInputElement()..accept = 'image/*';
          input.click();

          // Listen to the change event. This occurs when an image is captured
          input.onChange.listen((event) async {
            final files = input.files;
            if (files!.length == 1) {
              final file = files[0];
              final reader = html.FileReader();

              reader.readAsArrayBuffer(file);
              reader.onLoadEnd.listen((event) async {
                // Convert NativeUint8List to Uint8List
                final buffer = (reader.result as List<int>).sublist(0);
                final uint8list = Uint8List.fromList(buffer);

                // Upload the image to Firebase Storage
                final user = FirebaseAuth.instance.currentUser;

                if (user != null) {
                  final ref = FirebaseStorage.instance
                      .ref()
                      .child('usuarios')
                      .child(user.uid)
                      .child(DateTime.now().toIso8601String() + ".jpg");

                  await ref.putData(uint8list);

                  // Once the upload is complete, get the URL
                  final url = await ref.getDownloadURL();

                  // Save the reference in Firestore
                  await FirebaseFirestore.instance
                      .collection('usuarios')
                      .doc(user.uid)
                      .collection('cepillados')
                      .doc()
                      .set({
                    'imageUrl': url,
                    'timestamp': FieldValue.serverTimestamp(),
                  });

                  // Optionally, navigate to another screen or show a success message
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Imagen guardada con éxito!')));
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => HistorialScreen()));
                }
              });
            }
          });
        },
      ),
    );
  }
}

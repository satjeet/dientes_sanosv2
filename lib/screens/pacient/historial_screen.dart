import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HistorialScreen extends StatefulWidget {
  @override
  _HistorialScreenState createState() => _HistorialScreenState();
}

class _HistorialScreenState extends State<HistorialScreen> {
  late Stream<QuerySnapshot> _historialStream;
  final user = FirebaseAuth.instance.currentUser!;

  @override
  void initState() {
    super.initState();

    if (user != null) {
      _historialStream = FirebaseFirestore.instance
          .collection('usuarios')
          .doc(user.uid)
          .collection('cepillados')
          .snapshots();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Historial de Imágenes")),
      body: (user == null)
          ? Center(child: Text("Por favor, inicia sesión primero."))
          : StreamBuilder<QuerySnapshot>(
              stream: _historialStream,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                final documentos = snapshot.data!.docs;
                return ListView.builder(
                  itemCount: documentos.length,
                  itemBuilder: (context, index) {
                    final imageUrl = documentos[index]['imageUrl'] as String?;
                    return ListTile(
                      leading: (imageUrl != null)
                          ? Image.network(imageUrl)
                          : Icon(Icons.image),
                      title: Text('Imagen ${index + 1}'),
                    );
                  },
                );
              },
            ),
    );
  }
}

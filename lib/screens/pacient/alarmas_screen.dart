import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:dientes_sanos/services/notification_manager.dart';

class AlarmasScreen extends StatefulWidget {
  @override
  _AlarmasScreenState createState() => _AlarmasScreenState();
}

class _AlarmasScreenState extends State<AlarmasScreen> {
  TimeOfDay selectedTime = TimeOfDay.now();
  List<TimeOfDay> alarms = []; // Aquí se almacenarán las alarmas

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final NotificationManager _notificationManager = NotificationManager();

  _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  Future<void> _addAlarmToFirestore(TimeOfDay time) async {
    // Verifica si el usuario está autenticado
    if (_auth.currentUser != null) {
      String uid = _auth.currentUser!.uid;

      // Crea una nueva alarma en Firestore
      CollectionReference alarmas =
          _firestore.collection('usuarios').doc(uid).collection('alarmas');

      await alarmas.add({
        'hora': time.format(context),
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Alarmas")),
      body: Column(
        children: [
          ListTile(
            title:
                Text('Hora del recordatorio: ${selectedTime.format(context)}'),
            trailing: Icon(Icons.arrow_drop_down),
            onTap: () {
              _selectTime(context);
            },
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                alarms.add(selectedTime);
              });
              _addAlarmToFirestore(selectedTime); // Agregar alarma a Firestore
            },
            child: Text('Agregar Alarma'),
          ),
          ElevatedButton(
            onPressed: () {
              _notificationManager.requestPermission();
            },
            child: Text('Permitir notificaciones'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: alarms.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                      'Alarma ${index + 1}: ${alarms[index].format(context)}'),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      setState(() {
                        alarms.removeAt(index);
                      });
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

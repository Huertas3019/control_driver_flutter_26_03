import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final db = FirebaseFirestore.instance;
  final platforms = ['Uber', 'Didi', 'Cabify', 'Particular'];

  print('Sembrando plataformas...');
  for (final name in platforms) {
    await db.collection('platforms').doc(name.toLowerCase()).set({
      'name': name,
    });
    print('Agregada: $name');
  }
  print('¡Proceso completado!');
}

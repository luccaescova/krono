import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Salvar ou atualizar os dados do utilizador no Firestore usando o UID do Auth como ID do documento
  Future<void> criarPerfilUtilizador({
    required String uid,
    required String nome,
    required String email,
    required String dataNascimento,
  }) async {
    await _db.collection('users').doc(uid).set({
      'nome': nome,
      'email': email,
      'dataNascimento': dataNascimento,
      'createdAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';

abstract class VistoriaServiceBase {
  Future<List<Map<String, dynamic>>> loadVistorias();
  Future<void> addVistoria(Map<String, dynamic> vistoria);
  Future<void> updateVistoria(String id, Map<String, dynamic> novaVistoria);
  Future<void> deleteVistoria(String id);
}

class VistoriaService implements VistoriaServiceBase {
  static final _collection = FirebaseFirestore.instance.collection('vistorias');

  @override
  Future<List<Map<String, dynamic>>> loadVistorias() async {
    final snapshot = await _collection.get();
    return snapshot.docs.map((doc) {
      final data = doc.data();
      data['id'] = doc.id;
      return data;
    }).toList();
  }

  @override
  Future<void> addVistoria(Map<String, dynamic> vistoria) async {
    await _collection.add(vistoria);
  }

  @override
  Future<void> updateVistoria(String id, Map<String, dynamic> novaVistoria) async {
    await _collection.doc(id).update(novaVistoria);
  }

  @override
  Future<void> deleteVistoria(String id) async {
    await _collection.doc(id).delete();
  }
}



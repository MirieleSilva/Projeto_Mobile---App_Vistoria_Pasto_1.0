import 'package:flutter/material.dart';
import '../services/vistoria_service.dart';

class VistoriaModel extends ChangeNotifier {
  List<Map<String, dynamic>> _vistorias = [];
  final VistoriaServiceBase service;

  VistoriaModel({required this.service});

  List<Map<String, dynamic>> get vistorias => _vistorias;

  Future<void> loadVistorias() async {
    _vistorias = await service.loadVistorias();
    notifyListeners();
  }

  Future<void> addVistoria(Map<String, dynamic> vistoria) async {
    await service.addVistoria(vistoria);
    await loadVistorias();
  }

  Future<void> updateVistoria(String id, Map<String, dynamic> novaVistoria) async {
    await service.updateVistoria(id, novaVistoria);
    await loadVistorias();
  }

  Future<void> deleteVistoria(String id) async {
    await service.deleteVistoria(id);
    await loadVistorias();
  }
}

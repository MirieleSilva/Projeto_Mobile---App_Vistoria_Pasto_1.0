import 'package:flutter/material.dart';
import '../services/vistoria_service.dart';

class VistoriaModel extends ChangeNotifier {
  List<Map<String, dynamic>> _vistorias = [];

  List<Map<String, dynamic>> get vistorias => _vistorias;

  Future<void> loadVistorias() async {
    _vistorias = await VistoriaService.loadVistorias();
    notifyListeners();
  }

  Future<void> addVistoria(Map<String, dynamic> vistoria) async {
    await VistoriaService.addVistoria(vistoria);
    await loadVistorias();
  }

  Future<void> updateVistoria(int index, Map<String, dynamic> novaVistoria) async {
    await VistoriaService.updateVistoria(index, novaVistoria);
    await loadVistorias();
  }

  Future<void> deleteVistoria(int index) async {
    await VistoriaService.deleteVistoria(index);
    await loadVistorias();
  }
}

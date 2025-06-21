import 'package:projeto_mobile_1/services/vistoria_service.dart';

class MockVistoriaService implements VistoriaServiceBase {
  final List<Map<String, dynamic>> _data = [];

  @override
  Future<List<Map<String, dynamic>>> loadVistorias() async => _data;

  @override
  Future<void> addVistoria(Map<String, dynamic> vistoria) async {
    _data.add(vistoria);
  }

  @override
  Future<void> updateVistoria(String id, Map<String, dynamic> novaVistoria) async {
    final index = _data.indexWhere((v) => v['id'] == id);
    if (index != -1) _data[index] = novaVistoria;
  }

  @override
  Future<void> deleteVistoria(String id) async {
    _data.removeWhere((v) => v['id'] == id);
  }
}

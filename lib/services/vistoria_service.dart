import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class VistoriaService {
  static const String _key = 'vistorias';



  static Future<void> saveVistorias(List<Map<String, dynamic>> vistorias) async {
    final prefs = await SharedPreferences.getInstance();
    String jsonString = jsonEncode(vistorias);
    await prefs.setString(_key, jsonString);
  }

  // Carregar a lista de vistorias
  static Future<List<Map<String, dynamic>>> loadVistorias() async {
    final prefs = await SharedPreferences.getInstance();
    String? jsonString = prefs.getString(_key);
    if (jsonString != null) {
      List<dynamic> decoded = jsonDecode(jsonString);
      return decoded.cast<Map<String, dynamic>>();
    }
    return [];
  }

  // Adicionar uma nova vistoria
  static Future<void> addVistoria(Map<String, dynamic> vistoria) async {
    List<Map<String, dynamic>> vistorias = await loadVistorias();
    vistorias.add(vistoria);
    await saveVistorias(vistorias);
  }

  // Deletar uma vistoria
  static Future<void> deleteVistoria (int index) async{
    List<Map<String, dynamic>> vistorias = await loadVistorias();
    if (index >= 0 && index < vistorias.length){
      vistorias.removeAt(index);
      await saveVistorias(vistorias);
    }

  }
  // Editar uma vistoria
  static Future<void> updateVistoria(int index, Map<String, dynamic> novaVistoria) async {
    List<Map<String, dynamic>> vistorias = await loadVistorias();
    if (index >= 0 && index < vistorias.length) {
      vistorias[index] = novaVistoria;
      await saveVistorias(vistorias);
    }
  }


}


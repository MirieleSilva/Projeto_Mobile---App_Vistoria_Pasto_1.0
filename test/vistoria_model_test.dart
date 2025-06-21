import 'package:flutter_test/flutter_test.dart';
import 'package:projeto_mobile_1/models/vistoria_model.dart';
import 'package:projeto_mobile_1/services/vistoria_service.dart';
import 'mock_vistoria_service.dart';

void main() {
  test('Adiciona uma vistoria corretamente', () async {
    final model = VistoriaModel(service: MockVistoriaService());

    final novaVistoria = {
      'id': '1',
      'nomeResponsavel': 'João',
      'numeroPasto': 1,
      'quantidadeCochos': 3,
      'colocouSal': true,
      'nivelSal': 'Médio',
      'observacao': 'Normal',
      'dataHora': '20/06/2025 12:00:00',
      'latitude': 0.0,
      'longitude': 0.0,
      'temperatura': '27°C',
    };

    await model.addVistoria(novaVistoria);

    expect(model.vistorias.any((v) => v['nomeResponsavel'] == 'João'), true);
  });

  test('Atualiza uma vistoria corretamente', () async {
    final service = MockVistoriaService();
    final model = VistoriaModel(service: service);

    final nova = {
      'id': '1',
      'nomeResponsavel': 'João',
      'numeroPasto': 1,
      'quantidadeCochos': 3,
      'colocouSal': true,
      'nivelSal': 'Médio',
      'observacao': 'Ok',
      'dataHora': '20/06/2025 12:00:00',
      'latitude': 0.0,
      'longitude': 0.0,
      'temperatura': '25°C',
    };

    await model.addVistoria(nova);

    final atualizada = {
      ...nova,
      'nomeResponsavel': 'Maria',
    };

    await model.updateVistoria('1', atualizada);

    expect(model.vistorias.first['nomeResponsavel'], 'Maria');
  });

  test('Deleta uma vistoria corretamente', () async {
    final service = MockVistoriaService();
    final model = VistoriaModel(service: service);

    final nova = {
      'id': '2',
      'nomeResponsavel': 'Carlos',
      'numeroPasto': 2,
      'quantidadeCochos': 2,
      'colocouSal': false,
      'nivelSal': 'Alto',
      'observacao': 'Removendo',
      'dataHora': '20/06/2025 15:00:00',
      'latitude': 1.0,
      'longitude': 1.0,
      'temperatura': '30°C',
    };

    await model.addVistoria(nova);
    expect(model.vistorias.length, 1);

    await model.deleteVistoria('2');
    expect(model.vistorias.isEmpty, true);
  });
}


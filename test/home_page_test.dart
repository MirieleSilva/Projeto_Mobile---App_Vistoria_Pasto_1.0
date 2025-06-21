import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:projeto_mobile_1/models/vistoria_model.dart';
import 'package:projeto_mobile_1/pages/home.dart';
import 'package:projeto_mobile_1/services/vistoria_service.dart';

import 'mock_vistoria_service.dart';

void main() {
  testWidgets('HomePage mostra uma vistoria na interface', (WidgetTester tester) async {
    final model = VistoriaModel(service: MockVistoriaService());

    model.vistorias.add({
      'id': '1',
      'nomeResponsavel': 'Maria',
      'numeroPasto': 10,
      'quantidadeCochos': 3,
      'colocouSal': true,
      'nivelSal': 'Médio',
      'observacao': 'Tudo certo',
      'dataHora': '20/06/2025 12:00:00',
      'latitude': -10.0,
      'longitude': -50.0,
      'temperatura': '28°C',
    });

    model.notifyListeners();

    await tester.pumpWidget(
      MaterialApp(
        home: ChangeNotifierProvider<VistoriaModel>.value(
          value: model,
          child: const HomePage(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Pasto: 10'), findsOneWidget);
    expect(find.textContaining('Maria'), findsOneWidget);
  });
}

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:projeto_mobile_1/pages/home.dart';
import 'package:projeto_mobile_1/models/vistoria_model.dart';

import 'mock_vistoria_service.dart';

void main() {
  testWidgets('HomePage mostra mensagem quando não há vistorias', (WidgetTester tester) async {
    final model = VistoriaModel(service: MockVistoriaService());

    await tester.pumpWidget(
      MaterialApp(
        home: ChangeNotifierProvider.value(
          value: model,
          child: const HomePage(),
        ),
      ),
    );

    expect(find.text('Nenhuma vistoria registrada.'), findsOneWidget);
    expect(find.text('Clique no botão para criar uma nova vistoria.'), findsOneWidget);
  });
}

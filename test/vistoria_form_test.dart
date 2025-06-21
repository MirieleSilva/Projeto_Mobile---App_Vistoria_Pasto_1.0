import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:projeto_mobile_1/models/vistoria_model.dart';
import 'package:projeto_mobile_1/pages/vistoria_form.dart';

import 'mock_vistoria_service.dart';

void main() {
  testWidgets('VistoriaForm salva vistoria com dados válidos', (WidgetTester tester) async {
    final model = VistoriaModel(service: MockVistoriaService());

    // Função simulada que retorna temperatura fixa
    Future<String> mockGetTemperature(double lat, double lon) async {
      return '25°C';
    }

    await tester.pumpWidget(
      MaterialApp(
        home: ChangeNotifierProvider.value(
          value: model,
          child: VistoriaForm(getTemperatureFn: mockGetTemperature), // <- injeção do mock
        ),
      ),
    );

    // Preenche os campos obrigatórios
    await tester.enterText(find.widgetWithText(TextFormField, 'Nome do Responsável'), 'Maria');
    await tester.enterText(find.widgetWithText(TextFormField, 'Número do Pasto'), '12');
    await tester.enterText(find.widgetWithText(TextFormField, 'Quantidade de Cochos'), '3');
    await tester.enterText(find.widgetWithText(TextFormField, 'Observação'), 'Tudo certo');

    // Clica no botão Capturar Localização
    final capturarButton = find.widgetWithText(ElevatedButton, 'Capturar Localização');
    await tester.ensureVisible(capturarButton);
    await tester.tap(capturarButton);
    await tester.pumpAndSettle();

    // Clica no botão Salvar
    final salvarButton = find.widgetWithText(ElevatedButton, 'Salvar');
    await tester.ensureVisible(salvarButton);
    await tester.tap(salvarButton);
    await tester.pumpAndSettle();

    // Verifica se uma nova vistoria foi adicionada
    expect(model.vistorias.length, greaterThan(0));
    expect(model.vistorias.last['nomeResponsavel'], equals('Maria'));
    expect(model.vistorias.last['temperatura'], equals('25°C'));
  });
}



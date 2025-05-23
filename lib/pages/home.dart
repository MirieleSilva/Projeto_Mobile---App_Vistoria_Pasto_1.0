import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../pages/vistoria_form.dart';
import '../models/vistoria_model.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  void _showVistoriaDetails(BuildContext context, Map<String, dynamic> vistoria, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Detalhes da Vistoria'),
          content: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.6,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Responsável: ${vistoria['nomeResponsavel']}'),
                  Text('Número do Pasto: ${vistoria['numeroPasto']}'),
                  Text('Quantidade de Cochos: ${vistoria['quantidadeCochos']}'),
                  Text('Colocou Sal: ${vistoria['colocouSal'] ? 'Sim' : 'Não'}'),
                  if (!vistoria['colocouSal']) Text('Nível de Sal: ${vistoria['nivelSal']}'),
                  Text('Observação: ${vistoria['observacao']}'),
                  Text('Data/Hora: ${vistoria['dataHora']}'),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: () {
                      openMap(vistoria['latitude'], vistoria['longitude']);
                    },
                    child: const Text(
                      'Ver no Mapa',
                      style: TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Fechar'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => VistoriaForm(
                      vistoria: vistoria,
                      index: index,
                    ),
                  ),
                );
                // A lista será atualizada automaticamente via Provider
              },
              child: const Text('Editar'),
            ),
          ],
        );
      },
    );
  }

  void openMap(double latitude, double longitude) async {
    final Uri googleMapsUrl = Uri.parse(
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude');
    if (await canLaunchUrl(googleMapsUrl)) {
      await launchUrl(googleMapsUrl, mode: LaunchMode.externalApplication);
    } else {
      throw 'Não foi possível abrir o mapa';
    }
  }

  @override
  Widget build(BuildContext context) {
    final vistorias = context.watch<VistoriaModel>().vistorias;

    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Vistoria de Gado')),
        backgroundColor: Colors.green,
      ),
      body: vistorias.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              'Nenhuma vistoria registrada.',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text('Clique no botão para criar uma nova vistoria.'),
          ],
        ),
      )
          : ListView.builder(
        itemCount: vistorias.length,
        itemBuilder: (context, index) {
          final vistoria = vistorias[index];
          return ListTile(
            title: Text('Pasto: ${vistoria['numeroPasto']}'),
            subtitle: Text(
                'Responsável: ${vistoria['nomeResponsavel']} - ${vistoria['dataHora']}'),
            onTap: () {
              _showVistoriaDetails(context, vistoria, index);
            },
            trailing: ElevatedButton(
              onPressed: () async {
                await context.read<VistoriaModel>().deleteVistoria(index);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
              ),
              child: const Text('Excluir'),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => VistoriaForm()),
          );
        },
        backgroundColor: Colors.green,
        child: const Icon(Icons.add),
      ),
    );
  }
}

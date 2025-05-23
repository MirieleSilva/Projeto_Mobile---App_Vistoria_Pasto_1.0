import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/vistoria_model.dart';

class VistoriaForm extends StatefulWidget {
  final Map<String, dynamic>? vistoria;
  final int? index;

  VistoriaForm({Key? key, this.vistoria, this.index}) : super(key: key);

  @override
  _VistoriaFormState createState() => _VistoriaFormState();
}

class _VistoriaFormState extends State<VistoriaForm> {
  final _formKey = GlobalKey<FormState>();

  String nomeResponsavel = '';
  int numeroPasto = 0;
  int quantidadeCochos = 0;
  bool colocouSal = false;
  String nivelSal = 'Médio';
  String observacao = '';
  String localizacao = 'Não capturado';
  double latitude = 0.0;
  double longitude = 0.0;

  @override
  void initState() {
    super.initState();
    if (widget.vistoria != null) {
      nomeResponsavel = widget.vistoria!['nomeResponsavel'];
      numeroPasto = widget.vistoria!['numeroPasto'];
      quantidadeCochos = widget.vistoria!['quantidadeCochos'];
      colocouSal = widget.vistoria!['colocouSal'];
      nivelSal = widget.vistoria!['nivelSal'];
      observacao = widget.vistoria!['observacao'];
      latitude = widget.vistoria!['latitude'];
      longitude = widget.vistoria!['longitude'];
      localizacao = '$latitude, $longitude';
    }
  }

  Future<String> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return 'Serviço de localização desativado';
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return 'Permissão negada';
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return 'Permissão permanentemente negada';
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    latitude = position.latitude;
    longitude = position.longitude;
    return '$latitude, $longitude';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.vistoria != null ? 'Editar Vistoria' : 'Nova Vistoria'),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 16,
          bottom: MediaQuery.of(context).viewInsets.bottom + 16,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  widget.vistoria != null ? 'Editar Vistoria' : 'Adicionar Nova Vistoria',
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 16),

              TextFormField(
                initialValue: nomeResponsavel,
                decoration: const InputDecoration(labelText: 'Nome do Responsável'),
                keyboardType: TextInputType.text,
                onChanged: (value) => nomeResponsavel = value,
                validator: (value) =>
                value == null || value.isEmpty ? 'Por favor, informe o nome' : null,
              ),
              const SizedBox(height: 16),

              TextFormField(
                initialValue: numeroPasto != 0 ? numeroPasto.toString() : '',
                decoration: const InputDecoration(labelText: 'Número do Pasto'),
                keyboardType: TextInputType.number,
                onChanged: (value) => numeroPasto = int.tryParse(value) ?? 0,
                validator: (value) =>
                value == null || value.isEmpty ? 'Informe o número do pasto' : null,
              ),
              const SizedBox(height: 16),

              TextFormField(
                initialValue: quantidadeCochos != 0 ? quantidadeCochos.toString() : '',
                decoration: const InputDecoration(labelText: 'Quantidade de Cochos'),
                keyboardType: TextInputType.number,
                onChanged: (value) => quantidadeCochos = int.tryParse(value) ?? 0,
                validator: (value) =>
                value == null || value.isEmpty ? 'Informe a quantidade de cochos' : null,
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  const Text('Colocou Sal?'),
                  Switch(
                    value: colocouSal,
                    onChanged: (value) {
                      setState(() {
                        colocouSal = value;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),

              if (!colocouSal)
                DropdownButtonFormField<String>(
                  value: nivelSal,
                  decoration: const InputDecoration(labelText: 'Nível de Sal'),
                  items: const [
                    DropdownMenuItem(value: 'Médio', child: Text('Médio')),
                    DropdownMenuItem(value: 'Baixo', child: Text('Baixo')),
                    DropdownMenuItem(value: 'Alto', child: Text('Alto')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      nivelSal = value!;
                    });
                  },
                ),
              const SizedBox(height: 16),

              TextFormField(
                initialValue: observacao,
                decoration: const InputDecoration(labelText: 'Observação'),
                onChanged: (value) => observacao = value,
                maxLines: 3,
              ),
              const SizedBox(height: 16),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Localização: $localizacao'),
                  ElevatedButton(
                    onPressed: () async {
                      String location = await getCurrentLocation();
                      setState(() {
                        localizacao = location;
                      });
                    },
                    child: const Text('Capturar Localização'),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      final dataHora = widget.vistoria != null
                          ? widget.vistoria!['dataHora']
                          : DateFormat('dd/MM/yyyy HH:mm:ss').format(
                          DateTime.now().toUtc().subtract(const Duration(hours: 3)));

                      Map<String, dynamic> novaVistoria = {
                        'nomeResponsavel': nomeResponsavel,
                        'numeroPasto': numeroPasto,
                        'quantidadeCochos': quantidadeCochos,
                        'colocouSal': colocouSal,
                        'nivelSal': nivelSal,
                        'observacao': observacao,
                        'dataHora': dataHora,
                        'latitude': latitude,
                        'longitude': longitude,
                      };

                      final vistoriaModel = context.read<VistoriaModel>();

                      if (widget.vistoria != null && widget.index != null) {
                        await vistoriaModel.updateVistoria(widget.index!, novaVistoria);
                      } else {
                        await vistoriaModel.addVistoria(novaVistoria);
                      }

                      Navigator.pop(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  child: const Text('Salvar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

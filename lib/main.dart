import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/vistoria_model.dart';
import 'pages/home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:projeto_mobile_1/services/vistoria_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    ChangeNotifierProvider(
      create: (_) => VistoriaModel(service: VistoriaService())..loadVistorias(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FarmView',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
      },
    );
  }
}

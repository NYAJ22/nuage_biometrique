// nuage_biometrique/example/lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nuage_biometrique/nuage_biometrique.dart'; // Importez votre plugin
import 'package:local_auth/local_auth.dart'; // Pour BiometricType

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final NuageBiometrique _nuageBiometrique = NuageBiometrique();
  bool _canCheckBiometrics = false;
  List<BiometricType> _availableBiometrics = [];
  String _authStatus = 'Non authentifié';

  @override
  void initState() {
    super.initState();
    _initBiometricsStatus();
  }

  Future<void> _initBiometricsStatus() async {
    bool canCheck = await _nuageBiometrique.peutUtiliserBiometrie();
    List<BiometricType> availableTypes = await _nuageBiometrique.obtenirTypesBiometriquesDisponibles();

    if (!mounted) return;

    setState(() {
      _canCheckBiometrics = canCheck;
      _availableBiometrics = availableTypes;
    });
  }

  Future<void> _authenticateUser() async {
    setState(() {
      _authStatus = 'Authentification en cours...';
    });

    bool isAuthenticated = await _nuageBiometrique.authentifier(
      raison: 'Utilisez votre empreinte digitale pour accéder à la zone sécurisée.',
    );

    if (!mounted) return;

    setState(() {
      _authStatus = isAuthenticated ? 'Authentifié avec succès !' : 'Échec de l\'authentification.';
    });

    if (isAuthenticated) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const SecurePage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Exemple Nuage Biometrique'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('Peut vérifier la biométrie : $_canCheckBiometrics'),
              Text('Types biométriques disponibles : ${_availableBiometrics.map((e) => e.toString().split('.').last).join(', ')}'),
              const SizedBox(height: 20),
              Text('Statut d\'authentification : $_authStatus', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _canCheckBiometrics && _availableBiometrics.isNotEmpty
                    ? _authenticateUser
                    : null,
                child: const Text('Authentifier avec Nuage Biometrique'),
              ),
              if (!_canCheckBiometrics || _availableBiometrics.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'La biométrie n\'est pas disponible ou configurée sur cet appareil.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.red),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class SecurePage extends StatelessWidget {
  const SecurePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Page Sécurisée'),
      ),
      body: const Center(
        child: Text(
          'Bienvenue dans la zone sécurisée !',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
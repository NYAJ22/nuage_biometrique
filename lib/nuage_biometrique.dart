// nuage_biometrique/lib/nuage_biometrique.dart
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth/error_codes.dart' as auth_error;

/// Une classe pour gérer l'authentification biométrique personnalisée.
class NuageBiometrique {
  // Une channel de méthode si vous avez besoin d'interagir directement avec du code natif
  // qui n'est pas couvert par local_auth. Pour l'authentification de base, ce n'est pas nécessaire.
  // static const MethodChannel _channel = MethodChannel('nuage_biometrique');

  final LocalAuthentication _auth = LocalAuthentication();

  /// Vérifie si le périphérique prend en charge l'authentification biométrique.
  /// Renvoie true si la biométrie est disponible, false sinon.
  Future<bool> peutUtiliserBiometrie() async {
    try {
      return await _auth.canCheckBiometrics;
    } on PlatformException catch (e) {
      print('Erreur lors de la vérification de la biométrie : ${e.code} - ${e.message}');
      return false;
    }
  }

  /// Obtient la liste des types de biométrie disponibles sur le périphérique.
  /// (ex: BiometricType.face, BiometricType.fingerprint).
  Future<List<BiometricType>> obtenirTypesBiometriquesDisponibles() async {
    try {
      return await _auth.getAvailableBiometrics();
    } on PlatformException catch (e) {
      print('Erreur lors de la récupération des types de biométrie : ${e.code} - ${e.message}');
      return [];
    }
  }

  /// Tente d'authentifier l'utilisateur en utilisant la biométrie.
  ///
  /// [raison] : Le message affiché à l'utilisateur pour expliquer pourquoi l'authentification est requise.
  /// [biometriqueSeulement] : Si défini à true, ne permet que l'authentification biométrique (pas le code PIN/motif).
  /// [messageErreur] : Un message personnalisé à afficher en cas d'échec de l'authentification.
  ///
  /// Renvoie true si l'authentification est réussie, false sinon.
  Future<bool> authentifier({
    required String raison,
    bool biometriqueSeulement = true,
    String? messageErreur,
  }) async {
    bool estAuthentifie = false;
    try {
      estAuthentifie = await _auth.authenticate(
        localizedReason: raison,
        options: AuthenticationOptions(
          stickyAuth: true,
          useErrorDialogs: true,
          biometricOnly: biometriqueSeulement,
        ),
      );
    } on PlatformException catch (e) {
      String erreur = messageErreur ?? 'Échec de l\'authentification biométrique.';
      if (e.code == auth_error.notAvailable) {
        erreur = 'Biométrie non disponible sur ce périphérique.';
      } else if (e.code == auth_error.notEnrolled) {
        erreur = 'Aucune biométrie enregistrée. Veuillez configurer Face ID/empreinte digitale.';
      } else if (e.code == auth_error.lockedOut || e.code == auth_error.permanentlyLockedOut) {
        erreur = 'Authentification biométrique verrouillée. Veuillez utiliser une autre méthode ou réessayer plus tard.';
      }
      print('Erreur d\'authentification : ${e.code} - $erreur');
      return false; // L'authentification a échoué
    }
    return estAuthentifie;
  }

  // Vous pouvez ajouter d'autres méthodes ici qui encapsulent des logiques spécifiques
  // ou combinent plusieurs appels à local_auth.
  // Par exemple, une méthode pour vérifier si une biométrie est configurée ET authentifier.
  Future<bool> verifierEtAuthentifier(String raison) async {
    bool peutVerifier = await peutUtiliserBiometrie();
    if (!peutVerifier) {
      print('Biométrie non disponible.');
      return false;
    }
    List<BiometricType> types = await obtenirTypesBiometriquesDisponibles();
    if (types.isEmpty) {
      print('Aucun type de biométrie n\'est configuré.');
      return false;
    }
    return await authentifier(raison: raison);
  }
}
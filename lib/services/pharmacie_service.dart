// lib/services/pharmacie_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/pharmacie_model.dart';

class PharmacieService {
  static const String _urlApi =
      'https://api-dev.kondjigbale.com/pharmacies/garde';
  static const String _apiKey = 'bSy_4oxX4QcJ6aVcSjAkxkX5lA8E17i2';

  static Future<Map<String, dynamic>> getPharmaciesGarde({
    required double latitude,
    required double longitude,
  }) async {
    try {
      final Uri url = Uri.parse(_urlApi);
      final request = http.MultipartRequest('POST', url);

      request.headers.addAll({
        'apiKey': _apiKey,
        'Accept': 'application/json',
      });

      request.fields['access_token']  = 'BLeXll8d3ilRHgZjqxj7oHqJnrxIO2ca';
      request.fields['c_identifiant'] = 'g5IoGDIaSOLbEj7n-in4U4Ao42_eZHgQ';
      request.fields['u_identifiant'] = 'n4gEXgmCN5Vc3ub32Noqi1_vvB3lowby';
      request.fields['client']        =
      '{"fullname":"Daniel","phone":"+22870023786"}';
      request.fields['latitude']      = latitude.toString();
      request.fields['longitude']     = longitude.toString();

      final streamedResponse =
      await request.send().timeout(const Duration(seconds: 15));
      final reponse = await http.Response.fromStream(streamedResponse);

      if (reponse.statusCode == 200) {
        final Map<String, dynamic> jsonData = jsonDecode(reponse.body);

        if (jsonData['status'] == '000') {
          final List<Pharmacie> pharmacies =
          (jsonData['pharmacies'] as List<dynamic>)
              .map((item) => Pharmacie.fromJson(item as Map<String, dynamic>))
          // On filtre les pharmacies sans coordonnées GPS valides
              .where((p) =>
          p.latitude.isNotEmpty &&
              p.longitude.isNotEmpty &&
              p.latitude != '0.0' &&
              p.longitude != '0.0')
              .toList();

          return {
            'succes':     true,
            'pharmacies': pharmacies,
            'dateDebut':  jsonData['date_debut'] ?? '',
            'dateFin':    jsonData['date_fin']   ?? '',
            'message':    jsonData['message']    ?? '',
          };
        } else {
          return {
            'succes':  false,
            'message': jsonData['message'] ?? 'Erreur API',
          };
        }
      } else if (reponse.statusCode == 401) {
        return {'succes': false, 'message': 'Non autorisé (401)'};
      } else {
        return {
          'succes':  false,
          'message': 'Erreur serveur : ${reponse.statusCode}',
        };
      }
    } catch (e) {
      return {'succes': false, 'message': 'Erreur réseau : $e'};
    }
  }
}
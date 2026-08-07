// lib/models/pharmacie_model.dart

class Pharmacie {
  final String nom;
  final String photo;
  final String ville;
  final String prefecture;
  final String contact1;
  final String contact2;
  final String email;
  final String adresse;
  final String heureDebut;
  final String heureFin;
  final String latitude;
  final String longitude;
  final String mapLink;
  final String distance;

  const Pharmacie({
    required this.nom,
    required this.photo,
    required this.ville,
    required this.prefecture,
    required this.contact1,
    required this.contact2,
    required this.email,
    required this.adresse,
    required this.heureDebut,
    required this.heureFin,
    required this.latitude,
    required this.longitude,
    required this.mapLink,
    required this.distance,
  });

  factory Pharmacie.fromJson(Map<String, dynamic> json) {
    return Pharmacie(
      nom:        json['nom']         ?? '',
      photo:      json['photo']       ?? '',
      ville:      json['ville']       ?? '',
      prefecture: json['prefecture']  ?? '',
      contact1:   json['contact_1']   ?? '',
      contact2:   json['contact_2']   ?? '',
      email:      json['email']       ?? '',
      adresse:    json['adresse']     ?? '',
      heureDebut: json['heure_debut'] ?? '',
      heureFin:   json['heure_fin']   ?? '',
      latitude:   json['latitude']    ?? '',
      longitude:  json['longitude']   ?? '',
      mapLink:    json['map_link']    ?? '',
      distance:   json['distance']    ?? '',
    );
  }
}
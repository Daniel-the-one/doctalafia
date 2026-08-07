// lib/pharmacie.dart

import 'package:flutter/material.dart';
import '../models/pharmacie_model.dart';
import '../services/pharmacie_service.dart';
import '../services/position.dart';
import '../services/storage_service.dart';  // ton propre service
import 'detail.dart';
import '../main.dart'; // pour PageConnexion (ou remplace par ton import réel)

// ─── Palette ───────────────────────────────────────────────
const _vert   = Color(0xFF1DB954);
const _vertF  = Color(0xFF0F8C3B);
const _orange = Color(0xFFFF6B00);
const _fond   = Color(0xFFF0F4F8);
const _noir   = Color(0xFF0D1117);
const _gris   = Color(0xFF6B7280);
const _blanc  = Colors.white;

// ═══════════════════════════════════════════════════════════
//  PAGE LISTE PHARMACIES — CORRIGÉE + DESIGN MODERNE
// ═══════════════════════════════════════════════════════════
class PagePharmacies extends StatefulWidget {
  const PagePharmacies({super.key});

  @override
  State<PagePharmacies> createState() => _PagePharmaciesState();
}

class _PagePharmaciesState extends State<PagePharmacies> {
  List<Pharmacie> _listePharmacies = [];
  List<Pharmacie> _listeFiltree    = [];
  bool   _chargement = true;
  String _erreur     = '';
  String _dateDebut  = '';
  String _dateFin    = '';
  final TextEditingController _rechercheCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _chargerAvecPosition();
  }

  @override
  void dispose() {
    _rechercheCtrl.dispose();
    super.dispose();
  }

  // ── Obtenir GPS puis charger ────────────────────────────
  Future<void> _chargerAvecPosition() async {
    setState(() { _chargement = true; _erreur = ''; });

    final LatLng? pos = await getCurrentPosition();
    await _chargerPharmacies(
      latitude:  pos?.latitude  ?? 0,
      longitude: pos?.longitude ?? 0,
    );
  }

  // ── Appel API ───────────────────────────────────────────
  Future<void> _chargerPharmacies({
    required double latitude,
    required double longitude,
  }) async {
    final Map<String, dynamic> resultat =
    await PharmacieService.getPharmaciesGarde(
      latitude:  latitude,
      longitude: longitude,
    );

    if (!mounted) return;

    if (resultat['succes'] == true) {
      setState(() {
        _listePharmacies = resultat['pharmacies'] as List<Pharmacie>;
        _listeFiltree    = _listePharmacies;
        _dateDebut       = resultat['dateDebut'] as String;
        _dateFin         = resultat['dateFin']   as String;
        _chargement      = false;
      });
    } else {
      setState(() {
        _erreur     = resultat['message'] as String;
        _chargement = false;
      });
    }
  }

  // ── Filtre recherche ────────────────────────────────────
  void _filtrer(String texte) {
    setState(() {
      if (texte.isEmpty) {
        _listeFiltree = _listePharmacies;
      } else {
        final q = texte.toLowerCase();
        _listeFiltree = _listePharmacies
            .where((p) =>
        p.nom.toLowerCase().contains(q)     ||
            p.ville.toLowerCase().contains(q)   ||
            p.adresse.toLowerCase().contains(q))
            .toList();
      }
    });
  }

  // ── Déconnexion ─────────────────────────────────────────
  Future<void> _deconnexion() async {
    await StorageService.saveUserLoggedOut();
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => PageSplash()),   // ← adapte selon ton main.dart
          (route) => false,
    );
  }

  // ── Build ───────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _fond,
      appBar: _buildAppBar(),
      body: _chargement
          ? _ecranChargement()
          : _erreur.isNotEmpty
          ? _ecranErreur()
          : _ecranListe(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: _vert,
      foregroundColor: _blanc,
      title: const Text(
        'Pharmacies de garde',
        style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh_rounded),
          tooltip: 'Actualiser',
          onPressed: _chargerAvecPosition,
        ),
        IconButton(
          icon: const Icon(Icons.logout_rounded),
          tooltip: 'Déconnexion',
          onPressed: _deconnexion,
        ),
      ],
    );
  }

  // ── Écrans ──────────────────────────────────────────────
  Widget _ecranChargement() => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const CircularProgressIndicator(color: _vert),
        const SizedBox(height: 16),
        Text('Localisation en cours…',
            style: TextStyle(color: _gris, fontSize: 14)),
      ],
    ),
  );

  Widget _ecranErreur() => Center(
    child: Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.08),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.wifi_off_rounded,
                size: 52, color: Colors.redAccent),
          ),
          const SizedBox(height: 20),
          const Text('Impossible de charger',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: _noir)),
          const SizedBox(height: 8),
          Text(_erreur,
              textAlign: TextAlign.center,
              style: const TextStyle(color: _gris, fontSize: 13)),
          const SizedBox(height: 28),
          ElevatedButton.icon(
            onPressed: _chargerAvecPosition,
            icon: const Icon(Icons.refresh_rounded),
            label: const Text('Réessayer'),
            style: ElevatedButton.styleFrom(
              backgroundColor: _vert,
              foregroundColor: _blanc,
              padding: const EdgeInsets.symmetric(
                  horizontal: 28, vertical: 14),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              elevation: 0,
            ),
          ),
        ],
      ),
    ),
  );

  Widget _ecranListe() {
    return Column(
      children: [
        // Bandeau dates
        if (_dateDebut.isNotEmpty && _dateFin.isNotEmpty)
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                  colors: [_vert, _vertF],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight),
            ),
            padding:
            const EdgeInsets.symmetric(vertical: 9, horizontal: 16),
            child: Text(
              '📅  Garde du $_dateDebut  au  $_dateFin',
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: _blanc,
                  fontSize: 13,
                  fontWeight: FontWeight.w500),
            ),
          ),

        // Barre de recherche
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: TextField(
            controller: _rechercheCtrl,
            onChanged: _filtrer,
            decoration: InputDecoration(
              hintText: 'Nom, ville, adresse…',
              hintStyle: TextStyle(color: _gris.withOpacity(0.7)),
              prefixIcon:
              const Icon(Icons.search_rounded, color: _gris),
              suffixIcon: _rechercheCtrl.text.isNotEmpty
                  ? IconButton(
                icon: const Icon(Icons.close_rounded,
                    color: _gris),
                onPressed: () {
                  _rechercheCtrl.clear();
                  _filtrer('');
                },
              )
                  : null,
              filled: true,
              fillColor: _blanc,
              contentPadding: const EdgeInsets.symmetric(
                  vertical: 14, horizontal: 16),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide:
                  const BorderSide(color: _vert, width: 2)),
            ),
          ),
        ),

        // Compteur
        Padding(
          padding:
          const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              '${_listeFiltree.length} pharmacie(s)',
              style: TextStyle(
                  color: _gris, fontSize: 12, fontWeight: FontWeight.w500),
            ),
          ),
        ),

        // Liste
        Expanded(
          child: _listeFiltree.isEmpty
              ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.search_off_rounded,
                    size: 52, color: _gris.withOpacity(0.4)),
                const SizedBox(height: 12),
                const Text('Aucun résultat',
                    style: TextStyle(color: _gris)),
              ],
            ),
          )
              : ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
            itemCount: _listeFiltree.length,
            itemBuilder: (_, i) =>
                _CartePharmacieWidget(pharmacie: _listeFiltree[i]),
          ),
        ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════
//  CARTE PHARMACIE — DESIGN MODERNE
// ═══════════════════════════════════════════════════════════
class _CartePharmacieWidget extends StatelessWidget {
  final Pharmacie pharmacie;
  const _CartePharmacieWidget({required this.pharmacie});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) =>
              PageDetailPharmacie(pharmacie: pharmacie),
        ),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(
          color: _blanc,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: _noir.withOpacity(0.06),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16)),
              child: _ImageCarte(url: pharmacie.photo),
            ),

            // Infos
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nom + badge
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          pharmacie.nom,
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                            color: _noir,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      if (pharmacie.distance.isNotEmpty)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: _vert.withOpacity(0.10),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            pharmacie.distance,
                            style: const TextStyle(
                              color: _vert,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Ville
                  _MiniInfo(
                    icone: Icons.location_city_outlined,
                    texte: '${pharmacie.ville}  •  ${pharmacie.prefecture}',
                  ),
                  const SizedBox(height: 4),

                  // Adresse
                  _MiniInfo(
                    icone: Icons.location_on_outlined,
                    texte: pharmacie.adresse,
                    maxLines: 2,
                  ),

                  if (pharmacie.contact1.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    _MiniInfo(
                      icone: Icons.phone_outlined,
                      texte: pharmacie.contact1,
                    ),
                  ],

                  const SizedBox(height: 10),

                  // Séparateur + lien
                  const Divider(height: 1, color: Color(0xFFF3F4F6)),
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Text(
                          'Voir les détails',
                          style: TextStyle(
                            color: _vert,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(width: 4),
                        Icon(Icons.arrow_forward_rounded,
                            size: 14, color: _vert),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Image carte avec fallback ──────────────────────────────
class _ImageCarte extends StatelessWidget {
  final String url;
  const _ImageCarte({required this.url});

  @override
  Widget build(BuildContext context) {
    if (url.isEmpty) return _placeholder();
    return Image.network(
      url,
      width: double.infinity,
      height: 140,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => _placeholder(),
      loadingBuilder: (_, child, progress) {
        if (progress == null) return child;
        return Container(
          height: 140,
          color: const Color(0xFFF0F4F8),
          child: const Center(
            child: CircularProgressIndicator(color: _vert, strokeWidth: 2),
          ),
        );
      },
    );
  }

  Widget _placeholder() => Container(
    width: double.infinity,
    height: 140,
    color: _vert.withOpacity(0.07),
    child: const Icon(Icons.local_pharmacy_rounded,
        size: 48, color: _vert),
  );
}

// ── Mini ligne d'info dans la carte ───────────────────────
class _MiniInfo extends StatelessWidget {
  final IconData icone;
  final String texte;
  final int maxLines;
  const _MiniInfo({
    required this.icone,
    required this.texte,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icone, size: 13, color: _gris),
        const SizedBox(width: 5),
        Expanded(
          child: Text(
            texte,
            maxLines: maxLines,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: _gris, fontSize: 12),
          ),
        ),
      ],
    );
  }
}
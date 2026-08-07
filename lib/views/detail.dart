// lib/detail.dart

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/pharmacie_model.dart';

// ─── Palette ───────────────────────────────────────────────
const _vert    = Color(0xFF1DB954);
const _vertF   = Color(0xFF0F8C3B);
const _orange  = Color(0xFFFF6B00);
const _fond    = Color(0xFFF0F4F8);
const _noir    = Color(0xFF0D1117);
const _gris    = Color(0xFF6B7280);
const _blanc   = Colors.white;

// ═══════════════════════════════════════════════════════════
//  PAGE DETAIL PHARMACIE  — CORRIGÉE + DESIGN MODERNE
// ═══════════════════════════════════════════════════════════
class PageDetailPharmacie extends StatelessWidget {  // ← FIX : déclaration correcte
  final Pharmacie pharmacie;
  const PageDetailPharmacie({super.key, required this.pharmacie});

  Future<void> _ouvrirCarte() async {
    if (pharmacie.mapLink.isEmpty) return;
    final Uri url = Uri.parse(pharmacie.mapLink);
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _appeler(String numero) async {
    final Uri tel =
    Uri.parse('tel:${numero.replaceAll(' ', '')}');
    if (await canLaunchUrl(tel)) await launchUrl(tel);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _fond,
      body: CustomScrollView(
        slivers: [
          // ── SliverAppBar image ──────────────────────────
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            backgroundColor: _vert,
            leading: _BoutonRetourCircle(onTap: () => Navigator.pop(context)),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  _ImageReseau(url: pharmacie.photo),
                  // dégradé bas → blanc pour raccorder au contenu
                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            _noir.withOpacity(0.55),
                          ],
                          stops: const [0.5, 1.0],
                        ),
                      ),
                    ),
                  ),
                  // badge distance en bas à droite
                  Positioned(
                    bottom: 16,
                    right: 16,
                    child: _BadgeDistance(texte: pharmacie.distance),
                  ),
                ],
              ),
            ),
          ),

          // ── Contenu ────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nom
                  Text(
                    pharmacie.nom,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: _noir,
                      height: 1.25,
                    ),
                  ),
                  const SizedBox(height: 6),
                  // Ville
                  Row(
                    children: [
                      const Icon(Icons.location_city_outlined,
                          size: 14, color: _gris),
                      const SizedBox(width: 4),
                      Text(
                        '${pharmacie.ville}  •  ${pharmacie.prefecture}',
                        style: const TextStyle(color: _gris, fontSize: 13),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // ── Carte infos ─────────────────────────
                  _CarteInfos(pharmacie: pharmacie),
                  const SizedBox(height: 28),

                  // ── Boutons d'action ────────────────────
                  if (pharmacie.contact1.isNotEmpty)
                    _BoutonAction(
                      icone: Icons.call_rounded,
                      texte: 'Appeler  ${pharmacie.contact1}',
                      couleur: _vert,
                      onTap: () => _appeler(pharmacie.contact1),
                    ),

                  if (pharmacie.contact2.isNotEmpty) ...[
                    const SizedBox(height: 10),
                    _BoutonAction(
                      icone: Icons.call_rounded,
                      texte: 'Appeler  ${pharmacie.contact2}',
                      couleur: _vert,
                      contour: true,
                      onTap: () => _appeler(pharmacie.contact2),
                    ),
                  ],

                  if (pharmacie.mapLink.isNotEmpty) ...[
                    const SizedBox(height: 10),
                    _BoutonAction(
                      icone: Icons.map_outlined,
                      texte: 'Voir sur la carte',
                      couleur: _orange,
                      contour: true,
                      onTap: _ouvrirCarte,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Carte regroupant toutes les infos ──────────────────────
class _CarteInfos extends StatelessWidget {
  final Pharmacie pharmacie;
  const _CarteInfos({required this.pharmacie});

  @override
  Widget build(BuildContext context) {
    final List<_InfoRow> lignes = [
      _InfoRow(icone: Icons.location_on_outlined,
          label: 'Adresse', valeur: pharmacie.adresse),
      if (pharmacie.heureDebut.isNotEmpty && pharmacie.heureFin.isNotEmpty)
        _InfoRow(icone: Icons.access_time_rounded,
            label: 'Horaires',
            valeur: '${pharmacie.heureDebut}  →  ${pharmacie.heureFin}'),
      if (pharmacie.contact1.isNotEmpty)
        _InfoRow(icone: Icons.phone_outlined,
            label: 'Contact 1',
            valeur: pharmacie.contact1,
            couleur: _vert),
      if (pharmacie.contact2.isNotEmpty)
        _InfoRow(icone: Icons.phone_outlined,
            label: 'Contact 2',
            valeur: pharmacie.contact2,
            couleur: _vert),
      if (pharmacie.email.trim().isNotEmpty)
        _InfoRow(icone: Icons.email_outlined,
            label: 'Email', valeur: pharmacie.email.trim()),
      if (pharmacie.latitude.isNotEmpty &&
          pharmacie.longitude.isNotEmpty &&
          pharmacie.latitude != '0.0' &&
          pharmacie.longitude != '0.0')
        _InfoRow(icone: Icons.my_location_outlined,
            label: 'GPS',
            valeur: '${pharmacie.latitude},  ${pharmacie.longitude}'),
    ];

    return Container(
      decoration: BoxDecoration(
        color: _blanc,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: _noir.withOpacity(0.06),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          for (int i = 0; i < lignes.length; i++) ...[
            _LigneInfo(row: lignes[i]),
            if (i < lignes.length - 1)
              const Divider(height: 1, indent: 48, color: Color(0xFFF3F4F6)),
          ],
        ],
      ),
    );
  }
}

class _InfoRow {
  final IconData icone;
  final String label;
  final String valeur;
  final Color couleur;
  const _InfoRow({
    required this.icone,
    required this.label,
    required this.valeur,
    this.couleur = _gris,
  });
}

class _LigneInfo extends StatelessWidget {
  final _InfoRow row;
  const _LigneInfo({required this.row});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: _vert.withOpacity(0.10),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(row.icone, size: 17, color: _vert),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(row.label,
                    style: const TextStyle(
                        fontSize: 11,
                        color: _gris,
                        fontWeight: FontWeight.w500)),
                const SizedBox(height: 2),
                Text(row.valeur,
                    style: TextStyle(
                        fontSize: 14,
                        color: row.couleur,
                        fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Bouton action (plein ou contour) ───────────────────────
class _BoutonAction extends StatelessWidget {
  final IconData icone;
  final String texte;
  final Color couleur;
  final bool contour;
  final VoidCallback onTap;

  const _BoutonAction({
    required this.icone,
    required this.texte,
    required this.couleur,
    required this.onTap,
    this.contour = false,
  });

  @override
  Widget build(BuildContext context) {
    final style = contour
        ? OutlinedButton.styleFrom(
      side: BorderSide(color: couleur, width: 1.5),
      foregroundColor: couleur,
      shape:
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      padding:
      const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
      minimumSize: const Size(double.infinity, 52),
    )
        : ElevatedButton.styleFrom(
      backgroundColor: couleur,
      foregroundColor: _blanc,
      elevation: 0,
      shape:
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      padding:
      const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
      minimumSize: const Size(double.infinity, 52),
    );

    final child = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icone, size: 20),
        const SizedBox(width: 8),
        Text(texte,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
      ],
    );

    return contour
        ? OutlinedButton(onPressed: onTap, style: style, child: child)
        : ElevatedButton(onPressed: onTap, style: style, child: child);
  }
}

// ── Badge distance ─────────────────────────────────────────
class _BadgeDistance extends StatelessWidget {
  final String texte;
  const _BadgeDistance({required this.texte});

  @override
  Widget build(BuildContext context) {
    if (texte.isEmpty) return const SizedBox.shrink();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: _vert,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: _vert.withOpacity(0.4), blurRadius: 8)
        ],
      ),
      child: Text(
        texte,
        style: const TextStyle(
          color: _blanc,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }
}

// ── Bouton retour circulaire ───────────────────────────────
class _BoutonRetourCircle extends StatelessWidget {
  final VoidCallback onTap;
  const _BoutonRetourCircle({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: _blanc.withOpacity(0.92),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                  color: _noir.withOpacity(0.12),
                  blurRadius: 8,
                  offset: const Offset(0, 2))
            ],
          ),
          child: const Icon(Icons.arrow_back_ios_new_rounded,
              color: _vert, size: 18),
        ),
      ),
    );
  }
}

// ── Image réseau avec fallback ─────────────────────────────
class _ImageReseau extends StatelessWidget {
  final String url;
  const _ImageReseau({required this.url});

  @override
  Widget build(BuildContext context) {
    if (url.isEmpty) return _placeholder();
    return Image.network(
      url,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => _placeholder(),
      loadingBuilder: (_, child, progress) {
        if (progress == null) return child;
        return Container(
          color: const Color(0xFFF0F4F8),
          child: Center(
            child: CircularProgressIndicator(
              color: _vert,
              strokeWidth: 2,
              value: progress.expectedTotalBytes != null
                  ? progress.cumulativeBytesLoaded /
                  progress.expectedTotalBytes!
                  : null,
            ),
          ),
        );
      },
    );
  }

  Widget _placeholder() => Container(
    color: _vert.withOpacity(0.08),
    child: const Center(
      child: Icon(Icons.local_pharmacy_rounded, size: 80, color: _vert),
    ),
  );
}
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';

// ============================================================
//  COULEURS DE L'ENTREPRISE SANTÉ (Design Moderne)
// ============================================================
const Color vertPrincipal   = Color(0xFF1DB954); // Vert vif
const Color vertFonce       = Color(0xFF0F8C3B); // Vert foncé
const Color orangePrincipal = Color(0xFFFF6B00); // Orange
const Color orangeClair     = Color(0xFFFF8C38); // Orange clair
const Color fondBlanc       = Color(0xFFFFFFFF);
const Color fondGris        = Color(0xFFF7F8FA);
const Color texteNoir       = Color(0xFF1A1A2E);
const Color texteGris       = Color(0xFF9CA3AF);
const Color bordureGris     = Color(0xFFE5E7EB);

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      fontFamily: 'Roboto',
      scaffoldBackgroundColor: fondBlanc,
    ),
    home: PageSplash(),
  ));
}

// ============================================================
//  PAGE SPLASH  (Logo + Connexion / Inscription)
// ============================================================
class PageSplash extends StatelessWidget {
  const PageSplash({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: fondBlanc,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(),

              // Logo Principal
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [vertPrincipal, vertFonce],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: const Icon(Icons.health_and_safety, color: Colors.white, size: 48),
              ),
              const SizedBox(height: 20),

              const Text(
                'MediCare',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: texteNoir,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Votre santé, notre priorité.\nConnectez-vous en toute sécurité.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: texteGris, height: 1.6),
              ),

              const Spacer(),

              // Bouton Login
              _BoutonPlein(
                texte: 'Se connecter',
                couleur: texteNoir,
                onTap: () => Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const PageLogin())),
              ),
              const SizedBox(height: 14),

              // Bouton Sign up (contour)
              _BoutonContour(
                texte: "S'inscrire",
                onTap: () => Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const PageSignup())),
              ),
              const SizedBox(height: 30),

              _Separateur(),
              const SizedBox(height: 20),

              const _BoutonSocial(
                icone: Icons.g_mobiledata,
                texte: 'Continuer avec Google',
                couleurIcone: Colors.red,
              ),
              const SizedBox(height: 12),

              const _BoutonSocial(
                icone: Icons.apple,
                texte: 'Continuer avec Apple',
                couleurIcone: texteNoir,
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================
//  PAGE LOGIN
// ============================================================
class PageLogin extends StatefulWidget {
  const PageLogin({super.key});

  @override
  _PageLoginState createState() => _PageLoginState();
}

class _PageLoginState extends State<PageLogin> {
  final TextEditingController emailController    = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool voirMdp     = false;
  bool rememberMe  = false;
  String erreur    = '';

  void seConnecter() {
    if (emailController.text.trim().isEmpty || passwordController.text.trim().isEmpty) {
      setState(() => erreur = 'Remplis tous les champs !');
    } else {
      setState(() => erreur = '');
      print('Connecté : ${emailController.text}');

      // AJOUT : Redirection vers la page des pharmacies de garde après connexion
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const PagePharmacie()),
            (route) => false,
      );
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: fondBlanc,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              const _BoutonRetour(),
              const SizedBox(height: 28),

              _LogoMini(),
              const SizedBox(height: 20),
              Text('Login', style: _styleTitrePage()),
              const SizedBox(height: 6),
              const Text('Connectez-vous à votre compte',
                  style: TextStyle(color: texteGris, fontSize: 14)),
              const SizedBox(height: 32),

              const _LabelChamp('Adresse E-mail'),
              const SizedBox(height: 8),
              _ChampTexte(
                controller: emailController,
                hint: 'exemple@email.com',
                icone: Icons.email_outlined,
                clavier: TextInputType.emailAddress,
              ),
              const SizedBox(height: 20),

              const _LabelChamp('Mot de passe'),
              const SizedBox(height: 8),
              _ChampMdp(
                controller: passwordController,
                voir: voirMdp,
                onToggle: () => setState(() => voirMdp = !voirMdp),
              ),
              const SizedBox(height: 14),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Checkbox(
                        value: rememberMe,
                        activeColor: vertPrincipal,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4)),
                        onChanged: (v) => setState(() => rememberMe = v ?? false),
                      ),
                      const Text('Se souvenir', style: TextStyle(color: texteGris, fontSize: 13)),
                    ],
                  ),
                  GestureDetector(
                    onTap: () => Navigator.push(context,
                        MaterialPageRoute(builder: (_) => const PageForgot())),
                    child: const Text('Mot de passe oublié ?',
                        style: TextStyle(
                            color: orangePrincipal,
                            fontSize: 13,
                            fontWeight: FontWeight.w600)),
                  ),
                ],
              ),

              if (erreur.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(erreur, style: const TextStyle(color: Colors.red, fontSize: 13)),
                ),

              const SizedBox(height: 24),
              _BoutonPlein(texte: 'Se connecter', couleur: texteNoir, onTap: seConnecter),
              const SizedBox(height: 24),
              _Separateur(),
              const SizedBox(height: 20),
              const _BoutonSocial(icone: Icons.g_mobiledata, texte: 'Continuer avec Google', couleurIcone: Colors.red),
              const SizedBox(height: 12),
              const _BoutonSocial(icone: Icons.apple, texte: 'Continuer avec Apple', couleurIcone: texteNoir),
              const SizedBox(height: 24),

              Center(
                child: GestureDetector(
                  onTap: () => Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const PageSignup())),
                  child: RichText(
                    text: const TextSpan(
                      text: "Pas de compte ? ",
                      style: TextStyle(color: texteGris, fontSize: 14),
                      children: [
                        TextSpan(
                          text: "S'inscrire",
                          style: TextStyle(
                              color: vertPrincipal, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================
//  PAGE SIGNUP
// ============================================================
class PageSignup extends StatefulWidget {
  const PageSignup({super.key});

  @override
  _PageSignupState createState() => _PageSignupState();
}

class _PageSignupState extends State<PageSignup> {
  final TextEditingController nomController    = TextEditingController();
  final TextEditingController prenomController = TextEditingController();
  final TextEditingController telController    = TextEditingController();
  final TextEditingController emailController  = TextEditingController();
  final TextEditingController mdpController    = TextEditingController();
  bool voirMdp    = false;
  bool conditions = false;
  String erreur   = '';
  int etape       = 1;

  void suivant() {
    if (nomController.text.trim().isEmpty || prenomController.text.trim().isEmpty || telController.text.trim().isEmpty) {
      setState(() => erreur = 'Remplis tous les champs !');
    } else {
      setState(() { erreur = ''; etape = 2; });
    }
  }

  void sInscrire() {
    if (emailController.text.trim().isEmpty || mdpController.text.trim().isEmpty) {
      setState(() => erreur = 'Remplis tous les champs !');
    } else if (!conditions) {
      setState(() => erreur = "Accepte les conditions d'utilisation !");
    } else if (mdpController.text.length < 6) {
      setState(() => erreur = 'Minimum 6 caractères !');
    } else {
      setState(() => erreur = '');
      print('Inscription validée pour ${prenomController.text}');

      // AJOUT : Redirection vers la page principale des pharmacies après inscription
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const PagePharmacie()),
            (route) => false,
      );
    }
  }

  @override
  void dispose() {
    nomController.dispose();
    prenomController.dispose();
    telController.dispose();
    emailController.dispose();
    mdpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: fondBlanc,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              const _BoutonRetour(),
              const SizedBox(height: 28),

              _LogoMini(),
              const SizedBox(height: 16),
              Text('Sign up', style: _styleTitrePage()),
              const SizedBox(height: 6),
              Text('Rapide, juste ${etape == 1 ? "2" : "1"} étape${etape == 1 ? "s" : ""} et vous êtes dedans',
                  style: const TextStyle(color: texteGris, fontSize: 14)),
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 4,
                      decoration: BoxDecoration(
                        color: vertPrincipal,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Container(
                      height: 4,
                      decoration: BoxDecoration(
                        color: etape == 2 ? vertPrincipal : bordureGris,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),

              if (etape == 1) ...[
                const _LabelChamp('Nom'),
                const SizedBox(height: 8),
                _ChampTexte(controller: nomController, hint: 'Votre nom', icone: Icons.person_outline),
                const SizedBox(height: 16),
                const _LabelChamp('Prénom'),
                const SizedBox(height: 8),
                _ChampTexte(controller: prenomController, hint: 'Votre prénom', icone: Icons.person_outline),
                const SizedBox(height: 16),
                const _LabelChamp('Téléphone'),
                const SizedBox(height: 8),
                _ChampTexte(
                    controller: telController,
                    hint: '+228 90 00 00 00',
                    icone: Icons.phone_outlined,
                    clavier: TextInputType.phone),
              ],

              if (etape == 2) ...[
                const _LabelChamp('Adresse E-mail'),
                const SizedBox(height: 8),
                _ChampTexte(
                    controller: emailController,
                    hint: 'exemple@email.com',
                    icone: Icons.email_outlined,
                    clavier: TextInputType.emailAddress),
                const SizedBox(height: 16),
                const _LabelChamp('Mot de passe'),
                const SizedBox(height: 8),
                _ChampMdp(
                    controller: mdpController,
                    voir: voirMdp,
                    onToggle: () => setState(() => voirMdp = !voirMdp)),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Checkbox(
                      value: conditions,
                      activeColor: vertPrincipal,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                      onChanged: (v) => setState(() => conditions = v ?? false),
                    ),
                    Expanded(
                      child: RichText(
                        text: const TextSpan(
                          text: "J'accepte les ",
                          style: TextStyle(color: texteGris, fontSize: 13),
                          children: [
                            TextSpan(
                              text: 'conditions d\'utilisation',
                              style: TextStyle(
                                  color: vertPrincipal,
                                  decoration: TextDecoration.underline,
                                  fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],

              if (erreur.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(erreur, style: const TextStyle(color: Colors.red, fontSize: 13)),
                ),

              const SizedBox(height: 24),

              _BoutonPlein(
                texte: etape == 1 ? 'Suivant' : 'Créer mon compte',
                couleur: texteNoir,
                onTap: etape == 1 ? suivant : sInscrire,
              ),

              const SizedBox(height: 24),
              _Separateur(),
              const SizedBox(height: 20),
              const _BoutonSocial(icone: Icons.g_mobiledata, texte: 'Continuer avec Google', couleurIcone: Colors.red),
              const SizedBox(height: 12),
              const _BoutonSocial(icone: Icons.apple, texte: 'Continuer avec Apple', couleurIcone: texteNoir),
              const SizedBox(height: 24),

              Center(
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: RichText(
                    text: const TextSpan(
                      text: 'Déjà un compte ? ',
                      style: TextStyle(color: texteGris, fontSize: 14),
                      children: [
                        TextSpan(
                          text: 'Se connecter',
                          style: TextStyle(color: vertPrincipal, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================
//  PAGE FORGOT PASSWORD
// ============================================================
class PageForgot extends StatefulWidget {
  const PageForgot({super.key});

  @override
  _PageForgotState createState() => _PageForgotState();
}

class _PageForgotState extends State<PageForgot> {
  final TextEditingController emailController = TextEditingController();
  String erreur = '';

  void envoyerOTP() {
    if (emailController.text.trim().isEmpty) {
      setState(() => erreur = 'Entre ton adresse email !');
    } else if (!emailController.text.contains('@')) {
      setState(() => erreur = 'Email invalide !');
    } else {
      setState(() => erreur = '');
      Navigator.push(context,
          MaterialPageRoute(
              builder: (_) => PageVerifyOTP(email: emailController.text)));
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: fondBlanc,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              Row(
                children: [
                  const _BoutonRetour(),
                  Expanded(
                    child: Center(
                      child: Text('Forgot',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: texteNoir)),
                    ),
                  ),
                  const SizedBox(width: 40),
                ],
              ),
              const SizedBox(height: 30),

              Center(
                child: Container(
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    color: fondGris,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.lock_reset_rounded,
                          size: 80, color: orangePrincipal),
                      SizedBox(height: 8),
                      Text('Réinitialisation',
                          style: TextStyle(
                              color: texteGris,
                              fontSize: 14,
                              fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 28),

              Text('Mot de passe oublié ?', style: _styleTitrePage()),
              const SizedBox(height: 8),
              const Text(
                'Pas de panique ! Entrez l\'adresse email associée à votre compte.',
                style: TextStyle(color: texteGris, fontSize: 14, height: 1.5),
              ),
              const SizedBox(height: 28),

              const _LabelChamp('Votre adresse email'),
              const SizedBox(height: 8),

              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(
                  hintText: 'exemple@email.com',
                  hintStyle: const TextStyle(color: texteGris),
                  prefixIcon: const Icon(Icons.email_outlined, color: texteGris),
                  suffixIcon: emailController.text.contains('@')
                      ? const Icon(Icons.check_circle, color: vertPrincipal)
                      : null,
                  filled: true,
                  fillColor: fondGris,
                  contentPadding:
                  const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: bordureGris)),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: bordureGris)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: vertPrincipal, width: 2)),
                ),
              ),

              if (erreur.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(erreur, style: const TextStyle(color: Colors.red, fontSize: 13)),
                ),

              const SizedBox(height: 28),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: envoyerOTP,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: vertPrincipal,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                  child: const Text('Get OTP',
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================
//  PAGE VERIFY OTP
// ============================================================
class PageVerifyOTP extends StatefulWidget {
  final String email;
  const PageVerifyOTP({super.key, required this.email});

  @override
  _PageVerifyOTPState createState() => _PageVerifyOTPState();
}

class _PageVerifyOTPState extends State<PageVerifyOTP> {
  final List<TextEditingController> otpControllers = List.generate(4, (_) => TextEditingController());
  final List<FocusNode> focusNodes = List.generate(4, (_) => FocusNode());
  String erreur      = '';
  int countdown      = 49;
  bool peutRenvoyer  = false;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    demarrerTimer();
  }

  void demarrerTimer() {
    setState(() { countdown = 49; peutRenvoyer = false; });
    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) { t.cancel(); return; }
      setState(() {
        countdown--;
        if (countdown <= 0) { peutRenvoyer = true; t.cancel(); }
      });
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    for (var c in otpControllers) c.dispose();
    for (var f in focusNodes) f.dispose();
    super.dispose();
  }

  void onDigit(String val, int i) {
    if (val.length == 1 && i < 3) focusNodes[i + 1].requestFocus();
    setState(() => erreur = '');
  }

  void onBackspace(int i) {
    if (otpControllers[i].text.isEmpty && i > 0) {
      focusNodes[i - 1].requestFocus();
      otpControllers[i - 1].clear();
    }
  }

  String get code => otpControllers.map((c) => c.text).join();

  void verifier() {
    if (code.length < 4) {
      setState(() => erreur = 'Entre les 4 chiffres !');
      return;
    }
    if (code != '1234') {
      setState(() => erreur = 'Code incorrect !');
      for (var c in otpControllers) c.clear();
      focusNodes[0].requestFocus();
      return;
    }
    Navigator.push(context, MaterialPageRoute(builder: (_) => const PageNouveauMdp()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: fondBlanc,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              Row(
                children: [
                  const _BoutonRetour(),
                  Expanded(
                    child: Center(
                      child: Text('Verify',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: texteNoir)),
                    ),
                  ),
                  const SizedBox(width: 40),
                ],
              ),
              const SizedBox(height: 30),

              Center(
                child: Container(
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    color: fondGris,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.verified_user_outlined,
                          size: 80, color: vertPrincipal),
                      SizedBox(height: 8),
                      Text('Vérification OTP', style: TextStyle(color: texteGris, fontSize: 14)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 28),

              Text('Enter OTP', style: _styleTitrePage()),
              const SizedBox(height: 8),
              const Text('Un code OTP à 4 chiffres a été envoyé à', style: TextStyle(color: texteGris, fontSize: 14)),
              const SizedBox(height: 4),
              Text(widget.email,
                  style: const TextStyle(
                      color: vertPrincipal,
                      fontWeight: FontWeight.bold,
                      fontSize: 14)),
              SizedBox(height: 32),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(4, (i) => _CaseOTP(
                  controller: otpControllers[i],
                  focusNode: focusNodes[i],
                  hasError: erreur.isNotEmpty,
                  onChanged: (v) => onDigit(v, i),
                  onBackspace: () => onBackspace(i),
                )),
              ),

              if (erreur.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Center(
                    child: Text(erreur, style: const TextStyle(color: Colors.red, fontSize: 13)),
                  ),
                ),

              const SizedBox(height: 32),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: verifier,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: vertPrincipal,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                  child: const Text('Verify',
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 20),

              Center(
                child: peutRenvoyer
                    ? GestureDetector(
                  onTap: () {
                    demarrerTimer();
                    for (var c in otpControllers) c.clear();
                    focusNodes[0].requestFocus();
                  },
                  child: const Text('Renvoyer OTP',
                      style: TextStyle(
                          color: orangePrincipal,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          decoration: TextDecoration.underline)),
                )
                    : RichText(
                  text: TextSpan(
                    text: 'Resend OTP ',
                    style: const TextStyle(color: texteGris, fontSize: 14),
                    children: [
                      TextSpan(
                        text: '(00:${countdown.toString().padLeft(2, '0')})',
                        style: const TextStyle(
                            color: orangePrincipal,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================
//  PAGE NOUVEAU MOT DE PASSE
// ============================================================
class PageNouveauMdp extends StatefulWidget {
  const PageNouveauMdp({super.key});

  @override
  _PageNouveauMdpState createState() => _PageNouveauMdpState();
}

class _PageNouveauMdpState extends State<PageNouveauMdp> {
  final TextEditingController mdpController     = TextEditingController();
  final TextEditingController confirmController = TextEditingController();
  bool voirMdp     = false;
  bool voirConfirm = false;
  String erreur    = '';

  void changerMdp() {
    if (mdpController.text.isEmpty || confirmController.text.isEmpty) {
      setState(() => erreur = 'Remplis les deux champs !');
    } else if (mdpController.text.length < 6) {
      setState(() => erreur = 'Minimum 6 caractères !');
    } else if (mdpController.text != confirmController.text) {
      setState(() => erreur = 'Les mots de passe ne correspondent pas !');
    } else {
      setState(() => erreur = '');
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  color: vertPrincipal.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check_circle_rounded, color: vertPrincipal, size: 44),
              ),
              const SizedBox(height: 16),
              Text('Bravo !', style: _styleTitrePage()),
              const SizedBox(height: 8),
              const Text('Votre mot de passe a bien été modifié.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: texteGris, fontSize: 14)),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).popUntil((r) => r.isFirst),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: vertPrincipal,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text('Se connecter',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    mdpController.dispose();
    confirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: fondBlanc,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              const _BoutonRetour(),
              const SizedBox(height: 28),

              _LogoMini(),
              const SizedBox(height: 20),
              Text('Register', style: _styleTitrePage()),
              const SizedBox(height: 6),
              const Text('Choisissez votre nouveau mot de passe',
                  style: TextStyle(color: texteGris, fontSize: 14)),
              const SizedBox(height: 32),

              const _LabelChamp('Nouveau mot de passe'),
              const SizedBox(height: 8),
              _ChampMdp(
                  controller: mdpController,
                  voir: voirMdp,
                  onToggle: () => setState(() => voirMdp = !voirMdp)),
              const SizedBox(height: 20),

              const _LabelChamp('Confirmer le mot de passe'),
              const SizedBox(height: 8),
              _ChampMdp(
                  controller: confirmController,
                  voir: voirConfirm,
                  hint: 'Retapez votre mot de passe',
                  onToggle: () => setState(() => voirConfirm = !voirConfirm)),

              if (erreur.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Text(erreur, style: const TextStyle(color: Colors.red, fontSize: 13)),
                ),

              const SizedBox(height: 28),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: changerMdp,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: vertPrincipal,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                  child: const Text('Sign Up',
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================
//  AJOUT ACCÈS : REDIRECTION VERS TON FILTRAGE PHARMACIE
// ============================================================
class PagePharmacie extends StatelessWidget {
  const PagePharmacie({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pharmacies de Garde', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: vertFonce,
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'Ici s\'affichera la liste moderne des pharmacies\nreliée à ton service API.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16, color: texteNoir),
        ),
      ),
    );
  }
}

// ============================================================
//  WIDGETS RÉUTILISABLES (Design Optimisé)
// ============================================================

class _BoutonPlein extends StatelessWidget {
  final String texte;
  final Color couleur;
  final VoidCallback onTap;
  const _BoutonPlein({required this.texte, required this.couleur, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: couleur,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 0,
        ),
        child: Text(texte,
            style: const TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }
}

class _BoutonContour extends StatelessWidget {
  final String texte;
  final VoidCallback onTap;
  const _BoutonContour({required this.texte, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: texteNoir, width: 1.5),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: Text(texte,
            style: const TextStyle(fontSize: 16, color: texteNoir, fontWeight: FontWeight.bold)),
      ),
    );
  }
}

class _BoutonSocial extends StatelessWidget {
  final IconData icone;
  final String texte;
  final Color couleurIcone;
  const _BoutonSocial({required this.icone, required this.texte, required this.couleurIcone});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: OutlinedButton.icon(
        onPressed: () {},
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: bordureGris),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          backgroundColor: fondBlanc,
        ),
        icon: Icon(icone, color: couleurIcone, size: 24),
        label: Text(texte,
            style: const TextStyle(color: texteNoir, fontSize: 14, fontWeight: FontWeight.w500)),
      ),
    );
  }
}

class _Separateur extends StatelessWidget {
  const _Separateur();
  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(child: Divider(color: bordureGris, thickness: 1)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: Text('Or', style: TextStyle(color: texteGris, fontSize: 13)),
        ),
        Expanded(child: Divider(color: bordureGris, thickness: 1)),
      ],
    );
  }
}

class _LogoMini extends StatelessWidget {
  const _LogoMini();
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
            colors: [vertPrincipal, vertFonce],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight),
        borderRadius: BorderRadius.circular(14),
      ),
      child: const Icon(Icons.health_and_safety, color: Colors.white, size: 28),
    );
  }
}

class _BoutonRetour extends StatelessWidget {
  const _BoutonRetour();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: fondGris,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: bordureGris),
        ),
        child: const Icon(Icons.arrow_back_ios_new_rounded, size: 18, color: texteNoir),
      ),
    );
  }
}

class _LabelChamp extends StatelessWidget {
  final String texte;
  const _LabelChamp(this.texte);

  @override
  Widget build(BuildContext context) {
    return Text(texte,
        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: texteNoir));
  }
}

class _ChampTexte extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final IconData icone;
  final TextInputType clavier;
  const _ChampTexte({
    required this.controller,
    required this.hint,
    required this.icone,
    this.clavier = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: clavier,
      decoration: _decoration(hint, icone),
    );
  }
}

class _ChampMdp extends StatelessWidget {
  final TextEditingController controller;
  final bool voir;
  final VoidCallback onToggle;
  final String hint;
  const _ChampMdp({
    required this.controller,
    required this.voir,
    required this.onToggle,
    this.hint = '••••••••••••',
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: !voir,
      decoration: _decoration(hint, Icons.lock_outline).copyWith(
        suffixIcon: IconButton(
          icon: Icon(voir ? Icons.visibility : Icons.visibility_off, color: texteGris),
          onPressed: onToggle,
        ),
      ),
    );
  }
}

InputDecoration _decoration(String hint, IconData icone) {
  return InputDecoration(
    hintText: hint,
    hintStyle: const TextStyle(color: texteGris, fontSize: 14),
    prefixIcon: Icon(icone, color: texteGris, size: 20),
    filled: true,
    fillColor: fondGris,
    contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
    border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: bordureGris)),
    enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: bordureGris)),
    focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: vertPrincipal, width: 2)),
  );
}

TextStyle _styleTitrePage() {
  return const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: texteNoir);
}

class _CaseOTP extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final bool hasError;
  final ValueChanged<String> onChanged;
  final VoidCallback onBackspace;
  const _CaseOTP({
    required this.controller,
    required this.focusNode,
    required this.hasError,
    required this.onChanged,
    required this.onBackspace,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 68,
      height: 68,
      child: KeyboardListener(
        focusNode: FocusNode(),
        onKeyEvent: (e) {
          if (e is KeyDownEvent && e.logicalKey == LogicalKeyboardKey.backspace) {
            onBackspace();
          }
        },
        child: TextField(
          controller: controller,
          focusNode: focusNode,
          maxLength: 1,
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: texteNoir),
          decoration: InputDecoration(
            counterText: '',
            filled: true,
            fillColor: fondGris,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: hasError ? Colors.red : bordureGris, width: 1.5)),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: hasError ? Colors.red : bordureGris, width: 1.5)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: vertPrincipal, width: 2)),
          ),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
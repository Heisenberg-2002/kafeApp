class Kafe {
  final String id;
  final String nom;
  final int cout;
  final int dureePousse;
  final int rendementFruit;
  final int gout;
  final int amertume;
  final int teneur;
  final int odorat;
  final String avatar;

  Kafe({
    required this.id,
    required this.nom,
    required this.cout,
    required this.dureePousse,
    required this.rendementFruit,
    required this.gout,
    required this.amertume,
    required this.teneur,
    required this.odorat,
    required this.avatar,
  });

  factory Kafe.fromMap(String id, Map<String, dynamic> data) {
    return Kafe(
      id: id,
      nom: data['nom'] ?? '',
      cout: data['cout'] ?? 0,
      dureePousse: data['duree_pousse'] ?? 0,
      rendementFruit: data['rendement_fruit'] ?? 0,
      gout: data['gout'] ?? 0,
      amertume: data['amertume'] ?? 0,
      teneur: data['teneur'] ?? 0,
      odorat: data['odorat'] ?? 0,
      avatar: data['avatar'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nom': nom,
      'cout': cout,
      'duree_pousse': dureePousse,
      'rendement_fruit': rendementFruit,
      'gout': gout,
      'amertume': amertume,
      'teneur': teneur,
      'odorat': odorat,
      'avatar': avatar,
    };
  }
}

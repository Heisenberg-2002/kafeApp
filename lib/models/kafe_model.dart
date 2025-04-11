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
      cout: data['cout'] is int
          ? data['cout']
          : int.tryParse(data['cout'].toString()) ?? 0,
      dureePousse: data['duree_pousse'] is int
          ? data['duree_pousse']
          : int.tryParse(data['duree_pousse'].toString()) ?? 0,
      rendementFruit: data['rendement_fruit'] is int
          ? data['rendement_fruit']
          : int.tryParse(data['rendement_fruit'].toString()) ?? 0,
      gout: data['gout'] is int
          ? data['gout']
          : int.tryParse(data['gout'].toString()) ?? 0,
      amertume: data['amertume'] is int
          ? data['amertume']
          : int.tryParse(data['amertume'].toString()) ?? 0,
      teneur: data['teneur'] is int
          ? data['teneur']
          : int.tryParse(data['teneur'].toString()) ?? 0,
      odorat: data['odorat'] is int
          ? data['odorat']
          : int.tryParse(data['odorat'].toString()) ?? 0,
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

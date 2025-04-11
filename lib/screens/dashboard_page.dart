import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kafe/screens/kafes_list_page.dart';
import 'champ_page.dart';
import 'sechage_page.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final userDoc =
        FirebaseFirestore.instance.collection('joueurs').doc(user?.uid);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8F8DC),
        title: const Text('Tableau de bord'),
        centerTitle: true,
      ),
      backgroundColor: const Color(0xFFF8F8DC),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: StreamBuilder<DocumentSnapshot>(
          stream: userDoc.snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text('Erreur: ${snapshot.error}'));
            }

            if (!snapshot.hasData || !snapshot.data!.exists) {
              return const Center(child: Text('Utilisateur non trouvé'));
            }

            final userData = snapshot.data!.data() as Map<String, dynamic>;
            final firstName = userData['prenom'] ?? 'Utilisateur inconnu';
            final lastName = userData['nom'] ?? '';
            final deevee = userData['deevee'] ?? 0;
            final grains_or = userData['grains_or'] ?? 0;
            final avatarUrl = userData['avatar'] ??
                'https://cdn-icons-png.flaticon.com/512/147/147144.png';

            return Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundImage: NetworkImage(avatarUrl),
                      backgroundColor: Colors.grey.shade200,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      // <-- pour éviter l'overflow
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('$firstName $lastName',
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                          Row(
                            children: [
                              const Icon(Icons.diamond, color: Colors.blue),
                              const SizedBox(width: 5),
                              Text('$deevee DeeVee',
                                  style: const TextStyle(fontSize: 14)),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                        width: 10), // petit espace avant les infos de droite
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.monetization_on,
                                color: Colors.amber),
                            const SizedBox(width: 5),
                            Text('Grains d\'Or : $grains_or',
                                style: const TextStyle(fontSize: 14)),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Row(
                          children: const [
                            Icon(Icons.emoji_events, color: Colors.orange),
                            SizedBox(width: 5),
                            Text('CMTM dans 15 min',
                                style: TextStyle(fontSize: 14)),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildDashboardButton(context, 'Mes Champs', () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ChampsPage()),
                        );
                      }),
                      _buildDashboardButton(context, 'Torréfaction', () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const KafesListPage()),
                        );
                      }),
                      _buildDashboardButton(context, 'Assemblages'),
                      _buildDashboardButton(context, 'Concours CMTM'),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.brown,
                          foregroundColor: Colors.white,
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero,
                          ),
                        ),
                        child: const Text("Acheter un champ"),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildDashboardButton(BuildContext context, String title,
      [VoidCallback? onPressed]) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          minimumSize: const Size(double.infinity, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
            side: BorderSide(color: Colors.brown),
          ),
        ),
        child: Text(title),
      ),
    );
  }
}

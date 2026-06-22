import 'package:flutter/material.dart';
import 'models.dart';
import 'storage.dart';
import 'game_detail_screen.dart';
import 'admin_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // On garde en mémoire le dernier tirage de chaque jeu pour l'affichage
  final Map<String, Draw?> _lastDraws = {};

  @override
  void initState() {
    super.initState();
    _loadLastDraws();
  }

  Future<void> _loadLastDraws() async {
    for (final game in allGames) {
      final last = await DrawStorage.getLastDrawForGame(game.id);
      setState(() => _lastDraws[game.id] = last);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Loto Togo - Les 12 jeux'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_note),
            tooltip: 'Saisir un résultat',
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AdminScreen()),
              );
              _loadLastDraws(); // rafraîchir après une nouvelle saisie
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadLastDraws,
        child: ListView(
          padding: const EdgeInsets.all(12),
          children: joursSemaine
              .where((jour) => allGames.any((g) => g.dayOfWeek == jour))
              .map((jour) => _buildJourSection(jour))
              .toList(),
        ),
      ),
    );
  }

  Widget _buildJourSection(String jour) {
    final gamesDuJour = allGames.where((g) => g.dayOfWeek == jour).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 12, bottom: 6, left: 4),
          child: Text(
            jour.toUpperCase(),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.green,
            ),
          ),
        ),
        ...gamesDuJour.map(_buildGameCard),
      ],
    );
  }

  Widget _buildGameCard(Game game) {
    final lastDraw = _lastDraws[game.id];
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.green.shade700,
          child: Text(game.time.substring(0, 2)),
        ),
        title: Text(game.name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(
          lastDraw == null
              ? 'Tirage à ${game.time} — pas encore de résultat'
              : 'Dernier résultat (${lastDraw.date}) : ${lastDraw.numbers.join(" - ")}',
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => GameDetailScreen(game: game)),
          );
        },
      ),
    );
  }
}

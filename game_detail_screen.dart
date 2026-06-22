import 'package:flutter/material.dart';
import 'models.dart';
import 'storage.dart';

class GameDetailScreen extends StatefulWidget {
  final Game game;
  const GameDetailScreen({super.key, required this.game});

  @override
  State<GameDetailScreen> createState() => _GameDetailScreenState();
}

class _GameDetailScreenState extends State<GameDetailScreen> {
  List<Draw> _draws = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final draws = await DrawStorage.getDrawsForGame(widget.game.id);
    setState(() {
      _draws = draws;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final game = widget.game;
    return Scaffold(
      appBar: AppBar(
        title: Text(game.name),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  color: Colors.green.shade50,
                  child: Text(
                    'Tirage : ${game.dayOfWeek.toUpperCase()} à ${game.time}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: _draws.isEmpty
                      ? const Center(child: Text('Aucun résultat enregistré pour ce jeu.'))
                      : ListView.builder(
                          padding: const EdgeInsets.all(12),
                          itemCount: _draws.length,
                          itemBuilder: (context, index) {
                            final draw = _draws[index];
                            return Card(
                              child: ListTile(
                                title: Text(draw.date),
                                subtitle: Wrap(
                                  spacing: 8,
                                  children: draw.numbers
                                      .map((n) => CircleAvatar(
                                            radius: 16,
                                            backgroundColor: Colors.green.shade700,
                                            child: Text(
                                              '$n',
                                              style: const TextStyle(color: Colors.white, fontSize: 12),
                                            ),
                                          ))
                                      .toList(),
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }
}

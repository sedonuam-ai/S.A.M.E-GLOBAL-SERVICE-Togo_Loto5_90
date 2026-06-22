import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'models.dart';

/// Gère la sauvegarde et la lecture des tirages sur le téléphone (stockage local).
/// Plus tard, tu pourras remplacer ce fichier par une version connectée à Firebase
/// sans changer le reste de l'application.
class DrawStorage {
  static const _storageKey = 'draws_list';

  /// Récupère tous les tirages enregistrés
  static Future<List<Draw>> getAllDraws() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_storageKey);
    if (raw == null) return [];
    final List<dynamic> decoded = jsonDecode(raw);
    return decoded.map((e) => Draw.fromJson(e as Map<String, dynamic>)).toList();
  }

  /// Ajoute un nouveau tirage et le sauvegarde
  static Future<void> addDraw(Draw draw) async {
    final draws = await getAllDraws();
    draws.add(draw);
    await _saveAll(draws);
  }

  /// Récupère tous les tirages d'un jeu précis, triés du plus récent au plus ancien
  static Future<List<Draw>> getDrawsForGame(String gameId) async {
    final draws = await getAllDraws();
    final filtered = draws.where((d) => d.gameId == gameId).toList();
    filtered.sort((a, b) => b.date.compareTo(a.date));
    return filtered;
  }

  /// Récupère le dernier tirage enregistré pour un jeu (ou null si aucun)
  static Future<Draw?> getLastDrawForGame(String gameId) async {
    final draws = await getDrawsForGame(gameId);
    return draws.isEmpty ? null : draws.first;
  }

  static Future<void> _saveAll(List<Draw> draws) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(draws.map((d) => d.toJson()).toList());
    await prefs.setString(_storageKey, encoded);
  }
}

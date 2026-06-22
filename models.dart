// Modèles de données de l'application

/// Représente un jeu de Loto 5/90 (ex: Lotto Diamant, Loto Gold...)
class Game {
  final String id;
  final String name;
  final String dayOfWeek; // lundi, mardi, mercredi, jeudi, vendredi, samedi
  final String time; // "13:00" ou "18:00"

  const Game({
    required this.id,
    required this.name,
    required this.dayOfWeek,
    required this.time,
  });
}

/// Représente un tirage : les 5 numéros gagnants d'un jeu à une date donnée
class Draw {
  final String gameId;
  final String date; // format "yyyy-MM-dd"
  final List<int> numbers; // 5 numéros entre 1 et 90

  const Draw({
    required this.gameId,
    required this.date,
    required this.numbers,
  });

  Map<String, dynamic> toJson() => {
        'gameId': gameId,
        'date': date,
        'numbers': numbers,
      };

  factory Draw.fromJson(Map<String, dynamic> json) => Draw(
        gameId: json['gameId'] as String,
        date: json['date'] as String,
        numbers: List<int>.from(json['numbers'] as List),
      );
}

/// Liste fixe des 12 jeux du Togo (programme officiel des tirages)
const List<Game> allGames = [
  Game(id: 'lotto-diamant', name: 'Lotto Diamant', dayOfWeek: 'lundi', time: '13:00'),
  Game(id: 'loto-gold', name: 'Loto Gold', dayOfWeek: 'lundi', time: '18:00'),
  Game(id: 'loto-cash', name: 'Loto Cash', dayOfWeek: 'mardi', time: '13:00'),
  Game(id: 'loto-boom', name: 'Loto Boom', dayOfWeek: 'mardi', time: '18:00'),
  Game(id: 'loto-benz', name: 'Loto Benz', dayOfWeek: 'mercredi', time: '13:00'),
  Game(id: 'loto-prestige', name: 'Loto Prestige', dayOfWeek: 'mercredi', time: '18:00'),
  Game(id: 'loto-million', name: 'Loto Million', dayOfWeek: 'jeudi', time: '13:00'),
  Game(id: 'loto-super', name: 'Loto Super', dayOfWeek: 'jeudi', time: '18:00'),
  Game(id: 'loto-kadoo', name: 'Loto Kadoo', dayOfWeek: 'vendredi', time: '13:00'),
  Game(id: 'loto-king', name: 'Loto King', dayOfWeek: 'vendredi', time: '18:00'),
  Game(id: 'loto-sam', name: 'Loto Sam', dayOfWeek: 'samedi', time: '13:00'),
  Game(id: 'loto-bingo', name: 'Loto Bingo', dayOfWeek: 'samedi', time: '18:00'),
];

/// Jours de la semaine dans l'ordre, en français, pour le tri/affichage
const List<String> joursSemaine = [
  'lundi',
  'mardi',
  'mercredi',
  'jeudi',
  'vendredi',
  'samedi',
  'dimanche',
];

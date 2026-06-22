import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'models.dart';
import 'storage.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  final _formKey = GlobalKey<FormState>();
  Game? _selectedGame;
  DateTime _selectedDate = DateTime.now();
  final List<TextEditingController> _numberControllers =
      List.generate(5, (_) => TextEditingController());

  @override
  void dispose() {
    for (final c in _numberControllers) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate() || _selectedGame == null) {
      if (_selectedGame == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Choisis un jeu avant de valider.')),
        );
      }
      return;
    }

    final numbers = _numberControllers.map((c) => int.parse(c.text)).toList();

    final draw = Draw(
      gameId: _selectedGame!.id,
      date: DateFormat('yyyy-MM-dd').format(_selectedDate),
      numbers: numbers,
    );

    await DrawStorage.addDraw(draw);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Résultat enregistré pour ${_selectedGame!.name} !')),
    );

    // Réinitialiser le formulaire pour une nouvelle saisie
    for (final c in _numberControllers) {
      c.clear();
    }
    setState(() => _selectedGame = null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Saisir un résultat')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const Text(
                'Choisis le jeu concerné :',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<Game>(
                value: _selectedGame,
                hint: const Text('Sélectionner un jeu parmi les 12'),
                items: allGames
                    .map((g) => DropdownMenuItem(
                          value: g,
                          child: Text('${g.name} (${g.dayOfWeek} ${g.time})'),
                        ))
                    .toList(),
                onChanged: (g) => setState(() => _selectedGame = g),
              ),
              const SizedBox(height: 20),
              const Text(
                'Date du tirage :',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              OutlinedButton.icon(
                icon: const Icon(Icons.calendar_today),
                label: Text(DateFormat('dd/MM/yyyy').format(_selectedDate)),
                onPressed: _pickDate,
              ),
              const SizedBox(height: 20),
              const Text(
                'Les 5 numéros gagnants (entre 1 et 90) :',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Row(
                children: List.generate(5, (i) {
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: TextFormField(
                        controller: _numberControllers[i],
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        decoration: const InputDecoration(border: OutlineInputBorder()),
                        validator: (value) {
                          if (value == null || value.isEmpty) return 'Requis';
                          final n = int.tryParse(value);
                          if (n == null || n < 1 || n > 90) return '1-90';
                          return null;
                        },
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  backgroundColor: Colors.green.shade700,
                ),
                onPressed: _save,
                child: const Text(
                  'Enregistrer le résultat',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

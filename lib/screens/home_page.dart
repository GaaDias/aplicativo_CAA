import 'package:flutter/material.dart';
import '../models/cards.dart';
import 'communication.dart';
import 'settings.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Cards> buttons = [Cards("", Colors.white, Icons.add)]; // Apenas o ícone de "+"

  List<String> selectedWords = [];
  int _selectedIndex = 0;
  bool _isMenuVisible = false;

  void addWord(String word) {
    setState(() {
      selectedWords.add(word);
    });
  }

  void clearWords() {
    setState(() {
      selectedWords.clear();
    });
  }

  void _toggleMenu() {
    setState(() {
      _isMenuVisible = !_isMenuVisible;
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _addNewCard() {
    showDialog(
      context: context,
      builder: (context) {
        String label = "";
        IconData selectedIcon = Icons.person;
        Color selectedColor = Colors.white;
        final List<IconData> icons = [
          Icons.person,
          Icons.home,
          Icons.favorite,
          Icons.thumb_up,
          Icons.star,
          Icons.cake,
          Icons.access_alarm,
        ];
        final List<Color> colors = [
          Colors.white,
          Colors.red,
          Colors.blue,
          Colors.green,
          Colors.yellow,
          Colors.orange,
          Colors.purple,
        ];

        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text("Personalizar Card"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    onChanged: (value) => label = value,
                    decoration: InputDecoration(labelText: "Palavra"),
                  ),
                  const SizedBox(height: 16),
                  Text("Selecione um Ícone"),
                  Wrap(
                    spacing: 8,
                    children: icons.map((icon) {
                      return GestureDetector(
                        onTap: () {
                          setDialogState(() {
                            selectedIcon = icon;
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: selectedIcon == icon ? Colors.grey[300] : null,
                          ),
                          child: Icon(icon, color: Colors.black),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                  Text("Selecione uma Cor"),
                  Wrap(
                    spacing: 8,
                    children: colors.map((color) {
                      return GestureDetector(
                        onTap: () {
                          setDialogState(() {
                            selectedColor = color;
                          });
                        },
                        child: Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: selectedColor == color ? Colors.black : Colors.transparent,
                              width: 2,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text("Cancelar"),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (label.isNotEmpty) {
                      setState(() {
                        buttons.insert(
                          buttons.length - 1,
                          Cards(label, selectedColor, selectedIcon),
                        );
                      });
                      Navigator.of(context).pop(); // Fecha o pop-up após salvar
                    }
                  },
                  child: Text("Salvar"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF4C4C4C),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        leadingWidth: 100,
        leading: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.menu),
              onPressed: _toggleMenu,
              tooltip: 'Menu',
            ),
            IconButton(
              icon: const Icon(Icons.home),
              onPressed: () {
                _onItemTapped(0);
              },
              tooltip: 'Home',
            ),
          ],
        ),
        title: Text(
          _selectedIndex == 0 ? 'Comunicação' : 'Configurações',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.print),
            onPressed: () {
              // Ação para imprimir
            },
            tooltip: 'Imprimir',
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              _onItemTapped(1);
            },
            tooltip: 'Configurações',
          ),
        ],
      ),
      body: _selectedIndex == 0
          ? Communication(
              buttons: buttons,
              selectedWords: selectedWords,
              addWord: addWord,
              clearWords: clearWords,
              addNewCard: _addNewCard,
              isMenuVisible: _isMenuVisible,
              toggleMenu: _toggleMenu,
            )
          : Settings(),
    );
  }
}
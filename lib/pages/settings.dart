import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:smart_gloves_01/services/data_provider.dart';
import 'package:smart_gloves_01/services/theme_provider.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Impostazioni",
          style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.dark_mode),
            title: const Text("Tema Scuro"),
            trailing: Switch(
              value:
                  Provider.of<ThemeProvider>(context).themeMode ==
                  ThemeMode.dark,
              onChanged: (bool value) {
                Provider.of<ThemeProvider>(
                  context,
                  listen: false,
                ).toggleTheme(value);
              },
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              decoration: const InputDecoration(
                labelText: "Imposta soglia",
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly,
              ],
              onSubmitted: (value) {
                int? nuovaSoglia = int.tryParse(value) ?? 80;
                context.read<DataProvider>().aggiornaSoglia(nuovaSoglia);
              },
            ),
          ),
        ],
      ),
    );
  }
}

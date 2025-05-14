import 'package:flutter/material.dart';

class Guide extends StatelessWidget {
  const Guide({super.key});

  // Funzione per creare un widget bullet point
  Widget _bullet(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("• ", style: TextStyle(fontSize: 16)),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView( 
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Text(
                'Guida rapida all\'uso',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const Divider(),
          const Text(
            'Benvenuto nella guida rapida all\'uso del sistema Smart Gloves. Di seguito trovi alcune istruzioni fondamentali per iniziare:',
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 16),
          const Text(
            'Come connettere il guanto:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          _bullet("Accendi il guanto e assicurati che sia in modalità di accoppiamento (luce verde)."),
          _bullet("Nella sezione \"Dispositivi\" clicca sull'icona \"🔍\" e scorri fino a trovare la connessione \"Smart Gloves WiFi\"."),
          _bullet("Digita la password (\"12345678\") e clicca su Connetti."),
          _bullet("Se la connessione ha successo la luce cambierà colore e diventerà blu."),
          const SizedBox(height: 16),
          const Text(
            'Suggerimenti utili:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          _bullet("Assicurati che il guanto sia indossato correttamente e che sia acceso."),
          _bullet("Assicurati che le batterie del guanto non siano scariche."),
          _bullet("Fai una breve prova del rumore intorno a te nella sezione \"Audio\" - premendo il pulsante \"🎤\" - e imposta una soglia del rumore adeguata nelle impostazioni."),
          _bullet("Se hai altre domande o riscontri un problema con il guanto, non esitare a contattarmi tramite email o social media."),
          const SizedBox(height: 24),
          Center(
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Chiudi'),
            ),
          ),
        ],
      ),
    );
  }
}
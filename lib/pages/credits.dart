import 'package:flutter/material.dart';

class Credits extends StatefulWidget {
  const Credits({super.key});

  @override
  State<Credits> createState() => _CreditsState();
}

class _CreditsState extends State<Credits> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(25.0),
        children: [
          
          Text("Crediti e sviluppo", style: const TextStyle(fontSize: 35, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
          SizedBox(height: 30),
          Text("Questa applicazione è la piattaforma software per il prototipo Smart Gloves, un dispositivo innovativo progettato per aiutare le persone con difficoltà uditive o non udenti a percepire rumori pericolosi in ambienti affollati.", style: const TextStyle(fontSize: 20), textAlign: TextAlign.justify),
          SizedBox(height: 10),
          Text("L'app e il guanto fisico sono stati ideati, progettati e sviluppati dal sottoscritto, Kujto Fetahi, studente di elettronica dell'Istituto Valle Seriana di Gazzaniga.", style: const TextStyle(fontSize: 20), textAlign: TextAlign.justify),
          SizedBox(height: 10),
          Text("Questo progetto nasce con un obiettivo semplice ma potente: rendere il mondo più accessibile alle persone sorde. Il mio guanto intelligente è in grado di rilevare suoni forti o importanti, analizzarli in tempo reale e tradurli in vibrazioni tattili, permettendo a chi non può sentire di percepire ciò che accade intorno", style: const TextStyle(fontSize: 20), textAlign: TextAlign.justify),
          SizedBox(height: 10),
          Text("Spero possa aiutare tante persone in futuro.", style: const TextStyle(fontSize: 20), textAlign: TextAlign.justify),
          SizedBox(height: 10),
          Text("Ogni segnalazione di bug, migliorie e consigli saranno caldamente apprezzati", style: const TextStyle(fontSize: 20), textAlign: TextAlign.justify),       
          SizedBox(height: 10),
          Text("Grazie per aver provato la mia app, 😊", style: const TextStyle(fontSize: 20), textAlign: TextAlign.justify),    
          Text("Kujto 🤙🏼", style: const TextStyle(fontSize: 20), textAlign: TextAlign.justify),    
          SizedBox(height: 30),
        ],

      )
    );
  }
}
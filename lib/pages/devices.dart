import 'dart:async';
import 'package:flutter/material.dart';
import 'package:wifi_scan/wifi_scan.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wifi_iot/wifi_iot.dart';
import 'package:smart_gloves_01/services/shared_variables.dart';

class Devices extends StatefulWidget {
  const Devices({super.key});

  @override
  State<Devices> createState() => _DevicesState();
}

class _DevicesState extends State<Devices> {
  List<WiFiAccessPoint> wifiNetworks = [];
  String networkPassword = "";
  String? _connectedSSID;

  @override
  void initState() {
    super.initState();
    requestPermissions();
  }

  Future<void> requestPermissions() async {
    await Permission.location.request();
  }

  Future<void> scanWifi() async {
    if (_connectedSSID != null) return; // Non scansionare se già connesso
    final canScan = await WiFiScan.instance.canStartScan();
    if (canScan == CanStartScan.yes) {
      await WiFiScan.instance.startScan();
      fetchNetworks();
    }
  }

  Future<void> fetchNetworks() async {
    final results = await WiFiScan.instance.getScannedResults();
    setState(() {
      wifiNetworks = results;
    });
  }

  Future<void> connectToWifi(String ssid, String password) async {
    final success = await WiFiForIoTPlugin.connect(
      ssid,
      password: password,
      security: NetworkSecurity.WPA,
      joinOnce: true,
      withInternet: true,
    );

    if (success) {
      setState(() {
        _connectedSSID = ssid;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Connesso a $ssid")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Connessione a $ssid fallita")),
      );
    }
  }

  Future<void> disconnectFromWifi() async {
    await WiFiForIoTPlugin.disconnect();
    setState(() {
      _connectedSSID = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Dispositivi",
          style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          // Messaggio e pulsante se connesso a Strix_WiFi
          if (_connectedSSID == "Strix_WiFi") ...[
            Text(
              "Connessione effettuata a Strix_WiFi",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              "Attenzione: se si presentano problemi di rete, prova a connettere il WiFi dalle impostazioni del dispositivo.",
              style: TextStyle(fontSize: 14, color: Colors.red),
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: disconnectFromWifi,
              icon: Icon(Icons.wifi_off),
              label: Text("Disconnetti"),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            ),
            SizedBox(height: 40),

          ],

          // Tre pulsanti centrali
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (int i = 1; i <= 3; i++) // Crea tre pulsanti
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: ElevatedButton(
                  onPressed: _connectedSSID == "Strix_WiFi"   // Abilita solo se connesso
                        ? () { 
                            // Esegui l'azione corrispondente al pulsante
                            
                            EspService.activatePin(i);
                          }
                        : null, // Disabilita se non connesso
                    child: Text("$i"),
                    style: ElevatedButton.styleFrom(
                      shape: CircleBorder(),
                      padding: EdgeInsets.all(24),
                    ),
                  ),
                ),
            ],
          ),

          SizedBox(height: 30),

          // Pulsante per avviare la scansione WiFi
          ElevatedButton(
            onPressed: scanWifi,
            child: const Icon(Icons.search),
          ),

          // Lista reti trovate
          Expanded(
            child: ListView.builder(
              itemCount: _connectedSSID != null ? 0 : wifiNetworks.length,
              itemBuilder: (context, index) {
                final network = wifiNetworks[index]; 
                return ListTile(
                  title: Text(network.ssid),
                  subtitle: Text("Potenza: ${network.level} dBm"),
                  leading: Icon(Icons.wifi, color: Colors.deepOrange),
                  onTap: () {
                    showDialog( 
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text("Connetti a ${network.ssid}"),
                        content: TextField(
                          obscureText: true,
                          decoration: InputDecoration(labelText: 'Password'),
                          onChanged: (value) {
                            networkPassword = value;
                          },
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text("Annulla"),
                          ),
                          TextButton(
                            onPressed: () {
                              connectToWifi(network.ssid, networkPassword);
                              Navigator.pop(context);
                            },
                            child: Text("Connetti"),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
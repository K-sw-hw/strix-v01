/// Pagina per la visualizzazione dell'audio
/// Due grafici:
///   - tempo/dB = visualizzazione grafica rumore (refresh: 15s)            top screen
///   - tempo/soglia = visualizzazione superamento soglia (refresh: 2s)     bottom right
/// Testo: valori di rumore + superamento soglia
///   Pulsante reset                                                        bottom left

import 'dart:async';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:noise_meter/noise_meter.dart';
import 'package:provider/provider.dart';
import 'package:smart_gloves_01/services/data_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:smart_gloves_01/services/shared_variables.dart';

class Spectrometer extends StatefulWidget {
  const Spectrometer({super.key});

  @override
  State<Spectrometer> createState() => _SpectrometerState();
}

class _SpectrometerState extends State<Spectrometer> {
  bool _isRecording = false;
  NoiseReading? _latestReading;
  StreamSubscription<NoiseReading>? _noiseSubscription;
  NoiseMeter? noiseMeter;
  final List<FlSpot> _noiseData = [];
  final List<FlSpot> _thresholdData = [];

  bool alertNoise = false;
  Timer? _timer;
  Timer? _resetTimer;
  int _timeIndex = 0;
  static const chartLimit = 100;

  @override
  void dispose() {
    _noiseSubscription?.cancel();
    _timer?.cancel();
    _resetTimer?.cancel();
    super.dispose();
  }

  void onData(NoiseReading noiseReading) {
    setState(() {
      _latestReading = noiseReading;
      _updateNoiseData(noiseReading.meanDecibel);

      if (noiseReading.meanDecibel >= 125) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const FullScreenAlert(),
          ),
        );
      }
    });
  }

  void onError(Object error) {
    stop();
  }

  Future<bool> checkPermission() async => await Permission.microphone.isGranted;
  Future<void> requestPermission() async => await Permission.microphone.request();

  Future<void> start() async {
    noiseMeter ??= NoiseMeter();
    if (!(await checkPermission())) await requestPermission();

    _noiseSubscription = noiseMeter?.noise.listen(onData, onError: onError);
    setState(() => _isRecording = true);

    _timer = Timer.periodic(Duration(milliseconds: 200), (timer) {
      if (_latestReading != null) {
        final value = _latestReading!.meanDecibel;
        final currentThreshold = Provider.of<DataProvider>(context, listen: false).soglia;
        final shared = Provider.of<SharedVariables>(context, listen: false);
        final bool newAlertState = value >= currentThreshold;
        shared.sogliaSuperata = newAlertState;

        setState(() {
          _noiseData.add(FlSpot(_timeIndex.toDouble(), value));
          _thresholdData.add(FlSpot(_timeIndex.toDouble(), newAlertState ? 1 : 0));
          alertNoise = newAlertState;
          _timeIndex++;

          if (_noiseData.length > chartLimit) _noiseData.removeAt(0);
          if (_thresholdData.length > chartLimit) _thresholdData.removeAt(0);
        });
      }
    });

    _resetTimer?.cancel();
    _resetTimer = Timer.periodic(Duration(seconds: 15), (timer) {
      clearGraph();
    });
  }

  void stop() {
    _noiseSubscription?.cancel();
    _timer?.cancel();
    _resetTimer?.cancel();
    setState(() => _isRecording = false);
  }

void _updateNoiseData(double value) {
  final currentThreshold = Provider.of<DataProvider>(context, listen: false).soglia;
  final shared = Provider.of<SharedVariables>(context, listen: false);

  bool newAlertState = value >= currentThreshold;
  shared.sogliaSuperata = newAlertState;

  _noiseData.add(FlSpot(_timeIndex.toDouble(), value));
  _thresholdData.add(FlSpot(_timeIndex.toDouble(), newAlertState ? 1 : 0));

  alertNoise = newAlertState;
  _timeIndex++;

  if (_noiseData.length > chartLimit) _noiseData.removeAt(0);
  if (_thresholdData.length > chartLimit) _thresholdData.removeAt(0);
}

    double? getAverageDecibelPlus25() {
    if (_noiseData.isEmpty) return null;

    double sum = 0;
    for (final spot in _noiseData) {
      sum += spot.y;
    }

    return (sum / _noiseData.length) + 25;
  }

  void clearGraph() {
    setState(() {
      _noiseData.clear();
      _thresholdData.clear();
      _timeIndex = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // GRAFICO SUPERIORE - Rumore
          Expanded(
            flex: 1,
            child: Container(
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: Colors.deepOrangeAccent, width: 2)),
              ),
              width: MediaQuery.of(context).size.width * 0.95,
              child: LineChart(
                LineChartData(
                  lineBarsData: [
                    LineChartBarData(
                      spots: _noiseData,
                      gradient: const LinearGradient(
                        colors: [Colors.deepOrangeAccent, Color.fromARGB(255, 126, 104, 250)],
                      ),
                      barWidth: 3,
                      isCurved: true,
                      curveSmoothness: 0.5,
                    ),
                  ],
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(axisNameWidget: const Text("Tempo (ms)")),
                    rightTitles: AxisTitles(axisNameWidget: const Text("Rumore (dB)")),
                  ),
                  borderData: FlBorderData(show: false),
                  gridData: FlGridData(show: true),
                  minY: 55,
                ),
              ),
            ),
          ),

          // PARTE INFERIORE - Testi + Grafico soglia
          Expanded(
            flex: 1,
            child: Row(
              children: [
                // TESTI + RESET
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Noise: ${_latestReading?.meanDecibel.toStringAsFixed(2) ?? "--"} dB',
                          style: const TextStyle(fontSize: 18, color: Colors.blueGrey, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Max: ${_latestReading?.maxDecibel.toStringAsFixed(2) ?? "--"} dB',
                          style: const TextStyle(fontSize: 18, color: Colors.blueGrey, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Soglia consigliata: ${getAverageDecibelPlus25()?.toStringAsFixed(2) ?? "--"} dB',
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blueGrey),
                        ),
                        Text(
                          'Soglia superata: ${alertNoise ? "SI" : "NO"}',
                          style: TextStyle(fontSize: 18, color: alertNoise ? Colors.red : Colors.blueGrey, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 15),
                        ElevatedButton(
                          onPressed: clearGraph,
                          child: const Text("Pulisci Grafico"),
                        ),
                      ],
                    ),
                  ),
                ),

                // GRAFICO SOGLIA
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 100,
                          child: LineChart(
                            LineChartData(
                              lineBarsData: [
                                LineChartBarData(
                                  spots: _thresholdData,
                                  isCurved: false,
                                  gradient: const LinearGradient(
                                    colors: [Color.fromARGB(255, 209, 106, 74), Color.fromARGB(255, 133, 23, 23)],
                                  ),
                                  barWidth: 3,
                                  belowBarData: BarAreaData(show: false),
                                ),
                              ],
                              titlesData: FlTitlesData(
                                bottomTitles: AxisTitles(axisNameWidget: const Text("Tempo (ms)")),
                                leftTitles: AxisTitles(axisNameWidget: const Text("Soglia")),
                              ),
                              borderData: FlBorderData(show: false),
                              gridData: FlGridData(show: false),
                              minY: 0,
                              maxY: 1,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: _isRecording ? Colors.deepOrangeAccent : const Color.fromARGB(255, 99, 184, 3),
        onPressed: _isRecording ? stop : start,
        child: Icon(_isRecording ? Icons.stop : Icons.mic),
      ),
    );
  }
}

class FullScreenAlert extends StatelessWidget {
  const FullScreenAlert({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "⚠ ATTENZIONE!",
                style: TextStyle(fontSize: 36, color: Colors.red, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              const Text(
                "Un rumore molto forte è stato rilevato (>125 dB).",
                style: TextStyle(fontSize: 22, color: Colors.white),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              const Text(
                "Guardati attentamente intorno. Se ti trovi in una situazione pericolosa, allontanati immediatamente o contatta i soccorsi."
                "\n\nPer emergenze chiama il numero 112 o il numero di emergenza locale.",
                style: TextStyle(fontSize: 18, color: Colors.white70),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Chiudi Avviso"),
              )
            ],
          ),
        ),
      ),
    );
  }
}

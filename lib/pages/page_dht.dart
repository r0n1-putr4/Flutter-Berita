import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:google_fonts/google_fonts.dart';

class PageDht extends StatefulWidget {
  const PageDht({super.key});

  @override
  State<PageDht> createState() => _PageDhtState();
}

class _PageDhtState extends State<PageDht> {
  late Timer _timer;
  String _data = 'Loading...';
  double temperature = 0.0;
  int humidity = 0;
  String gambar = "";

  Future<void> _fetchData() async {
    try {
      final response = await http.get(
        Uri.parse('http://localhost:8080/nodeMcu/getDHT.php'),
      );
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        setState(() {
          _data = json.toString();
          temperature = json['suhu'];
          humidity = json['kelembapan'];
          gambar = json['gambar'];
        });
      } else {
        setState(() {
          _data = 'Error: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        _data = 'Exception: $e';
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _fetchData(); // fetch initially

    _timer = Timer.periodic(Duration(seconds: 5), (Timer t) {
      _fetchData(); // fetch every 10 seconds
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _timer.cancel(); // Always cancel timers!
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Monitoring", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.black, Color(0xFF220033)],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 30),
                Text(
                  'LAB-P2 JURUSAN TI',
                  style: TextStyle(color: Colors.white,fontSize: 20),
                ),
                SfRadialGauge(
                  backgroundColor: Colors.transparent, // penting!
                  axes: <RadialAxis>[
                    RadialAxis(
                      minimum: 0,
                      maximum: 100,
                      startAngle: 135,
                      endAngle: 45,
                      interval: 10,
                      radiusFactor: 0.9,
                      showTicks: true,
                      showLabels: true,
                      axisLineStyle: const AxisLineStyle(
                        thickness: 0.1,
                        thicknessUnit: GaugeSizeUnit.factor,
                        cornerStyle: CornerStyle.bothFlat,
                        color: Color(0xFF8800CC),
                      ),
                      majorTickStyle: const MajorTickStyle(
                        color: Colors.white,
                        length: 0.07,
                        thickness: 1.5,
                      ),
                      axisLabelStyle: const GaugeTextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                      pointers: <GaugePointer>[
                        MarkerPointer(
                          value: temperature,
                          markerType: MarkerType.circle,
                          color: Colors.white,
                          markerWidth: 12,
                          markerHeight: 12,
                        ),
                      ],
                      annotations: <GaugeAnnotation>[
                        GaugeAnnotation(
                          angle: 90,
                          positionFactor: 0.1,
                          widget: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '$temperature °C',
                                style: TextStyle(
                                  fontSize: 24,
                                  color: Colors.amberAccent, // sesuai gambar
                                ),
                              ),
                              const Text(
                                'SUHU',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.pinkAccent,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SfRadialGauge(
                  backgroundColor: Colors.transparent, // penting!
                  axes: <RadialAxis>[
                    RadialAxis(
                      minimum: 0,
                      maximum: 100,
                      startAngle: 135,
                      endAngle: 45,
                      interval: 10,
                      radiusFactor: 0.9,
                      showTicks: true,
                      showLabels: true,
                      axisLineStyle: const AxisLineStyle(
                        thickness: 0.1,
                        thicknessUnit: GaugeSizeUnit.factor,
                        cornerStyle: CornerStyle.bothFlat,
                        color: Color(0xFF8800CC),
                      ),
                      majorTickStyle: const MajorTickStyle(
                        color: Colors.white,
                        length: 0.07,
                        thickness: 1.5,
                      ),
                      axisLabelStyle: const GaugeTextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                      pointers: <GaugePointer>[
                        MarkerPointer(
                          value: humidity.toDouble(),
                          markerType: MarkerType.circle,
                          color: Colors.white,
                          markerWidth: 12,
                          markerHeight: 12,
                        ),
                      ],
                      annotations: <GaugeAnnotation>[
                        GaugeAnnotation(
                          angle: 90,
                          positionFactor: 0.1,
                          widget: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '$humidity %',
                                style: TextStyle(
                                  fontSize: 24,
                                  color: Colors.amberAccent, // sesuai gambar
                                ),
                              ),
                              const Text(
                                'Kelembapan',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.pinkAccent,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                Image.network(
                  "http://localhost:8080/nodeMcu/getGambar.php?file=$gambar",
                 // Adjust height
                  fit: BoxFit.cover,
                  alignment: Alignment.topLeft,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

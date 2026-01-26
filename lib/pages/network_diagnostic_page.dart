import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../utils/app_colors.dart';

class NetworkDiagnosticPage extends StatefulWidget {
  const NetworkDiagnosticPage({super.key});

  @override
  State<NetworkDiagnosticPage> createState() => _NetworkDiagnosticPageState();
}

class _NetworkDiagnosticPageState extends State<NetworkDiagnosticPage> {
  Map<String, dynamic>? _diagnosticResults;
  bool _isRunningDiagnostic = false;

  Future<void> _runDiagnostic() async {
    setState(() {
      _isRunningDiagnostic = true;
    });

    try {
      final results = await ApiService.diagnoseNetworkIssues();
      setState(() {
        _diagnosticResults = results;
        _isRunningDiagnostic = false;
      });
    } catch (e) {
      setState(() {
        _diagnosticResults = {'error': e.toString()};
        _isRunningDiagnostic = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Diagnóstico de Rede'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: _isRunningDiagnostic ? null : _runDiagnostic,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.all(16),
              ),
              child:
                  _isRunningDiagnostic
                      ? const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(color: Colors.white),
                          SizedBox(width: 8),
                          Text('Executando diagnóstico...'),
                        ],
                      )
                      : const Text('Executar Diagnóstico'),
            ),
            const SizedBox(height: 20),
            if (_diagnosticResults != null) ...[
              const Text(
                'Resultados do Diagnóstico:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:
                        _diagnosticResults!.entries.map((entry) {
                          return Card(
                            margin: const EdgeInsets.only(bottom: 8),
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    entry.key
                                        .replaceAll('_', ' ')
                                        .toUpperCase(),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    entry.value.toString(),
                                    style: TextStyle(
                                      color:
                                          entry.value == true
                                              ? Colors.green
                                              : entry.value == false
                                              ? Colors.red
                                              : Colors.black,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

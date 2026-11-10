import 'package:flutter/material.dart';
import '../data/air_quality_repository.dart';
import '../domain/air_quality.dart';

class AirQualityHomePage extends StatefulWidget {
  const AirQualityHomePage({super.key});

  @override
  State<AirQualityHomePage> createState() => _AirQualityHomePageState();
}

class _AirQualityHomePageState extends State<AirQualityHomePage> {
  final TextEditingController _searchController = TextEditingController();
  final AirQualityRepository _repository = AirQualityRepository();

  Future<AirQuality>? _airQualityFuture;
  String _currentCity = 'Makassar';

  @override
  void initState() {
    super.initState();
    _searchController.text = _currentCity;
    _search(_currentCity);
  }

  void _search(String city) {
    final query = city.trim();
    if (query.length < 2) return;

    setState(() {
      _currentCity = query;
      _airQualityFuture = _repository.fetchAirQuality(query);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AirScope'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Baris Input Pencarian
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      labelText: 'Cari Kota',
                      hintText: 'Contoh: Makassar, Jakarta',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: _search,
                  ),
                ),
                const SizedBox(width: 8),
                IconButton.filled(
                  icon: const Icon(Icons.search),
                  onPressed: () => _search(_searchController.text),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Penanganan Asinkron dengan FutureBuilder
            Expanded(
              child: FutureBuilder<AirQuality>(
                future: _airQualityFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  // Error State dengan Tombol Retry
                  if (snapshot.hasError) {
                    final errorMessage = snapshot.error
                        .toString()
                        .replaceAll('Exception: ', '');
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.error_outline,
                              size: 64,
                              color: Colors.redAccent,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Gagal Memuat Data',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              errorMessage,
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton.icon(
                              onPressed: () => _search(_currentCity),
                              icon: const Icon(Icons.refresh),
                              label: const Text('Coba lagi'),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  // Success State
                  if (snapshot.hasData) {
                    final data = snapshot.data!;
                    return SingleChildScrollView(
                      child: Column(
                        children: [
                          Text(
                            data.locationLabel,
                            style: Theme.of(context).textTheme.headlineSmall,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 12),
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(24.0),
                              child: Column(
                                children: [
                                  const Text('Indeks Kualitas Udara (US AQI)'),
                                  const SizedBox(height: 8),
                                  Text(
                                    '${data.aqi}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .displayLarge
                                        ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                  const SizedBox(height: 8),
                                  Chip(label: Text(data.category)),
                                  const SizedBox(height: 12),
                                  Text(
                                    data.recommendation,
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context).textTheme.bodyMedium,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text('PM2.5: ${data.pm25} µg/m³'),
                              Text('PM10: ${data.pm10} µg/m³'),
                            ],
                          ),
                        ],
                      ),
                    );
                  }

                  return const Center(
                      child: Text('Masukkan nama kota untuk mencari.'));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/air_quality_repository.dart';
import '../domain/air_quality.dart';

class AirQualityHomePage extends StatefulWidget {
  final AirQualityRepository? repository;

  const AirQualityHomePage({super.key, this.repository});

  @override
  State<AirQualityHomePage> createState() => _AirQualityHomePageState();
}

class _AirQualityHomePageState extends State<AirQualityHomePage> {
  final TextEditingController _searchController = TextEditingController();
  late final AirQualityRepository _repository;
  final SharedPreferencesAsync _prefs = SharedPreferencesAsync();

  Future<AirQuality>? _airQualityFuture;
  String _currentCity = 'Makassar';

  @override
  void initState() {
    super.initState();
    _repository = widget.repository ?? AirQualityRepository();
    _loadLastCityAndFetch();
  }

  Future<void> _loadLastCityAndFetch() async {
    final savedCity = await _prefs.getString('last_city');
    final cityToFetch = (savedCity != null && savedCity.isNotEmpty)
        ? savedCity
        : 'Makassar';
    setState(() {
      _currentCity = cityToFetch;
      _searchController.text = cityToFetch;
      _airQualityFuture = _repository.fetchAirQuality(cityToFetch);
    });
  }

  void _search(String city) {
    final query = city.trim();
    if (query.length < 2) return;

    setState(() {
      _currentCity = query;
      _airQualityFuture = _repository.fetchAirQuality(query).then((data) {
        _prefs.setString('last_city', query);
        return data;
      });
    });
  }

  Color _getAqiColor(int aqi) {
    if (aqi <= 50) return Colors.green.shade600;
    if (aqi <= 100) return Colors.amber.shade700;
    if (aqi <= 150) return Colors.orange.shade700;
    if (aqi <= 200) return Colors.red.shade600;
    if (aqi <= 300) return Colors.purple.shade600;
    return Colors.brown.shade700;
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
        elevation: 2,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Search Input Bar
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        labelText: 'Cari Kota',
                        hintText: 'Contoh: Makassar, Jakarta, Bandung',
                        prefixIcon: const Icon(Icons.location_city),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onSubmitted: _search,
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton.filled(
                    style: IconButton.styleFrom(
                      padding: const EdgeInsets.all(16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: const Icon(Icons.search),
                    onPressed: () => _search(_searchController.text),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Dynamic View via FutureBuilder
              Expanded(
                child: FutureBuilder<AirQuality>(
                  future: _airQualityFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(),
                            SizedBox(height: 12),
                            Text('Mengambil data kualitas udara...'),
                          ],
                        ),
                      );
                    }

                    if (snapshot.hasError) {
                      final errorMessage = snapshot.error.toString().replaceAll(
                        'Exception: ',
                        '',
                      );
                      return Center(
                        child: SingleChildScrollView(
                          child: Card(
                            color: Colors.red.shade50,
                            margin: const EdgeInsets.all(16.0),
                            child: Padding(
                              padding: const EdgeInsets.all(24.0),
                              child: Column(
                                children: [
                                  const Icon(
                                    Icons.error_outline,
                                    size: 56,
                                    color: Colors.redAccent,
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    'Gagal Memuat Data',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge
                                        ?.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    errorMessage,
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium,
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
                          ),
                        ),
                      );
                    }

                    if (snapshot.hasData) {
                      final data = snapshot.data!;
                      final badgeColor = _getAqiColor(data.aqi);

                      return SingleChildScrollView(
                        child: Column(
                          children: [
                            Text(
                              data.locationLabel,
                              style: Theme.of(context).textTheme.headlineSmall
                                  ?.copyWith(fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            Card(
                              elevation: 3,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(24.0),
                                child: Column(
                                  children: [
                                    Text(
                                      'Indeks Kualitas Udara (US AQI)',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium,
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      '${data.aqi}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .displayLarge
                                          ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: badgeColor,
                                          ),
                                    ),
                                    const SizedBox(height: 8),
                                    Chip(
                                      backgroundColor: badgeColor.withAlpha(40),
                                      side: BorderSide(color: badgeColor),
                                      label: Text(
                                        data.category,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: badgeColor,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      data.recommendation,
                                      textAlign: TextAlign.center,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),

                            // Detail Polutan
                            Row(
                              children: [
                                Expanded(
                                  child: Card(
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Column(
                                        children: [
                                          const Text('PM2.5'),
                                          const SizedBox(height: 4),
                                          Text(
                                            '${data.pm25} µg/m³',
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleLarge
                                                ?.copyWith(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Card(
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Column(
                                        children: [
                                          const Text('PM10'),
                                          const SizedBox(height: 4),
                                          Text(
                                            '${data.pm10} µg/m³',
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleLarge
                                                ?.copyWith(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Sumber Data: Open-Meteo Air Quality API',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      );
                    }

                    return const Center(
                      child: Text('Masukkan nama kota untuk mencari.'),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

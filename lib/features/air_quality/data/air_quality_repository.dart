import 'dart:convert';
import 'package:http/http.dart' as http;
import '../domain/air_quality.dart';

class AirQualityRepository {
  final http.Client client;

  AirQualityRepository({http.Client? client}) : client = client ?? http.Client();

  Future<AirQuality> fetchAirQuality(String city) async {
    final query = city.trim();
    if (query.length < 2) {
      throw Exception('Nama kota minimal 2 karakter.');
    }

    // 1. Request Geocoding API Open-Meteo
    final geoUrl = Uri.parse(
      'https://geocoding-api.open-meteo.com/v1/search?name=${Uri.encodeComponent(query)}&count=1&language=id&format=json',
    );

    final geoResponse = await client.get(geoUrl).timeout(const Duration(seconds: 10));

    if (geoResponse.statusCode != 200) {
      throw Exception('Gagal menghubungi layanan geocoding.');
    }

    final geoData = jsonDecode(geoResponse.body);
    final results = geoData['results'] as List?;

    if (results == null || results.isEmpty) {
      throw Exception('Kota "$city" tidak ditemukan.');
    }

    final location = results.first;
    final double lat = location['latitude'];
    final double lon = location['longitude'];
    final String cityName = location['name'] ?? city;
    final String country = location['country'] ?? '';
    final String? region = location['admin1'];

    // 2. Request Air Quality API Open-Meteo
    final aqUrl = Uri.parse(
      'https://air-quality-api.open-meteo.com/v1/air-quality?latitude=$lat&longitude=$lon&current=us_aqi,pm2_5,pm10',
    );

    final aqResponse = await client.get(aqUrl).timeout(const Duration(seconds: 10));

    if (aqResponse.statusCode != 200) {
      throw Exception('Gagal mengambil data kualitas udara.');
    }

    final aqData = jsonDecode(aqResponse.body);
    final current = aqData['current'];

    return AirQuality(
      city: cityName,
      country: country,
      region: region,
      aqi: (current['us_aqi'] as num).toInt(),
      pm25: (current['pm2_5'] as num).toDouble(),
      pm10: (current['pm10'] as num).toDouble(),
      dataTime: DateTime.parse(current['time']),
    );
  }
}
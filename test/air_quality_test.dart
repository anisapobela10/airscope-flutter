import 'package:flutter_test/flutter_test.dart';
import 'package:airscope/features/air_quality/domain/air_quality.dart';

void main() {
  group('AirQuality Model Tests', () {
    test('Kategori dan label lokasi AQI Baik (0-50)', () {
      final data = AirQuality(
        city: 'Makassar',
        country: 'Indonesia',
        aqi: 35,
        pm25: 10.0,
        pm10: 20.0,
        dataTime: DateTime.now(),
      );

      expect(data.category, 'Baik');
      expect(data.locationLabel, 'Makassar, Indonesia');
    });

    test('Kategori AQI Sedang (51-100)', () {
      final data = AirQuality(
        city: 'Jakarta',
        country: 'Indonesia',
        aqi: 75,
        pm25: 25.0,
        pm10: 45.0,
        dataTime: DateTime.now(),
      );

      expect(data.category, 'Sedang');
    });

    test('Kategori AQI Tidak Sehat (>150)', () {
      final data = AirQuality(
        city: 'Kota Contoh',
        country: 'Indonesia',
        aqi: 165,
        pm25: 85.0,
        pm10: 120.0,
        dataTime: DateTime.now(),
      );

      expect(data.category, 'Tidak Sehat');
    });
  });
}
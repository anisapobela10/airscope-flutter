import 'package:flutter_test/flutter_test.dart';
import 'package:airscope/features/air_quality/data/air_quality_repository.dart';

void main() {
  group('AirQualityRepository Validation Tests', () {
    test('fetchAirQuality melempar exception jika input kota kurang dari 2 karakter', () async {
      final repository = AirQualityRepository();
      expect(
        () => repository.fetchAirQuality('A'),
        throwsA(isA<Exception>()),
      );
    });
  });
}
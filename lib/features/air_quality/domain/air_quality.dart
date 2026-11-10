class AirQuality {
  final String city;
  final String country;
  final String? region;
  final int aqi;
  final double pm25;
  final double pm10;
  final DateTime dataTime;

  AirQuality({
    required this.city,
    required this.country,
    this.region,
    required this.aqi,
    required this.pm25,
    required this.pm10,
    required this.dataTime,
  });

  String get locationLabel {
    if (region != null && region!.isNotEmpty) {
      return '$city, $region, $country';
    }
    return '$city, $country';
  }

  // Batas Kategori US AQI
  String get category {
    if (aqi <= 50) {
      return 'Baik';
    }
    if (aqi <= 100) {
      return 'Sedang';
    }
    if (aqi <= 150) {
      return 'Tidak Sehat untuk Kelompok Sensitif';
    }
    if (aqi <= 200) {
      return 'Tidak Sehat';
    }
    if (aqi <= 300) {
      return 'Sangat Tidak Sehat';
    }
    return 'Berbahaya';
  }

  // Rekomendasi Kesehatan berdasarkan AQI
  String get recommendation {
    if (aqi <= 50) {
      return 'Kualitas udara baik. Selamat beraktivitas di luar!';
    }
    if (aqi <= 100) {
      return 'Kualitas udara sedang. Kelompok sensitif sebaiknya mengurangi aktivitas fisik berat di luar.';
    }
    if (aqi <= 150) {
      return 'Kelompok sensitif (asma/lansia/anak-anak) disarankan menggunakan masker di luar.';
    }
    if (aqi <= 200) {
      return 'Gunakan masker jika keluar rumah dan batasi aktivitas fisik outdoor.';
    }
    if (aqi <= 300) {
      return 'Hindari aktivitas di luar ruangan. Gunakan pemurni udara di dalam ruangan.';
    }
    return 'Peringatan bahaya! Tetap di dalam ruangan dan tutup jendela.';
  }
}
# AirScope — Aplikasi Pengecek Kualitas Udara

AirScope adalah aplikasi mobile berbasis Flutter yang dirancang untuk memeriksa Indeks Kualitas Udara (US AQI) secara dinamis menggunakan REST API dari Open-Meteo.

## 🚀 Fitur Utama & Kriteria Pemenuhan Tugas
1. **REST API AQI**: Mengintegrasikan Geocoding API dan Air Quality API dari Open-Meteo untuk mengambil data lokasi, US AQI, PM2.5, serta PM10.
2. **FutureBuilder State Management**: Mengelola alur asinkron dengan 3 kondisi visual:
   - *Loading*: Indikator pemrosesan data.
   - *Success*: Tampilan kartu AQI, warna indikator dinamis, kategori, dan rekomendasi kesehatan.
   - *Error*: Kartu penanganan kesalahan beserta tombol *Retry* (Coba lagi).
3. **Penyimpanan Lokal (`shared_preferences`)**: Menyimpan kota pencarian terakhir yang berhasil dan memuatnya kembali secara otomatis saat aplikasi dijalankan ulang.

## 🛠️ Persyaratan & Versi
- **Flutter SDK**: >= 3.0.0
- **Dart SDK**: >= 3.0.0
- **Platform**: Android

## 🧪 Cara Menjalankan Pengujian & Analisis
```powershell
# Memeriksa kebersihan sintaks dan aturan linter
flutter analyze

# Menjalankan unit test model dan repository
flutter test
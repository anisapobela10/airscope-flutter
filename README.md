# AirScope — Aplikasi Pengecek Kualitas Udara

AirScope adalah aplikasi berbasis Flutter yang dikembangkan untuk memantau Indeks Kualitas Udara (US AQI) secara real-time menggunakan Open-Meteo API.

## Fitur Utama & Kriteria Tugas
1. **REST API Integration**: Mengambil data Geocoding dan Kualitas Udara (US AQI, PM2.5, PM10) dari Open-Meteo.
2. **Asynchronous Handling (`FutureBuilder`)**: Penanganan status data dinamis (Loading, Success, dan Error dengan tombol Retry).
3. **Local Storage (`shared_preferences`)**: Menyimpan dan memulihkan nama kota terakhir yang berhasil dicari secara lokal.

## Sumber Data API
- Geocoding API: Open-Meteo Geocoding
- Air Quality API: Open-Meteo Air Quality
# Design System & UI Specifications — AirScope

## Tema & Warna (Material 3)
- Color Scheme Seed: `Colors.lightBlue`
- Mode: Light Theme

## Komponen Utama
1. **Search Bar**: Input nama kota + Tombol Cari.
2. **AQI Card**: Menampilkan angka US AQI, label kategori, dan rekomendasi aktivitas.
3. **Detail Metrics**: Informasi parameter PM2.5 dan PM10.
4. **State View**: Layout khusus untuk Loading (Progress Indicator) dan Error (Card + Retry Button).

## Standar Kategori US AQI
- 0–50: Baik (Good)
- 51–100: Sedang (Moderate)
- 101–150: Tidak Sehat untuk Kelompok Sensitif (Unhealthy for Sensitive Groups)
- 151–200: Tidak Sehat (Unhealthy)
- 201–300: Sangat Tidak Sehat (Very Unhealthy)
- >300: Berbahaya (Hazardous)
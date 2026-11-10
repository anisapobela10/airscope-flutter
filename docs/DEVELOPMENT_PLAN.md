# Panduan GitHub dan Commit Bertahap — AirScope Flutter

Dokumen kerja untuk tugas Pemrograman Mobile: *Aplikasi Pengecek Kualitas Udara*.

> Sasaran wajib: REST API AQI, `FutureBuilder` untuk loading/success/error, dan penyimpanan kota terakhir menggunakan `shared_preferences`.
>
> Gunakan satu commit per perubahan logis yang **benar-benar dikerjakan**. Jangan merekayasa tanggal commit atau membagi sebuah implementasi final menjadi riwayat palsu. Starter AirScope lama adalah referensi akhir; implementasikan secara bertahap di proyek baru.

## A. Persiapan tools

Di PowerShell / terminal VS Code:

```powershell
flutter doctor
git --version
node --version
```

Jika Git belum mempunyai identitas, isi dengan nama dan email **milikmu sendiri** (contoh placeholder, jangan disalin mentah-mentah):

```powershell
git config --global user.name "NAMA_ANDA"
git config --global user.email "EMAIL_GITHUB_ANDA"
```

Buat project Android:

```powershell
flutter create --platforms=android airscope
cd airscope
code .
```

Periksa apakah Flutter sudah menginisialisasi Git:

```powershell
git status
```

Jika muncul `not a git repository`, jalankan `git init -b main`. Jika repo Git sudah ada, tidak perlu `git init` ulang. Untuk memastikan branch:

```powershell
git branch -M main
```

## B. Siapkan repository baru di GitHub

1. Login github.com lalu pilih **New repository**.
2. Nama: `airscope-flutter`; deskripsi: `Aplikasi pengecek kualitas udara menggunakan Flutter, REST API, FutureBuilder, dan SharedPreferences`.
3. Visibility: **Public** jika dosen akan memeriksa tanpa undangan, atau **Private** jika dosen meminta demikian.
4. **Jangan centang** inisialisasi README, `.gitignore`, atau License; proyek lokal sudah punya file-file tersebut.
5. Setelah commit pertama dibuat, sambungkan remote dan push:

```powershell
git remote add origin https://github.com/USERNAME_ANDA/airscope-flutter.git
git remote -v
git push -u origin main
```

Ganti `USERNAME_ANDA` dengan username GitHub yang benar. Jika `origin` sudah ada, **periksa** dengan `git remote -v`, jangan menambahkan dua kali. Autentikasi lewat browser/credential manager saat diminta, jangan menempel password/token ke dalam kode.

## C. Roadmap pengembangan dan commit

### Commit 01 — Fondasi project

**Pesan:** `chore: initialize Flutter project`

**Tambah:** file dan folder default dari `flutter create`, terutama `android/`, `lib/main.dart`, `pubspec.yaml`, `pubspec.lock`, `analysis_options.yaml`, `.gitignore`, `test/widget_test.dart`, `README.md` bawaan.

**Perubahan fungsi:** aplikasi template Flutter masih dapat dijalankan. Belum ada AirScope/API.

**Cek:** `flutter run`, `flutter analyze`, dan `flutter test` (pada template awal).

**Commit:**

```powershell
git status --short
git add .
git diff --cached --stat
git commit -m "chore: initialize Flutter project"
git push
```

`git push` setelah `origin` terhubung; jika belum, hubungkan remote dahulu seperti bagian B.

### Commit 02 — Spesifikasi dan desain

**Pesan:** `docs: define requirements and design system`

**Tambah:** `DESIGN.md`, `docs/DEVELOPMENT_PLAN.md` (boleh salin dokumen ini).

**Ubah:** `README.md` menjadi deskripsi kebutuhan dosen, sumber data, target demo dan fitur wajib.

**Isi penting:** tiga kriteria wajib; API Open-Meteo geocoding + air quality; UI bahasa Indonesia, Material 3, label US AQI (bukan ISPU Indonesia); tidak mengklaim data sebagai sensor real-time lokal.

```powershell
git add README.md DESIGN.md docs/DEVELOPMENT_PLAN.md
git diff --cached --check
git commit -m "docs: define requirements and design system"
git push
```

### Commit 03 — Kerangka aplikasi dan tema

**Pesan:** `feat: setup Material 3 app theme`

**Tambah:** `lib/app.dart` untuk `MaterialApp`, `ThemeData`, `ColorScheme`.

**Ubah:** `lib/main.dart` agar memanggil `runApp(const AirScopeApp())`.

**Hapus/ganti:** `test/widget_test.dart` bawaan ketika tak lagi relevan. Jika ingin mempertahankan widget test, sesuaikan dengan nama widget AirScope sehingga tes tetap valid.

**Isi:** nama `AirScope`, app bar, tema terang, halaman sementara yang valid seperti `Scaffold(body: Center(child: Text('AirScope')))`. UI belum memerlukan HTTP.

```powershell
git add lib/main.dart lib/app.dart
git add -u test/widget_test.dart
flutter analyze
git commit -m "feat: setup Material 3 app theme"
git push
```

### Commit 04 — Model data & kategori

**Pesan:** `feat: add air quality data model`

**Tambah:** `lib/features/air_quality/domain/air_quality.dart`.

**Isi model:** `city`, `country`, `region`, `aqi`, `pm25`, `pm10`, `dataTime`; getter `category`, `recommendation`, dan `locationLabel`.

**Batas kategori US AQI:** 0–50 Baik, 51–100 Sedang, 101–150 kelompok sensitif, 151–200 Tidak sehat, 201–300 Sangat tidak sehat, >300 Berbahaya.

**Ubah (opsional):** tambahkan tes kategori sejak tahap ini pada `test/air_quality_test.dart`; jika ditunda ke commit 10, catat dalam roadmap.

```powershell
git add lib/features/air_quality/domain/air_quality.dart
git commit -m "feat: add air quality data model"
git push
```

### Commit 05 — Integrasi REST API

**Pesan:** `feat: integrate air quality REST API`

**Tambah:** `lib/features/air_quality/data/air_quality_repository.dart`.

**Ubah:** `pubspec.yaml` untuk `http`, `pubspec.lock` dari `flutter pub get`, dan `android/app/src/main/AndroidManifest.xml` untuk izin internet.

**Alur repository:** validasi nama kota -> GET Geocoding Open-Meteo -> ambil `latitude`, `longitude` -> GET Air Quality Open-Meteo dengan `current=us_aqi,pm2_5,pm10` -> parsing JSON -> kembalikan `AirQuality`.

**Error:** kota tidak ditemukan, HTTP non-200, timeout, format JSON salah, koneksi gagal.

**Contoh perubahan manifest:** di dalam `<manifest>` sebelum `<application>`:

```xml
<uses-permission android:name="android.permission.INTERNET" />
```

**Perintah:**

```powershell
flutter pub add http
flutter pub get
flutter analyze
git add pubspec.yaml pubspec.lock android/app/src/main/AndroidManifest.xml lib/features/air_quality/data/air_quality_repository.dart
git commit -m "feat: integrate air quality REST API"
git push
```

**Bukti:** endpoint dapat diverifikasi dari implementasi; pengujian MockClient akan ditambah pada commit 10.

### Commit 06 — Pencarian kota

**Pesan:** `feat: implement city search interface`

**Tambah:** `lib/features/air_quality/presentation/home_page.dart`.

**Ubah:** `lib/app.dart` agar `home` mengarah ke `AirQualityHomePage`.

**Isi:** `TextEditingController`, `TextField` dengan label kota, `FilledButton` untuk mencari, `onSubmitted`, validasi minimal dua karakter, shortcut Makassar/Jakarta/Bandung (opsional). Pada tahap ini hasil boleh berupa teks sementara: `Kota dipilih: ...` tanpa data palsu.

**Uji:** input kosong, satu karakter, dan dua karakter; keyboard search dan tombol berfungsi.

```powershell
git add lib/app.dart lib/features/air_quality/presentation/home_page.dart
git commit -m "feat: implement city search interface"
git push
```

### Commit 07 — Loading & success melalui FutureBuilder

**Pesan:** `feat: handle asynchronous data with FutureBuilder`

**Ubah:** `lib/features/air_quality/presentation/home_page.dart`.

**Isi:** `Future<AirQuality>` disimpan dalam state, `_search()` memasang Future baru memakai `setState`; `FutureBuilder<AirQuality>` mengelola `connectionState`, data berhasil, menampilkan AQI + lokasi + waktu + PM2.5/PM10.

**Implementasi antara:** pada error sementara dapat tampil `Text('Gagal memuat data')`; UX error lengkap dikerjakan dalam commit berikutnya. Jangan memakai `Future` baru langsung di `build()` pada setiap rebuild.

**Uji:** cari kota yang valid; loading muncul saat request berjalan, lalu nilai dari server tampil.

```powershell
git add lib/features/air_quality/presentation/home_page.dart
git commit -m "feat: handle asynchronous data with FutureBuilder"
git push
```

### Commit 08 — Error dan retry

**Pesan:** `feat: implement error handling and retry`

**Ubah:** `lib/features/air_quality/presentation/home_page.dart`; jika perlu, `lib/features/air_quality/data/air_quality_repository.dart` untuk pesan exception yang lebih baik.

**Isi:** komponen ErrorCard, pesan untuk kota tidak ditemukan/koneksi gagal/timeout, tombol `Coba lagi` yang memanggil ulang fungsi pencarian; pertahankan kolom pencarian dan jangan crash.

**Uji:** `KotaTidakAda1234`, mode pesawat/tanpa internet, tombol retry setelah koneksi aktif kembali.

```powershell
git add lib/features/air_quality/presentation/home_page.dart lib/features/air_quality/data/air_quality_repository.dart
git commit -m "feat: implement error handling and retry"
git push
```

### Commit 09 — Penyimpanan kota terakhir

**Pesan:** `feat: persist last searched city locally`

**Ubah:** `pubspec.yaml`, `pubspec.lock`, `lib/features/air_quality/presentation/home_page.dart`.

**Isi:** tambah `shared_preferences`; simpan `last_city` setelah fetch berhasil dengan `SharedPreferencesAsync().setString(...)`; saat `initState` baca `getString('last_city')`; jika kosong gunakan Makassar; lakukan fetch kota yang dipulihkan.

**Penting:** jangan menyimpan kota gagal; jika pengguna mengganti kota cepat, cegah respons lama menimpa kota paling baru (misalnya dengan nomor revisi pencarian seperti starter sebelumnya).

**Uji:** cari Bandung -> aplikasi benar-benar ditutup -> buka lagi -> kota Bandung digunakan; uji kota tidak ada tidak menimpa pilihan berhasil.

```powershell
flutter pub add shared_preferences
flutter pub get
git add pubspec.yaml pubspec.lock lib/features/air_quality/presentation/home_page.dart
git commit -m "feat: persist last searched city locally"
git push
```

### Commit 10 — Pengujian logika

**Pesan:** `test: add model and repository tests`

**Tambah:** `test/air_quality_test.dart`, `test/air_quality_repository_test.dart`.

**Isi:** test batas US AQI; test repository dengan HTTP `MockClient` untuk geocoding dan response AQI; test kota tidak ditemukan; uji respons non-200/timeout bila sempat.

**Uji:** `flutter test` dan `flutter analyze`.

```powershell
flutter test
flutter analyze
git add test/air_quality_test.dart test/air_quality_repository_test.dart
git commit -m "test: add model and repository tests"
git push
```

### Commit 11 — Penyempurnaan UI + Anti-Slop

**Pesan:** `style: polish UI and responsive layout`

**Ubah:** `lib/app.dart`, `lib/features/air_quality/presentation/home_page.dart`, `DESIGN.md` jika keputusan visual berubah.

**Isi:** perbaiki padding, hierarki teks, indikator kategori AQI yang dapat dibaca tanpa mengandalkan warna, responsive layout, loading/success/error yang konsisten, tombol dan input mudah disentuh, attribution Open-Meteo, penjelasan US AQI.

**Integrasi Anti-Slop:** jalankan `npx antislop-ai` dari root proyek, pilih agent dan scope project; atur mode dengan `npx antislop-ai --mode during`. Instruksi lokal agent yang dipasang dapat muncul sebagai folder `.codex/skills/` atau `.cursor/skills/`, dsb. Periksa isi dan apakah akan disimpan ke repo; jangan menambahkan file tools global atau credential lokal.

**Uji:** `dart format .`, `flutter analyze`, `flutter test`, dan cek layout pada emulator yang ukurannya berbeda.

```powershell
git add lib/app.dart lib/features/air_quality/presentation/home_page.dart DESIGN.md
git diff --cached --stat
git commit -m "style: polish UI and responsive layout"
git push
```

Jika file konfigurasi agent Anti-Slop juga dipilih untuk dimasukkan ke repo, buat commit terpisah seperti `chore: configure antislop agent rules`, jangan diam-diam mencampurnya dengan perubahan UI.

### Commit 12 — Dokumentasi tugas dan bukti

**Pesan:** `docs: finalize README and submission evidence`

**Ubah:** `README.md` untuk instalasi, versi Flutter, fitur, arsitektur, cara test, perintah build APK, sumber API, metode penyimpanan lokal, demonstrasi 3 kriteria.

**Tambah:** `docs/screenshots/home.png`, `docs/screenshots/loading.png`, `docs/screenshots/error.png` **hanya setelah screenshot asli diambil**; jangan mengaku screenshot contoh sebagai aplikasi nyata.

**Cek akhir:** `dart format .`, `flutter analyze`, `flutter test`, `flutter build apk --release`, jalankan di Android, cek GitHub menampilkan seluruh commit.

```powershell
git add README.md docs/screenshots/
git diff --cached --check
git commit -m "docs: finalize README and submission evidence"
git push
```

Jika screenshot belum ada, gunakan `git add README.md` saja dan tambahkan screenshot pada commit berikutnya ketika siap.

## D. Pola kerja untuk SETIAP commit

1. Catat tujuan feature / bug yang hendak diubah.
2. Modifikasi **hanya** file yang relevan dengan perubahan tersebut.
3. Jalankan `dart format .` dan `flutter analyze`; jalankan `flutter test` bila tes sudah tersedia.
4. Periksa `git status --short`, `git diff`, dan `git diff --cached`.
5. Stage file tertentu, bukan otomatis semua file.
6. Commit dengan pesan yang menerangkan satu perubahan.
7. `git push` setelah commit supaya dosen dapat melihat perjalanan pengembangan.

Template:

```powershell
git status --short
git diff --stat
flutter analyze
flutter test
git add PATH_FILE_YANG_DIUBAH
git diff --cached --check
git diff --cached --stat
git commit -m "feat: describe a specific change"
git push
```

Jika `dart format .` mengubah banyak file di luar scope, periksa diff dan pisahkan/rapikan commit agar tetap fokus. Gunakan `git add -p` untuk memilih bagian perubahan dalam satu file jika diperlukan.

## E. Yang harus dan tidak boleh dikirim ke Git

**Kirim:** source `lib/`, source `test/`, `pubspec.yaml`, `pubspec.lock` (untuk aplikasi), `android/` yang diperlukan, `.gitignore`, `analysis_options.yaml`, `README.md`, `DESIGN.md`, screenshot dokumentasi asli.

**Jangan kirim:** `.dart_tool/`, `build/`, `.gradle/`, file rahasia seperti `.env`, token, API key, berkas signing `*.jks` atau `*.keystore`, `android/local.properties`, cache editor, folder SDK.

Normalnya `.gitignore` yang dibuat Flutter sudah mengabaikan file generated. Periksa isinya sebelum melakukan `git add .`.

## F. Perintah untuk membuktikan riwayat commit

```powershell
git log --oneline --reverse
git log --oneline --graph --decorate --all
git status
git show --stat HEAD
git remote -v
```

Di GitHub buka repository -> bagian `Commits` -> klik setiap commit untuk memeriksa **Files changed**. Ambil screenshot riwayat commit dan screenshot aplikasi nyata untuk dokumentasi tugas.

## G. Checklist penilaian & demo

- [ ] Repo GitHub baru bisa diakses dosen.
- [ ] Commit menjelaskan progres fitur yang nyata (bukan satu upload besar).
- [ ] REST API geocoding + air quality memuat AQI yang valid.
- [ ] `FutureBuilder` punya loading, success, error.
- [ ] Error menampilkan retry dan tidak membuat aplikasi crash.
- [ ] Kota terakhir disimpan di SharedPreferences.
- [ ] Restart aplikasi memulihkan kota terakhir.
- [ ] Unit test model dan repository lulus.
- [ ] `flutter analyze` tidak menghasilkan error.
- [ ] README menunjukkan setup, demo, sumber API, dan batasan data.
- [ ] APK release berhasil dibangun dan dicoba pada perangkat yang ditargetkan.

## H. Catatan tentang starter sebelumnya

Starter `AirScope_Flutter_Starter.zip` memuat `lib/main.dart`, `lib/app.dart`, model, repository, halaman utama, tes dan `DESIGN.md`. Gunakan sebagai **referensi per bagian** ketika memasuki tahap terkait, bukan langsung disalin semua ke commit 01. Commit 06 dapat menggunakan halaman sederhana; commit 07-09 kemudian melengkapi fungsi dari kode starter. Starter itu belum diverifikasi dengan Flutter SDK di lingkungan penyusunannya: jalankan pemeriksaan pada PC sendiri sebelum commit final.

## I. Referensi

- GitHub: https://docs.github.com/en/migrations/importing-source-code/using-the-command-line-to-import-source-code/adding-locally-hosted-code-to-github
- GitHub CLI (opsional): https://cli.github.com/manual/gh_repo_create
- Flutter: https://docs.flutter.dev/
- Anti-Slop: https://github.com/miqdadbadjuber/anti-slop
- Open-Meteo: https://open-meteo.com/en/docs/air-quality-api

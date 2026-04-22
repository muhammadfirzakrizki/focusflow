# FocusFlow

FocusFlow adalah aplikasi produktivitas berbasis Flutter untuk mengelola task dan sesi fokus. Aplikasi ini menyimpan data secara lokal dengan PowerSync + SQLite, memakai Riverpod untuk state management, dan menerapkan struktur feature-based yang mendekati clean architecture.

## Fitur Utama

- Task CRUD lokal: tambah, edit, hapus, dan lihat daftar task.
- Focus timer: hitung mundur sesi fokus dengan update progress per milidetik.
- Pause dan resume: progres yang berjalan disimpan di `remaining_duration_ms`.
- Reset aman: reset memakai konfirmasi `AppSheet` agar tidak kepencet tidak sengaja.
- Task completion: task bisa ditandai selesai tanpa menimpa durasi awal.
- Theme settings: dukungan light/dark mode.
- Material 3: UI mengikuti komponen dan gaya Material terbaru.

## Tech Stack

- Flutter
- Dart
- Riverpod
- PowerSync
- SQLite
- Equatable
- Google Fonts

## Arsitektur

Project ini memakai struktur feature-based dengan layer utama:

- `domain`: entity, repository contract, dan use case.
- `data`: model, repository implementation, dan datasource.
- `presentation`: halaman, widget, dan provider untuk UI.
- `core`: shared utilities, theme, UI kit, dan database config.

Alur dependensi dibuat satu arah:

- UI membaca state dan memanggil provider di feature terkait.
- Provider memanggil repository.
- Repository berkomunikasi dengan PowerSync/SQLite.
- Domain tetap bebas dari detail penyimpanan.

## Struktur Folder

```text
lib/
├── app.dart
├── main.dart
├── core/
│   ├── database/
│   ├── theme/
│   ├── ui_kit/
│   ├── utils/
│   └── widgets/
├── features/
│   ├── settings/
│   │   ├── data/
│   │   ├── presentation/
│   │   └── providers/
│   └── task/
│       ├── data/
│       ├── domain/
│       └── presentation/
│           ├── pages/
│           ├── providers/
│           └── widgets/
```

## Database

Database lokal diinisialisasi lewat `PowerSyncConfig`.

### Tabel `tasks`

- `id`
- `title`
- `description`
- `duration`
- `remaining_duration_ms`
- `is_done`
- `created_at`

### Tabel `app_settings`

- `id`
- `value`

`duration` dipakai sebagai durasi awal yang tetap.  
`remaining_duration_ms` dipakai untuk progres timer yang berubah saat pause, resume, dan reset.

## Cara Menjalankan

### Prasyarat

- Flutter SDK terbaru yang kompatibel dengan project ini
- Android Studio, VS Code, atau IDE Flutter lain
- Emulator atau device fisik

### Langkah

```bash
git clone https://github.com/muhammadfirzakrizki/focus-flow-flutter-app.git
cd focus-flow-flutter-app
flutter pub get
flutter run
```

### Jika Riverpod Generator Perlu Dijalankan

```bash
dart run build_runner build --delete-conflicting-outputs
```

## Catatan Implementasi

- Reset timer selalu kembali ke durasi awal, bukan ke nilai pause terakhir.
- Sisa waktu disimpan dalam milidetik agar progress lebih presisi.
- Konfirmasi reset dan hapus task memakai bottom sheet khusus supaya tidak mudah salah klik.
- Data tema dan task disimpan lokal melalui PowerSync.

## Screenshot

Bagian ini bisa diisi dengan tangkapan layar aplikasi jika diperlukan.

## Lisensi

Project ini saat ini belum memiliki lisensi resmi.

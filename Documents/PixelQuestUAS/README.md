# Pixel Quest: Royal Crystal

Repositori game **Pixel Quest: Royal Crystal**, sebuah game platformer petualangan 2D atmosferik tentang perjalanan menemukan kristal kuno yang memulihkan cahaya kerajaan.

## Deskripsi Project

Pemain menjelajahi hutan, melintasi platform dan rintangan, mengumpulkan Royal Crystal, lalu melanjutkan perjalanan ke Shadow Forest. Project ditujukan untuk Godot 4 dan menggunakan GDScript. Dokumen rancangan permainan tersedia di [`docs/GDD.md`](docs/GDD.md).

## Arsitektur Folder

```text
PixelQuestUAS/
|-- assets/
|   |-- audio/       # Musik dan efek suara
|   `-- sprites/     # Sprite dan aset visual
|-- docs/
|   `-- GDD.md       # Game Design Document
|-- scenes/          # MainMenu, Level1, Level2, Player, Enemy, Crystal, HUD
|-- scripts/
|   |-- crystal.gd
|   |-- enemy.gd
|   |-- game_manager.gd
|   |-- hud.gd
|   |-- main_menu.gd
|   |-- player.gd
|   `-- wisp.gd
`-- README.md
```

`player.gd` mengatur gerak, lompatan, dan sinyal kerusakan/pickup. `game_manager.gd` menyimpan status nyawa, skor, dan Royal Crystal; daftarkan sebagai Autoload bernama `GameManager` melalui **Project > Project Settings > Globals > Autoload**.

## Cara Menjalankan Project di Godot 4.7.2

1. Pasang Godot **4.7.2** dari situs resmi Godot.
2. Buka Godot, pilih **Import**, lalu pilih file `project.godot` di folder repositori.
3. Autoload `GameManager` dan scene awal `MainMenu.tscn` sudah dikonfigurasi di `project.godot`.
4. Tekan **F6** untuk menjalankan scene aktif atau **F5** untuk memulai dari menu utama.

Pilih **Mulai Main** untuk masuk ke Level1. Mengambil Royal Crystal akan membuka Level2 (Shadow Forest) setelah jeda singkat; item tujuan di Level2 menyelesaikan permainan. Input gerak bawaan memakai `ui_left` dan `ui_right`; lompatan memakai `ui_accept`. Periksa atau sesuaikan aksinya di **Project Settings > Input Map**.

## Lisensi dan Kredit

Belum ada file lisensi yang ditetapkan di repositori ini. Tambahkan file `LICENSE` sebelum distribusi untuk menjelaskan hak penggunaan dan distribusi. Kredit aset dan audio sebaiknya dicatat di sini beserta nama pembuat, sumber, dan lisensi masing-masing. Gunakan hanya aset yang dibuat sendiri atau yang izinnya mencakup penggunaan dalam project.

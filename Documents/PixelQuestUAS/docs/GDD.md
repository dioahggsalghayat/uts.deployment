# Game Design Document — Pixel Quest: Royal Crystal

## Ringkasan

**Genre:** 2D atmospheric action-adventure platformer  
**Platform target:** PC  
**Engine:** Godot 4  
**Mode:** Single-player  
**Gaya visual:** Ilustrasi 2D dengan siluet kuat, cahaya berlapis, palet warna yang berubah mengikuti lokasi, dan animasi lingkungan yang lembut. Arah atmosfer mengambil inspirasi umum dari platformer puitis seperti *Ori* dan *Gris*, dengan karakter, cerita, aset, dan dunia orisinal.

Pemain menjelajahi alam yang kehilangan cahaya, melompati jurang, melewati bahaya, dan mengumpulkan kristal. Tujuan perjalanan adalah menemukan Royal Crystal, sumber cahaya kuno yang dapat memulihkan keseimbangan kerajaan.

## Premis dan cerita

Dahulu, Royal Crystal menjaga siklus siang, kehidupan hutan, dan aliran energi di Kerajaan Lumeria. Saat kristal itu menghilang, langit meredup, tanaman bercahaya layu, dan jalur-jalur kuno tertutup. Tokoh utama—seorang pengembara muda tanpa identitas personal yang ditetapkan—memulai perjalanan mengikuti jejak serpihan kristal.

Sepanjang perjalanan, lingkungan menyampaikan kisah melalui reruntuhan, perubahan cahaya, dan gema suara. Pemain mengumpulkan kristal kecil untuk menambah skor dan mencari Royal Crystal sebagai artefak utama. Setelah menemukannya, perjalanan berakhir dengan cahaya yang kembali menyentuh Lumeria.

## Pilar desain

- **Eksplorasi yang terbaca:** jalur utama terlihat melalui kontras cahaya dan bentuk lingkungan; area samping memberi hadiah berupa kristal.
- **Gerakan yang responsif:** akselerasi halus, lompatan konsisten, dan pijakan lereng yang stabil.
- **Atmosfer yang bercerita:** palet, partikel, musik, dan latar berubah sesuai kondisi tiap area.
- **Bahaya yang adil:** ancaman terlihat sebelum pemain perlu bereaksi; checkpoint membatasi pengulangan perjalanan.

## Siklus permainan

1. Jelajahi area dan amati petunjuk visual.
2. Lintasi platform, lereng, jurang, dan rintangan lingkungan.
3. Hindari atau hadapi makhluk penjaga dan kumpulkan kristal.
4. Aktifkan checkpoint, lalu lanjutkan menuju area berikutnya.
5. Temukan Royal Crystal untuk memulihkan cahaya kerajaan.

## Kontrol pemain

| Aksi | Kontrol bawaan | Keterangan |
| --- | --- | --- |
| Bergerak kiri/kanan | Tombol panah kiri/kanan | Akselerasi dan perlambatan halus; sprite menghadap arah gerak. |
| Melompat | Enter atau Space (`ui_accept`) | Lompatan dilakukan saat karakter menyentuh tanah. Pemetaan dapat diubah di Input Map Godot. |
| Jeda | Escape (`ui_cancel`) | Membuka menu jeda jika menu tersebut tersedia di build. |

## Sistem permainan

- **Nyawa:** dimulai dari 100. Bahaya mengurangi nyawa; saat habis, scene dimulai ulang dan status run direset.
- **Skor:** kristal biasa menambah skor. Nilai kristal ditentukan oleh objek pickup.
- **Royal Crystal:** item tujuan utama. Pengambilan item ini menandai progres akhir permainan.
- **Checkpoint:** titik aman untuk menyimpan kemajuan area. Sistem penyimpanan checkpoint perlu diterapkan di scene.
- **Gerakan:** gravitasi memakai nilai default proyek Godot. `CharacterBody2D` menggunakan snap dan batas sudut lantai untuk membantu mengikuti lereng.

## Area level

### 1. Hutan Senja

Area pembuka untuk mengenalkan gerak, lompatan, pengumpulan kristal, dan checkpoint. Pepohonan tinggi membingkai platform berlumut, sementara spora bercahaya dan kabut memberi kedalaman. Bahaya awal berupa duri yang mudah dikenali dan celah pendek. Jalur samping mengajarkan pemain untuk memeriksa ruang di atas dan di bawah jalur utama.

### 2. Reruntuhan yang Tenggelam

Kompleks batu tua dengan ruang vertikal, platform runtuh, dan genangan yang memantulkan cahaya. Pemain membaca pola gerak platform dan mengatur waktu lompatan. Relief pada dinding memberi petunjuk tentang sejarah Royal Crystal. Palet biru kehijauan dan gema air membangun suasana sunyi.

### 3. Puncak Kristal

Pendakian terakhir di antara tebing dan formasi kristal yang rapuh. Angin dan platform sempit meningkatkan tantangan navigasi, sementara cahaya kristal menuntun pemain ke tujuan. Area puncak berisi Royal Crystal dan adegan pemulihan cahaya sebagai penutup petualangan.

## Audio dan presentasi

Musik ambient berkembang perlahan dari tekstur organik di hutan, gema berair di reruntuhan, hingga lapisan nada yang lebih terang di puncak. Efek suara menegaskan lompatan, pendaratan, kerusakan, checkpoint, dan pickup tanpa memenuhi ruang hening. Parallax, partikel, kabut, serta animasi cahaya memberi kesan hidup tanpa mengaburkan platform.

## Aksesibilitas dan keterbacaan

- Sediakan pemetaan ulang tombol melalui Input Map.
- Jaga perbedaan kontras antara platform aman, bahaya, dan latar.
- Berikan umpan balik visual dan audio yang konsisten untuk kerusakan dan pickup.
- Hindari menyampaikan informasi penting hanya melalui warna.

## Ruang lingkup implementasi awal

Versi awal mencakup gerak dasar pemain, tiga area platforming, kristal pickup, indikator nyawa/skor, checkpoint, dan kondisi akhir saat Royal Crystal ditemukan. Pertarungan kompleks, penyimpanan lintas sesi, dan variasi akhir cerita dapat dikembangkan setelah loop eksplorasi utama terasa solid.

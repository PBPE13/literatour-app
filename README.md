## Anggota Kelompok

1. James Zefanya Tumbelaka - 2206824653
2. Kenisha Jazlyn Malano - 2206030262
3. Raisa Diandra Survijanto - 2206814545
4. Rafi Ghani Harditama - 2206081364

## Link Apk
https://install.appcenter.ms/orgs/Literatour/apps/Literatour/distribution_groups/public

[![Build status](https://build.appcenter.ms/v0.1/apps/c35eb855-b523-4a09-a20e-eb520bf79023/branches/main/badge)](https://appcenter.ms)

## Deskripsi Aplikasi

LITERATOUR adalah suatu aplikasi yang digunakan sebagai perpustakaan daring. Dengan melakukan pendaftaran, pengguna dapat menggunakan berbagai fitur yang ditawarkan oleh LITERATOUR.
Pengguna yang telah mendaftar menjadi anggota dapat mencari beragam buku dari berbagai kategori yang tersedia dan melakukan peminjaman buku. Selain itu, pengguna dapat melakukan lebih banyak hal dengan fitur yang tersedia, seperti mencari dan mengunggah ulasan buku, berdiskusi dengan pengguna lain mengenai buku tertentu, serta membuat catatan pribadi tentang buku-buku yang telah dibaca.
LITERATOUR memungkinkan pengguna untuk mengeksplorasi dan menikmati dunia buku dalam lingkungan daring ini.

## Modul

1. Register dan Login Page
* Buat account
* Login user
* Login as guest

2. Landing Page
* Navbar Menu
- Pinjam dan mengembalikan buku
- Reading list / diary
- Review / ulas buku
- Forum
- Search buku
- Log out
* Display katalog buku dengan Card

3. Search Page
* Field untuk memasukkan keyword
* Radio button untuk menselect genre (predetermined)

4. Search Result Page
* Navbar Menu
* Display buku hasil search dengan Card
- Pada masing - masing card terdapat button pinjam
- Sort berdasarkan review terbanyak atau favorite terbanyak
- Menampilkan buku sudah terpinjam / tidak

5. Borrow and Return
* Menampilkan tanggal buku dipinjam
* Menampilkan data buku yang akan dipinjam
* Meminta input tanggal buku akan dikembalikan
* Button Borrow dan Return muncul berdasarkan status buku
* Button cancel action

6. Reading List Page (Diary)
* Menampilkan buku yang telah dibaca (Card)
* Menulis tanggal selesai membaca
* Menulis notes mengenai buku

7. Forum Page
* Diskusi buku oleh member

8. Review Page
* Dapat diakses dari card buku yang sudah dikembalikan
* Menampilkan data buku yang akan direview
* Field komentar untuk buku
* Button submit review
* Review dapat dilihat di card buku pada katalog

9. Profile Page
* Role user
* Nama user
* Bio data user
* Preferred genre user
* Log out

## Role

1. Admin
* Melakukan pengecekkan data peminjaman buku tiap member
* Memonitor aktivitas tiap user (access logs)

2. Member
* Mengakses katalog buku
* Mengakses halaman search buku
* Meminjam dan mengembalikan buku
* Menulis review
* Menulis pesan forum
* Menulis diary

3. Guest
* Mengakses katalog buku
* Mengakses halaman search buku

## Alur pengintegrasian dengan web service untuk terhubung dengan aplikasi web yang sudah dibuat saat Proyek Tengah Semester

1. Mengubah struktur project Flutter sehingga terpisah - pisah setiap modulnya.
2. Mengkonversi models dari tiap modul dalam project Django dengan menggunakan QuickType.
3. Membuat file `.dart` untuk menampung hasil konversi dari QuickType untuk digunakan dalam project Flutter.
4. Menambahkan aplikasi baru `authentication` dalam project Django.
5. Menambahkan `authentication` ke dalam `INSTALLED_APPS` pada `settings.py`.
6. Menambahkan `django-cors-headers` dalam `INSTALLED_APPS` pada `requirements.txt`.
7. Menambahkan `corsheaders` ke dalam `INSTALLED_APPS` pada `settings.py` di main project Django.
8. Menambahkan `corsheaders.middleware.CorsMiddleware` pada `MIDDLEWARE` di `settings.py` di main project Django.
9. Menambahkan variabel - variabel berikut pada `settings.py`.
```python
CORS_ALLOW_ALL_ORIGINS = True
CORS_ALLOW_CREDENTIALS = True
CSRF_COOKIE_SECURE = True
SESSION_COOKIE_SECURE = True
CSRF_COOKIE_SAMESITE = 'None'
SESSION_COOKIE_SAMESITE = 'None'
```
10. Membuat fungsi di `views.py` dan *path url* di `urls.py` aplikasi `authentication` untuk fitur `login`, `logout`, dan `register`.
11. Menggunakan *package* `pbp_django_auth`, `http`, dan `provider` untuk mengakses data JSON dari web server, melakukan HTTP GET dan POST untuk mengambil, menambahkan, memodifikasi, atau menghapus data pada database webserver.
12. Mengakses *url* fungsi yang digunakan pada tiap aplikasi Django pada project Flutter dan menghubungkannya dengan button yang akan dibuat dalam halaman aplikasi.
13. Menampilkan objek pada tiap aplikasi menggunakan widget `Card` dalam aplikasi Flutter.
14. Mengintegrasikan form pada Django dengan Flutter melalui pembuatan halaman flutter dengan `fields` yang berkorespondensi dengan `fields` pada form tiap aplikasi Django.

## Link Berita Acara
https://docs.google.com/spreadsheets/d/1xa2CowPCeD1xp96L4OnjCE8X95BwOGCqGDC2TpH7stA/edit?usp=sharing

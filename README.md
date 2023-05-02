# THERMOSMART

## DESKRIPSI

---

Repositori ini berisi kode program untuk Thermostat Pintar yang dibuat menggunakan bahasa assembly dan dijalankan pada platform Arduino. Sistem ini menggunakan sensor suhu (DHT 11) dan sensor water level untuk mengontrol suhu dalam ruangan dan mengaktifkan atau mematikan pendingin ruangan sesuai dengan kondisi suhu dan ketinggian air pendingin.

## KOMPONEN

---

1. Arduino Uno atau setara

2. Sensor suhu atau DHT11
3. Sensor Water Level

4. Relay atau transistor untuk kontrol pemanas atau pendingin udara
5. Buzzer
6. Seven Segment Display
7. Kabel Jumper

8. Modul Wi-Fi ESP8266 atau ESP32 (opsional)

## CARA KERJA

---

Sensor suhu akan membaca suhu dalam ruangan secara periodik. Jika suhu di atas ambang batas tertentu, sistem akan mengaktifkan relay untuk menyalakan pendingin ruangan. Begitu juga sebaliknya, jika suhu di bawah ambang batas tertentu, sistem akan mematikan relay untuk mematikan pendingin ruangan.

Selain itu, sensor water level akan membaca ketinggian air pendingin dalam bak pembuangan secara periodik. Jika ketinggian air sudah mencapai level maksimum, sistem akan mematikan relay untuk mematikan pendingin ruangan.

Sistem juga dilengkapi dengan display suhu yang dapat menampilkan suhu dalam dua mode yaitu Celsius dan Fahrenheit. Selain itu, sistem juga memiliki buzzer untuk memberikan notifikasi jika terjadi kondisi yang tidak normal seperti suhu terlalu tinggi atau ketinggian air sudah mencapai level maksimum.

## KONFIGURASI

---

1. Siapkan semua komponen yang dibutuhkan seperti sensor suhu (DHT 11), sensor water level, Arduino Uno, relay, buzzer, display 7 segment, dan kabel jumper.
2. Hubungkan sensor suhu dengan pin A0 pada Arduino Uno menggunakan kabel jumper.
3. Hubungkan sensor water level dengan pin digital pada Arduino Uno menggunakan kabel jumper.
4. Hubungkan relay dengan pin digital pada Arduino Uno menggunakan kabel jumper.
5. Hubungkan buzzer dengan pin digital pada Arduino Uno menggunakan kabel jumper.
6. Hubungkan display 7 segment dengan pin digital pada Arduino Uno menggunakan kabel jumper.
7. Buat rangkaian sesuai dengan diagram pada bagian README.
8. Buka software Arduino IDE dan buat program sesuai dengan kode pada bagian README.
9. Upload program ke Arduino Uno menggunakan kabel USB.
10. Pasang sensor suhu dan sensor water level di dalam ruangan yang ingin dikontrol suhunya.
11. Sambungkan pendingin ruangan dengan relay pada rangkaian.
12. Nyalakan Arduino Uno dan sistem siap digunakan.
13. Jika menggunakan modul Wi-Fi, hubungkan modul ke pin serial pada Arduino dan pastikan modul telah terhubung ke jaringan Wi-Fi yang diinginkan

## PENGUNAAN

---

1. Unduh atau clone repositori ini ke dalam komputer Anda

2. Buka file program dalam software Arduino IDE atau editor teks yang mendukung bahasa assembly

3. Sesuaikan nilai threshold suhu yang diinginkan pada kode program

4. Upload kode program ke board Arduino menggunakan kabel USB atau modul programmer

5. Tunggu hingga board Arduino selesai memproses program dan siap digunakan

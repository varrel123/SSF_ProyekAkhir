#DESKRIPSI
Repositori ini berisi kode program untuk Thermostat Pintar yang dibuat menggunakan bahasa assembly dan dijalankan pada platform Arduino. Sistem ini menggunakan sensor suhu untuk mengontrol suhu dalam ruangan dan mengaktifkan atau mematikan pemanas atau pendingin udara sesuai dengan nilai suhu yang terbaca.

#KOMPONEN
Arduino Uno atau setara
Sensor suhu LM35 atau DHT11
Relay atau transistor untuk kontrol pemanas atau pendingin udara
Modul Wi-Fi ESP8266 atau ESP32 (opsional)

#KONFIGURASI
Hubungkan sensor suhu ke pin ADC pada Arduino
Hubungkan relay atau transistor ke pin digital pada Arduino untuk mengontrol pemanas atau pendingin udara
Jika menggunakan modul Wi-Fi, hubungkan modul ke pin serial pada Arduino dan pastikan modul telah terhubung ke jaringan Wi-Fi yang diinginkan

#PENGUNAAN
Unduh atau clone repositori ini ke dalam komputer Anda
Buka file program dalam software Arduino IDE atau editor teks yang mendukung bahasa assembly
Sesuaikan nilai threshold suhu yang diinginkan pada kode program
Upload kode program ke board Arduino menggunakan kabel USB atau modul programmer
Tunggu hingga board Arduino selesai memproses program dan siap digunakan

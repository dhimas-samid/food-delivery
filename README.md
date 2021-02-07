# Food Delivery
Tugas mata kuliah **TPCA - Database System periode 2012 S1 Teknik Informatika Binus Online Learning** oleh:
- 2301968191 - Dhimas Anugrah Dwi Yunidar
- 2301969484 - Dikhi Martin
- 2301966532 - Aji Mufti Zakaria
- 2301968475 - Tutukho Rakha Hadyan
- 2301969313 - Novianti Fitti Suswanti Santi
- 2301969351 - Zidni Ilma
## Persyaratan
- docker
- docker-compose
###
Jalankan perintah `docker` dan `docker-compose` di terminal/cmd/powershell untuk memastikan docker dan docker-compose sudah ter-install dengan benar
## Memulai
Silakan jalankan perintah berikut di terminal/cmd/powershell, setelah berhasil clone repository
```
docker-compose up
```
Perintah tersebut akan menjalankan
- mariaDB
- adminer
- flyway (setelah migrasi akan stop)
## Akses database
### Melalui terminal/cmd/powershell
Jalankan perintah berikut di terminal/cmd/powershell
```
docker-compose exec mariadb bash
mysql -uroot -pmysecret
use survey
```
### Melalui adminer
Akses http://localhost:8080 menggunakan web browser dan masukkan
|Key|Value|
|----|----|
|System|MySQL|
|Server|mariadb|
|Username|root|
|Password|mysecret|
|Database|survey|
## Migrasi database
### Membuat file migrasi
#### Penamaan
```
V0.0.0__Add_new_table.sql
```
#### Direktori
```
./migrations
```
### Menjalankan migrasi (saja)
Jalankan perintah berikut di terminal/cmd/powershell
```
docker-compose up flyway
```
## Diagram
Diagram untuk tugas ini dapat dilihat di `./diagrams`
### Food Delivery Process Swimlane
### ERD

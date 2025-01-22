![Peduli Panti Logo](https://github.com/trfyrt/PeduliPanti/blob/main/PeduliPanti%20-%20FE/assets/img/pedulipanti.png)  
# Peduli Panti  

**Peduli Panti** adalah sebuah inisiatif yang bertujuan untuk mendukung panti asuhan melalui penyaluran donasi yang lebih adil dan transparan. Dengan memprioritaskan panti asuhan yang paling membutuhkan, program ini memastikan bahwa bantuan dapat diterima secara merata.  

Program ini dikembangkan menggunakan Flutter untuk aplikasi mobile dan Laravel sebagai backend. Selain itu, tersedia juga halaman berbasis web yang dirancang khusus untuk keperluan admin dan dinas sosial, sehingga pengelolaan data dan pemantauan distribusi bantuan dapat dilakukan dengan mudah dan efisien.  

Aplikasi ini adalah proyek akhir semester 3 yang bertujuan untuk membantu pencapaian beberapa tujuan pembangunan berkelanjutan (Sustainable Development Goals/SDGs), yaitu:  
- **SDG 1**: Tanpa Kemiskinan, melalui distribusi bantuan yang lebih efektif kepada panti asuhan.  
- **SDG 10**: Mengurangi Ketimpangan, dengan memastikan donasi disalurkan secara adil berdasarkan kebutuhan.  
- **SDG 16**: Perdamaian, Keadilan, dan Kelembagaan yang Kuat, dengan menciptakan transparansi dalam pengelolaan dan distribusi donasi.  

## Fitur Utama  
- **Sistem Prioritas Panti**: Menggunakan sistem ranking untuk menentukan tingkat kebutuhan setiap panti, sehingga distribusi bantuan dapat dilakukan dengan adil dan tepat sasaran.  
- **Sistem Permintaan Barang**: Fasilitas bagi panti untuk mengajukan kebutuhan barang secara langsung.  
- **AI RAB Checker**: Alat berbasis kecerdasan buatan untuk memeriksa Rencana Anggaran Biaya (RAB) dan laporan keuangan. Bekerja sebagai screening untuk meminimalisir kesalahan. 

## Cara Instalasi  
1. **Clone Repository**  
   Clone repository ini ke komputer Anda:  
   ```bash
   git clone https://github.com/trfyrt/PeduliPanti.git
   cd PeduliPanti
   ```

2. **Frontend**:  
   - Aplikasi mobile dibangun menggunakan **Flutter**. Pastikan Flutter SDK telah diinstal di perangkat Anda.  
   - Jalankan perintah berikut untuk memulai aplikasi:  
     ```bash
     cd '.\PeduliPanti - FE\'
     flutter pub get
     flutter run
     ```  

3. **Backend**:  
   - Backend menggunakan **Laravel**. Pastikan server PHP, Composer, dan environment telah diatur.
   - Jalankan perintah berikut untuk memulai server backend:  
     ```bash
     cd '.\PeduliPanti - BE\'
     composer install
     cp .env.example .env
     php artisa key:generate
     php artisan migrate:fresh --seed
     php artisan serve
     ```  

4. **Halaman Website**:  
   - Akses halaman web admin melalui browser untuk pengelolaan data dan pemantauan oleh dinas sosial.

## Lebih Lanjut Tentang **PeduliPanti**
1. [Board Miro](https://miro.com/app/board/uXjVLFhK5Xc=/)
2. [Presentasi Canva](https://www.canva.com/design/DAGc61XmmNM/GoK7CKIxDid5JfY4FRMHow/edit?utm_content=DAGc61XmmNM&utm_campaign=designshare&utm_medium=link2&utm_source=sharebutton)

## Tim Pengembang  
**By Group PeduliPanti | IMT UCM '23**  
- **[Aaron Jevon Benedict Kongdoh](https://github.com/trfyrt)** - 0806022310014
- **[Alvin Yuga Pramana](https://github.com/bigbosspramana)** - 0806022310004  
- **[Derick Norlan](https://github.com/Dericknorlan)** - 0806022310005  
- **[Habibie Zikrillah](https://github.com/habibiezkrillh)** - 0806022329001  
- **[Jason Bintang Setiawan](https://github.com/Jasonbs1)** - 0806022310011  

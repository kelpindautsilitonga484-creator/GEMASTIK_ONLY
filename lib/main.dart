import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // Widget ini adalah akar (root) dari aplikasi Anda.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // Ini adalah tema dari aplikasi Anda.
        //
        // COBA INI: Jalankan aplikasi Anda dengan "flutter run". Anda akan melihat
        // aplikasi memiliki toolbar berwarna ungu. Kemudian, tanpa menutup aplikasi,
        // coba ubah seedColor pada colorScheme di bawah menjadi Colors.green
        // lalu jalankan "hot reload" (simpan perubahan Anda atau tekan tombol "hot
        // reload" pada IDE yang mendukung Flutter, atau tekan "r" jika Anda menggunakan
        // command line untuk menjalankan aplikasi).
        //
        // Perhatikan bahwa nilai counter tidak kembali ke nol; state aplikasi
        // tidak hilang selama proses reload. Untuk mengatur ulang state, gunakan
        // hot restart sebagai gantinya.
        //
        // Ini juga berlaku untuk kode, bukan hanya nilai: Sebagian besar perubahan
        // kode dapat diuji hanya dengan melakukan hot reload.
        colorScheme: .fromSeed(seedColor: Colors.deepPurple),
      ),  
      home: const MyHomePage(title: 'POSMAN mantap'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // Widget ini adalah halaman utama dari aplikasi Anda. Widget ini bersifat stateful,
  // yang berarti memiliki objek State (didefinisikan di bawah) yang berisi field
  // yang memengaruhi tampilannya.

  // Class ini adalah konfigurasi untuk state. Class ini menyimpan nilai-nilai (dalam
  // hal ini title) yang diberikan oleh parent (dalam hal ini widget App) dan
  // digunakan oleh method build dari State. Field pada subclass Widget selalu
  // diberi tanda "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // Pemanggilan setState ini memberi tahu framework Flutter bahwa sesuatu telah
      // berubah pada State ini, yang menyebabkan method build di bawah dijalankan
      // ulang sehingga tampilan dapat mencerminkan nilai yang telah diperbarui.
      // Jika kita mengubah _counter tanpa memanggil setState(), maka method build
      // tidak akan dipanggil kembali, sehingga tidak akan terlihat ada perubahan.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Method ini dijalankan ulang setiap kali setState dipanggil, misalnya seperti
    // yang dilakukan oleh method _incrementCounter di atas.
    //
    // Framework Flutter telah dioptimalkan agar proses menjalankan ulang method build
    // berlangsung cepat, sehingga Anda cukup membangun ulang bagian yang perlu
    // diperbarui daripada harus mengubah setiap instance widget secara terpisah.
    return Scaffold(
      appBar: AppBar(
        // COBA INI: Coba ubah warna di sini menjadi warna tertentu (misalnya
        // Colors.amber?) lalu lakukan hot reload untuk melihat AppBar berubah
        // warna sementara warna lainnya tetap sama.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Di sini kita mengambil nilai dari objek MyHomePage yang dibuat oleh
        // method App.build, lalu menggunakannya untuk mengatur judul appbar.
        title: Text(widget.title),
      ),
      body: Center(
        // Center adalah widget layout. Widget ini menerima satu child dan
        // menempatkannya di tengah parent.
        child: Column(
          // Column juga merupakan widget layout. Widget ini menerima daftar child
          // dan menyusunnya secara vertikal. Secara default, ukurannya menyesuaikan
          // dengan child secara horizontal, dan berusaha setinggi parent-nya.
          //
          // Column memiliki berbagai properti untuk mengatur ukuran dirinya dan
          // cara memosisikan child. Di sini kita menggunakan mainAxisAlignment untuk
          // memusatkan child secara vertikal; main axis di sini adalah sumbu vertikal
          // karena Column bersifat vertikal (sedangkan cross axis adalah horizontal).
          //
          // COBA INI: Jalankan "debug painting" (pilih aksi "Toggle Debug Paint"
          // di IDE, atau tekan "p" pada console), untuk melihat wireframe dari
          // setiap widget.
          mainAxisAlignment: .center,
          children: [
            const Text('You have pushed the button this many times:'),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:donatur_peduli_panti/Models/Product.dart';
import 'package:donatur_peduli_panti/Services/api_service.dart';
import 'package:donatur_peduli_panti/Services/auth_service.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: RequestPage(),
    );
  }
}

class RequestPage extends StatefulWidget {
  @override
  _RequestPageState createState() => _RequestPageState();
}

class _RequestPageState extends State<RequestPage> {
  late Future<List<Product>> futureProducts;
  List<int> itemCounts = [];
  int? pantiID;

  @override
  void initState() {
    super.initState();
    futureProducts = ApiService.fetchProducts();
    _loadPantiDetails();
  }

  // Function to load pantiDetails from SharedPreferences
  Future<void> _loadPantiDetails() async {
    final pantiDetails = await AuthService.getPantiDetails();
    if (pantiDetails != null) {
      setState(() {
        pantiID =
            pantiDetails['id']; // Get pantiID from the stored pantiDetails
      });
    }
  }

  Future<void> submitRequests(List<Product> products) async {
    if (pantiID == null) {
      // Handle case where pantiID is not available (e.g., not logged in)
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content:
                const Text('Panti ID is not available. Please log in again.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
      return;
    }

    try {
      for (int i = 0; i < products.length; i++) {
        if (itemCounts[i] > 0) {
          // Cek apakah permintaan sudah ada
          int? existingRequestID = await ApiService.getRequestID(
              pantiID!, products[i].id); // Use dynamic pantiID here

          if (existingRequestID != null) {
            // Jika request sudah ada, lakukan update
            await ApiService.updateRequest(
              requestID: existingRequestID,
              pantiID: pantiID!, // Use dynamic pantiID here
              productID: products[i].id,
              requestedQty: itemCounts[i],
            );
          } else {
            // Jika request belum ada, lakukan store (POST)
            await ApiService.postRequest(
              pantiID: pantiID!, // Use dynamic pantiID here
              productID: products[i].id,
              requestedQty: itemCounts[i],
            );
          }
        }
      }

      // Tampilkan dialog sukses
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Permintaan Terkirim'),
            content: const Text(
                'Permintaan barang berhasil dikirim, silahkan menunggu persetujuan.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    } catch (error) {
      // Tangani error
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: Text('Gagal mengirim permintaan: $error'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Req Barang Kebutuhan',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
        backgroundColor: const Color.fromARGB(255, 232, 243, 255),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: FutureBuilder<List<Product>>(
        future: futureProducts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No products available'));
          } else {
            final products = snapshot.data!;
            // Inisialisasi itemCounts hanya jika kosong
            if (itemCounts.isEmpty) {
              itemCounts = List.generate(products.length, (index) => 0);
            }

            return Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Column(
                children: [
                  Expanded(
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 16.0,
                        crossAxisSpacing: 16.0,
                        childAspectRatio: 0.8,
                      ),
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        final product = products[index];
                        return Card(
                          color: const Color.fromARGB(255, 232, 243, 255),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15.0, vertical: 12.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: product.image != null
                                      ? Image.network(product.image!)
                                      : const Placeholder(
                                          fallbackHeight: 60,
                                          fallbackWidth: double.infinity,
                                          child: Center(
                                              child: Text('Foto Barang'))),
                                ),
                                const SizedBox(height: 8.0),
                                Text(
                                  product.name,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.remove),
                                      onPressed: () {
                                        setState(() {
                                          if (itemCounts[index] > 0) {
                                            itemCounts[index]--;
                                          }
                                        });
                                      },
                                    ),
                                    Text(
                                      '${itemCounts[index]}',
                                      style: const TextStyle(fontSize: 20),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.add),
                                      onPressed: () {
                                        setState(() {
                                          itemCounts[index]++;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ElevatedButton(
                      onPressed: () => submitRequests(products),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(255, 145, 215, 255),
                        minimumSize: const Size.fromHeight(50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 5,
                      ),
                      child: const Text('Kirim',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}

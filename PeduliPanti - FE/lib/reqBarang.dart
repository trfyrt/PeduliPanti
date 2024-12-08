import 'package:flutter/material.dart';

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
  List<int> itemCounts = List.generate(6, (index) => 3); // Default count for each item

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Req Barang Kebutuhan', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
        backgroundColor: const Color.fromARGB(255, 232, 243, 255), // Adjusted color to match home page
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        elevation: 0, // Remove shadow for a flatter look
        centerTitle: true, // Center the title
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.black),
            onPressed: () {
              // Add notification functionality here
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Column(
          children: [
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16.0, // Added more spacing between rows
                  crossAxisSpacing: 16.0, // Added more spacing between columns
                  childAspectRatio: 0.8, // Adjusted aspect ratio for smaller cards
                ),
                itemCount: itemCounts.length,
                itemBuilder: (context, index) {
                  return Card(
                    color: const Color.fromARGB(255, 232, 243, 255), // Adjusted color to match home page
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0), // More modern rounded corners
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 12.0), // Added more padding
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Expanded(
                            child: Placeholder(
                              fallbackHeight: 60, // Reduced height for smaller cards
                              fallbackWidth: double.infinity,
                              child: Center(child: Text('Foto Barang')),
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          const Text(
                            'Nama Barang',
                            style: TextStyle(fontWeight: FontWeight.bold),
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
                                '${itemCounts[index]}', // Display the current count
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
                onPressed: () {
                  // Navigate back to home and show a success message
                  Navigator.pop(context);
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Permintaan Terkirim'),
                        content: const Text('Permintaan barang berhasil dikirim, silahkan menunggu persetujuan.'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(); // Close the dialog
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 145, 215, 255), // Adjusted color to match home page
                  minimumSize: const Size.fromHeight(50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30), // Modern rounded button
                  ),
                  elevation: 5, // Add elevation for a modern look
                ),
                child: const Text('Kirim', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)), // Bold text for emphasis
              ),
            ),
          ],
        ),
      ),
    );
  }
}
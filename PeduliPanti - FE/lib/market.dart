import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Market extends StatefulWidget {
  const Market({super.key});

  @override
  State<Market> createState() => _MarketAppState();
}

class _MarketAppState extends State<Market> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Peduli Panti',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color.fromARGB(255, 254, 254, 254),
      ),
      home: const MarketPage(title: 'Peduli Panti'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MarketPage extends StatefulWidget {
  const MarketPage({super.key, required this.title});

  final String title;

  @override
  State<MarketPage> createState() => _MarketPage();
}

class _MarketPage extends State<MarketPage> {
  final List<Map<String, dynamic>> _items = [
    {'name': 'Minyak Goreng 1L', 'price': 'Rp. 17.500', 'quantity': 0},
    {'name': 'Gula Pasir 1kg', 'price': 'Rp. 13.000', 'quantity': 0},
    {'name': 'Tepung Terigu 1kg', 'price': 'Rp. 10.000', 'quantity': 0},
  ];

  void _incrementQuantity(int index) {
    setState(() {
      _items[index]['quantity']++;
    });
  }

  void _decrementQuantity(int index) {
    setState(() {
      if (_items[index]['quantity'] > 0) {
        _items[index]['quantity']--;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.only(top: 48),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(
                    child: Text(
                      'Panti Asuhan 1',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 30, bottom: 5, left: 20),
                    child: Text(
                      'Kami Membutuhkan',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  ..._items.asMap().entries.map((entry) {
                    int index = entry.key;
                    Map<String, dynamic> item = entry.value;
                    return Stack(
                      children: [
                        Container(
                          width: double.infinity,
                          height: 93,
                          margin: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
                                spreadRadius: 1,
                                blurRadius: 3,
                                offset: const Offset(0, 4),
                              )
                            ],
                            borderRadius:
                                const BorderRadius.all(Radius.circular(15)),
                            gradient: const LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: [
                                  Color.fromARGB(255, 193, 211, 254),
                                  Color.fromARGB(255, 255, 255, 255)
                                ],
                                stops: [
                                  0.2,
                                  0.7
                                ]),
                          ),
                          child: Container(
                            margin: const EdgeInsets.only(left: 95),
                            padding: const EdgeInsets.symmetric(vertical: 25),
                            child: Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item['name'],
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                    Text(item['price']),
                                  ],
                                ),
                                const Spacer(),
                                Row(
                                  children: [
                                    IconButton(
                                      onPressed: () =>
                                          _decrementQuantity(index),
                                      icon: const Icon(Icons.remove,
                                          color: Colors.black),
                                    ),
                                    Text(
                                      '${item['quantity']}',
                                      style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    IconButton(
                                      onPressed: () =>
                                          _incrementQuantity(index),
                                      icon: const Icon(Icons.add,
                                          color: Colors.black),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          top: 29,
                          left: 40,
                          child: Container(
                            padding: const EdgeInsets.all(28),
                            decoration: const BoxDecoration(
                              color: Color.fromARGB(255, 244, 244, 244),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(100)),
                            ),
                          ),
                        ),
                        const Positioned(
                          top: 45,
                          left: 48,
                          child: Text(
                            '1/10',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                  Container(
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 20),
                          child: Text(
                            'Paket Donasi',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          height: 100,
                          child: Column(
                            children: [
                              Container(
                                child: Row(
                                  children: [
                                    Container(
                                      child: Icon(
                                        FontAwesomeIcons.angleLeft,
                                        size: 20,
                                      ),
                                    ),
                                    Container(
                                      
                                    ),
                                    Container(
                                      child: Icon(
                                        FontAwesomeIcons.angleRight,
                                        size: 20,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 40,
            right: 15,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 147, 181, 255),
                borderRadius: BorderRadius.circular(30),
              ),
              child: const Icon(
                FontAwesomeIcons.cartShopping,
                size: 20,
              ),
            ),
          ),
          Positioned(
            top: 40,
            left: 15,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 147, 181, 255),
                borderRadius: BorderRadius.circular(30),
              ),
              child: const Icon(
                FontAwesomeIcons.angleLeft,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

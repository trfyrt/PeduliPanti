import 'package:donatur_peduli_panti/Models/Bundle.dart';
import 'package:donatur_peduli_panti/Models/Cart.dart';
import 'package:donatur_peduli_panti/Models/Panti.dart';
import 'package:donatur_peduli_panti/Models/Product.dart';
import 'package:donatur_peduli_panti/Models/RequestList.dart';
import 'package:donatur_peduli_panti/homeDonatur.dart';
import 'package:flutter/material.dart';
import 'package:donatur_peduli_panti/Services/api_service.dart';
import 'package:intl/intl.dart';

class Keranjang extends StatelessWidget {
  const Keranjang({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Peduli Panti',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color.fromARGB(255, 254, 254, 254),
      ),
      home: const KeranjangPage(),
    );
  }
}

class KeranjangPage extends StatefulWidget {
  const KeranjangPage({Key? key}) : super(key: key);

  @override
  State<KeranjangPage> createState() => _KeranjangPageState();
}

class _KeranjangPageState extends State<KeranjangPage> {
  Cart? cart;
  List<Product> _products = [];
  List<Bundle> _bundles = [];
  List<RequestList> _requests = [];
  List<Panti> _pantiList = [];
  bool isLoading = true;
  Map<int, List<bool>> _selectedItems = {};
  Map<int, bool> _selectedPanti = {};
  Map<int, int> _productQuantities = {};
  Map<int, int> _bundleQuantities = {};
  Map<int, int> _requestQuantities = {};

  @override
  void initState() {
    super.initState();
    fetchCartData();
  }

  Future<void> fetchCartData() async {
    try {
      final fetchedCart = await ApiService.fetchCart();
      if (fetchedCart == null) throw Exception('Keranjang kosong.');

      final products = await ApiService.fetchProducts();
      final bundles = await ApiService.fetchBundles();
      final requests = await ApiService.fetchRequestLists();
      final pantis = await ApiService.fetchPantiDetails();

      Map<int, List<bool>> selectionStates = {};
      Map<int, bool> pantiStates = {};
      Map<int, int> productQty = {};
      Map<int, int> bundleQty = {};
      Map<int, int> requestQty = {};

      Map<int, List<dynamic>> itemsByPanti = {};

      // Group products
      for (var product in fetchedCart.products) {
        if (!itemsByPanti.containsKey(product.pantiID)) {
          itemsByPanti[product.pantiID] = [];
        }
        itemsByPanti[product.pantiID]!.add(product);
      }

      // Group bundles
      for (var bundle in fetchedCart.bundles) {
        if (!itemsByPanti.containsKey(bundle.pantiID)) {
          itemsByPanti[bundle.pantiID] = [];
        }
        itemsByPanti[bundle.pantiID]!.add(bundle);
      }

      // Group requests
      for (var request in fetchedCart.requestLists) {
        if (!itemsByPanti.containsKey(request.pantiID)) {
          itemsByPanti[request.pantiID] = [];
        }
        itemsByPanti[request.pantiID]!.add(request);
      }

      // Initialize selection states
      itemsByPanti.forEach((pantiID, items) {
        selectionStates[pantiID] = List.filled(items.length, false);
        pantiStates[pantiID] = false; // Initialize panti checkbox state
      });

      setState(() {
        cart = fetchedCart;
        _products = products;
        _bundles = bundles;
        _requests = requests;
        _pantiList = pantis;
        _selectedItems = selectionStates;
        _selectedPanti = pantiStates;
        _productQuantities = productQty;
        _bundleQuantities = bundleQty;
        _requestQuantities = requestQty;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error fetching data: $e');
    }
  }

  void updateItemQuantity(dynamic item, bool increase) {
    setState(() {
      if (item is CartProduct) {
        int currentQty = _productQuantities[item.productID] ?? item.quantity;
        if (increase) {
          _productQuantities[item.productID] = currentQty + 1;
        } else if (currentQty > 1) {
          _productQuantities[item.productID] = currentQty - 1;
        }
      } else if (item is CartBundle) {
        int currentQty = _bundleQuantities[item.bundleID] ?? item.quantity;
        if (increase) {
          _bundleQuantities[item.bundleID] = currentQty + 1;
        } else if (currentQty > 1) {
          _bundleQuantities[item.bundleID] = currentQty - 1;
        }
      } else if (item is CartRequest) {
        int currentQty = _requestQuantities[item.requestID] ?? item.quantity;
        if (increase) {
          _requestQuantities[item.requestID] = currentQty + 1;
        } else if (currentQty > 1) {
          _requestQuantities[item.requestID] = currentQty - 1;
        }
      }
    });
  }

  void _handlePantiSelection(int pantiID, bool? value) {
    setState(() {
      _selectedPanti[pantiID] = value ?? false;
      if (_selectedItems.containsKey(pantiID)) {
        _selectedItems[pantiID] =
            List.filled(_selectedItems[pantiID]!.length, value ?? false);
      }
    });
  }

  // Update: Method to handle individual item selection
  void _handleItemSelection(int pantiID, int itemIndex, bool? value) {
    setState(() {
      _selectedItems[pantiID]![itemIndex] = value ?? false;
      // Check if all items are selected
      bool allSelected = _selectedItems[pantiID]!.every((item) => item == true);
      bool anySelected = _selectedItems[pantiID]!.any((item) => item == true);
      _selectedPanti[pantiID] = allSelected;
    });
  }

  Product? _getProductById(int productId) {
    return _products.firstWhere((product) => product.id == productId);
  }

  Bundle? _getBundleById(int bundleId) {
    return _bundles.firstWhere((bundle) => bundle.id == bundleId);
  }

  RequestList? _getRequestById(int requestId) {
    return _requests.firstWhere((request) => request.id == requestId);
  }

  String _getPantiNameById(int pantiID) {
    final panti = _pantiList.firstWhere(
      (panti) => panti.id == pantiID,
    );
    return panti.name;
  }

  Widget _buildCartItem(dynamic item, int pantiID, int itemIndex) {
    String name = '';
    int quantity = 0;
    int price = 0;

    if (item is CartProduct) {
      final product = _getProductById(item.productID);
      name = product?.name ?? 'Produk tidak ditemukan';
      quantity = _productQuantities[item.productID] ?? item.quantity;
      price = (product?.price ?? 0) * quantity;
    } else if (item is CartBundle) {
      final bundle = _getBundleById(item.bundleID);
      name = bundle?.name ?? 'Bundle tidak ditemukan';
      quantity = _bundleQuantities[item.bundleID] ?? item.quantity;
      price = (bundle?.price ?? 0) * quantity;
    } else if (item is CartRequest) {
      final request = _getRequestById(item.requestID);
      final product =
          request != null ? _getProductById(request.productID) : null;
      name = product?.name ?? 'Produk tidak ditemukan';
      quantity = _requestQuantities[item.requestID] ?? item.quantity;
      price = (product?.price ?? 0) * quantity;
    }

    return Card(
      color: Colors.white,
      elevation: 2,
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 0),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 120,
                  width: double.infinity,
                  color: Colors.grey[300],
                  child: Center(
                    child: Text('Foto Barang',
                        style: TextStyle(color: Colors.grey[600])),
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Rp. ${NumberFormat("#,###", "id_ID").format(price)}',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(Icons.remove, size: 20),
                      onPressed: () {
                        updateItemQuantity(item, false);
                      },
                    ),
                    Text(
                      quantity.toString(),
                      style: TextStyle(fontSize: 14),
                    ),
                    IconButton(
                      icon: Icon(Icons.add, size: 20),
                      onPressed: () {
                        updateItemQuantity(item, true);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Checkbox positioned at top-right
          Positioned(
            top: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(8),
                ),
              ),
              child: Checkbox(
                activeColor: Color.fromARGB(255, 26, 74, 230),
                value: _selectedItems[pantiID]?[itemIndex] ?? false,
                onChanged: (bool? value) {
                  _handleItemSelection(pantiID, itemIndex, value);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (cart == null) {
      return const Scaffold(
        body: Center(child: Text('Keranjang Anda kosong.')),
      );
    }

    final groupedItems = <int, List<dynamic>>{};

    for (var item in cart!.products) {
      if (!groupedItems.containsKey(item.pantiID)) {
        groupedItems[item.pantiID] = [];
      }
      groupedItems[item.pantiID]!.add(item);
    }

    for (var item in cart!.bundles) {
      if (!groupedItems.containsKey(item.pantiID)) {
        groupedItems[item.pantiID] = [];
      }
      groupedItems[item.pantiID]!.add(item);
    }

    for (var item in cart!.requestLists) {
      if (!groupedItems.containsKey(item.pantiID)) {
        groupedItems[item.pantiID] = [];
      }
      groupedItems[item.pantiID]!.add(item);
    }

    int calculateTotalPrice() {
      int total = 0;
      if (cart != null) {
        groupedItems.forEach((pantiID, items) {
          items.asMap().entries.forEach((entry) {
            int index = entry.key;
            dynamic item = entry.value;

            // Only calculate for selected items
            if (_selectedItems[pantiID]?[index] ?? false) {
              if (item is CartProduct) {
                final product = _getProductById(item.productID);
                final quantity =
                    _productQuantities[item.productID] ?? item.quantity;
                total += (product?.price ?? 0) * quantity;
              } else if (item is CartBundle) {
                final bundle = _getBundleById(item.bundleID);
                final quantity =
                    _bundleQuantities[item.bundleID] ?? item.quantity;
                total += (bundle?.price ?? 0) * quantity;
              } else if (item is CartRequest) {
                final request = _getRequestById(item.requestID);
                final product =
                    request != null ? _getProductById(request.productID) : null;
                final quantity =
                    _requestQuantities[item.requestID] ?? item.quantity;
                total += (product?.price ?? 0) * quantity;
              }
            }
          });
        });
      }
      return total;
    }

    int getSelectedItemsCount() {
      int count = 0;
      _selectedItems.forEach((pantiID, selections) {
        count += selections.where((isSelected) => isSelected).length;
      });
      return count;
    }

    void _handlePantiSelection(int pantiID, bool? value) {
      setState(() {
        _selectedPanti[pantiID] = value ?? false;
        if (_selectedItems.containsKey(pantiID)) {
          // Update all items under this panti
          _selectedItems[pantiID] =
              List.filled(_selectedItems[pantiID]!.length, value ?? false);
        }
      });
    }

    final List<Widget> itemWidgets = [];
    groupedItems.forEach((pantiID, items) {
      // Add panti header with checkbox
      itemWidgets.add(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            children: [
              Checkbox(
                activeColor: Color.fromARGB(255, 26, 74, 230),
                value: _selectedPanti[pantiID] ?? false,
                onChanged: (bool? value) {
                  _handlePantiSelection(pantiID, value);
                },
              ),
              Text(
                'Panti ${_getPantiNameById(pantiID)}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      );

      itemWidgets.addAll(
        items.asMap().entries.map((entry) {
          return _buildCartItem(entry.value, pantiID, entry.key);
        }),
      );
    });

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomeDonaturApp()),
            );
          },
        ),
        title: const Text(
          'Keranjang Saya',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
        backgroundColor: Color(0xFF93B5FF),
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ...groupedItems.entries.map((entry) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            child: Text(
                              'Panti ${_getPantiNameById(entry.key)}',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          GridView.count(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            crossAxisCount: 2,
                            childAspectRatio: 0.75,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            children:
                                entry.value.asMap().entries.map((itemEntry) {
                              return _buildCartItem(
                                itemEntry.value,
                                entry.key,
                                itemEntry.key,
                              );
                            }).toList(),
                          ),
                        ],
                      );
                    }).toList(),
                  ],
                ),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: Offset(0, -2),
                ),
              ],
            ),
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Rp. ${NumberFormat("#,###", "id_ID").format(calculateTotalPrice())}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    Text(
                      '${getSelectedItemsCount()} Terpilih',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: () {
                    // Handle order button press
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF93B5FF),
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Beli Sekarang',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

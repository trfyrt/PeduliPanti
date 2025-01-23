import 'package:donatur_peduli_panti/Models/Bundle.dart';
import 'package:donatur_peduli_panti/Models/Cart.dart';
import 'package:donatur_peduli_panti/Models/Panti.dart';
import 'package:donatur_peduli_panti/Models/Product.dart';
import 'package:donatur_peduli_panti/Models/RequestList.dart';
import 'package:donatur_peduli_panti/Services/auth_service.dart';
import 'package:donatur_peduli_panti/homeDonatur.dart';
import 'package:donatur_peduli_panti/pesanan.dart';
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
      // Get the current user
      final user = await AuthService.getUser();
      if (user == null) {
        throw Exception('User not logged in');
      }

      final int userId = user['id'];

      final fetchedCart = await ApiService.fetchCart(userId);
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
    Widget? imageWidget;

    if (item is CartProduct) {
      final product = _getProductById(item.productID);
      name = product?.name ?? 'Produk tidak ditemukan';
      quantity = _productQuantities[item.productID] ?? item.quantity;
      price = (product?.price ?? 0) * quantity;
      imageWidget = Image.network(
        product?.image ?? 'https://via.placeholder.com/150',
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: Colors.grey[200],
            child: const Icon(
              Icons.image_not_supported_sharp,
              color: Colors.grey,
              size: 50,
            ),
          );
        },
      );
    } else if (item is CartBundle) {
      final bundle = _getBundleById(item.bundleID);
      name = bundle?.name ?? 'Bundle tidak ditemukan';
      quantity = _bundleQuantities[item.bundleID] ?? item.quantity;
      price = (bundle?.price ?? 0) * quantity;

      // Calculate remaining items for overlay
      final remainingItems = bundle?.products.length ?? 0;
      final hasAdditionalItems = remainingItems > 1;

      imageWidget = Stack(
        fit: StackFit.expand,
        children: [
          // Main image
          Image.network(
            bundle?.products.isNotEmpty == true
                ? bundle!.products[0].image ?? 'https://via.placeholder.com/150'
                : 'https://via.placeholder.com/150',
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: Colors.grey[200],
                child: const Icon(
                  Icons.image_not_supported_sharp,
                  color: Colors.grey,
                  size: 50,
                ),
              );
            },
          ),
          // Overlay for additional items
          if (hasAdditionalItems)
            Positioned(
              bottom: 8,
              right: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${remainingItems - 1}+',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      );
    } else if (item is CartRequest) {
      final request = _getRequestById(item.requestID);
      final product =
          request != null ? _getProductById(request.productID) : null;
      name = product?.name ?? 'Produk tidak ditemukan';
      quantity = _requestQuantities[item.requestID] ?? item.quantity;
      price = (product?.price ?? 0) * quantity;
      imageWidget = Image.network(
        product?.image ?? 'https://via.placeholder.com/150',
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: Colors.grey[200],
            child: const Icon(
              Icons.image_not_supported_sharp,
              color: Colors.grey,
              size: 50,
            ),
          );
        },
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = MediaQuery.of(context).size.width;
        final itemWidth = (screenWidth - 42) / 2;
        final aspectRatio = itemWidth / (itemWidth * 1.2);

        return Card(
          color: Colors.white,
          elevation: 2,
          margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 0),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AspectRatio(
                      aspectRatio: 1.2,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: imageWidget,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Rp. ${NumberFormat("#,###", "id_ID").format(price)}',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[600],
                            ),
                          ),
                          const Spacer(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.remove, size: 20),
                                onPressed: () {
                                  updateItemQuantity(item, false);
                                },
                              ),
                              Text(
                                quantity.toString(),
                                style: const TextStyle(fontSize: 14),
                              ),
                              IconButton(
                                icon: const Icon(Icons.add, size: 20),
                                onPressed: () {
                                  updateItemQuantity(item, true);
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  height: 35,
                  width: 35,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(8),
                    ),
                  ),
                  child: Checkbox(
                    activeColor: const Color.fromARGB(255, 26, 74, 230),
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
      },
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
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Color(0xFF93B5FF),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(16),
          ),
        ),
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
                    // First, let's update the section in your build method where you create the panti headers:
                    ...groupedItems.entries.map((entry) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            child: Row(
                              children: [
                                // This checkbox will control all items under this panti
                                Icon(
                                  Icons.auto_awesome,
                                  size: 16,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  'Panti ${_getPantiNameById(entry.key)}',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Checkbox(
                                  activeColor:
                                      const Color.fromARGB(255, 26, 74, 230),
                                  value: _selectedPanti[entry.key] ?? false,
                                  onChanged: (bool? value) {
                                    _handlePantiSelection(entry.key, value);
                                  },
                                ),
                              ],
                            ),
                          ),
                          GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                              childAspectRatio:
                                  MediaQuery.of(context).size.width > 600
                                      ? 0.8
                                      : 0.68,
                            ),
                            itemCount: entry.value.length,
                            itemBuilder: (context, index) {
                              return _buildCartItem(
                                entry.value[index],
                                entry.key,
                                index,
                              );
                            },
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
            padding: EdgeInsets.zero, // Remove all padding
            height: 60,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 16),
                  child: Column(
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
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.6,
                  height: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      List<SelectedItem> selectedItems = [];

                      groupedItems.forEach((pantiID, items) {
                        String pantiName = _getPantiNameById(pantiID);

                        items.asMap().entries.forEach((entry) {
                          int index = entry.key;
                          dynamic item = entry.value;

                          if (_selectedItems[pantiID]?[index] ?? false) {
                            String itemName = '';
                            int quantity = 0;
                            int price = 0;
                            int totalPrice = 0;

                            if (item is CartProduct) {
                              final product = _getProductById(item.productID);
                              itemName =
                                  product?.name ?? 'Produk tidak ditemukan';
                              quantity = _productQuantities[item.productID] ??
                                  item.quantity;
                              price = product?.price ?? 0;
                              totalPrice = price * quantity;
                            } else if (item is CartBundle) {
                              final bundle = _getBundleById(item.bundleID);
                              itemName =
                                  bundle?.name ?? 'Bundle tidak ditemukan';
                              quantity = _bundleQuantities[item.bundleID] ??
                                  item.quantity;
                              price = bundle?.price ?? 0;
                              totalPrice = price * quantity;
                            } else if (item is CartRequest) {
                              final request = _getRequestById(item.requestID);
                              final product = request != null
                                  ? _getProductById(request.productID)
                                  : null;
                              itemName =
                                  product?.name ?? 'Produk tidak ditemukan';
                              quantity = _requestQuantities[item.requestID] ??
                                  item.quantity;
                              price = product?.price ?? 0;
                              totalPrice = price * quantity;
                            }

                            selectedItems.add(SelectedItem(
                              pantiName: pantiName,
                              itemName: itemName,
                              quantity: quantity,
                              price: price,
                              totalPrice: totalPrice,
                            ));
                          }
                        });
                      });

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              Pesanan(selectedItems: selectedItems),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF93B5FF),
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      'Beli Sekarang',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
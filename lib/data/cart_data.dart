import 'package:flutter/foundation.dart';
import '../models/product.dart';

ValueNotifier<List<Product>> cartNotifier = ValueNotifier([]);

void addToCart(Product product) {
  cartNotifier.value = [...cartNotifier.value, product];
}

void removeFromCart(Product product) {
  final list = [...cartNotifier.value];
  list.remove(product);
  cartNotifier.value = list;
}

void clearCart() {
  cartNotifier.value = [];
}

double getCartTotal() {
  return cartNotifier.value.fold(0, (sum, item) => sum + item.price);
}


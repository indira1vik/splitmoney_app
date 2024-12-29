void calculateWeightedPrices(
  List<Product> products, 
  double totalSum, 
  double tax, 
  double offer, 
  double tip, 
  double delivery
) {
  for (var product in products) {
    double weightage = product.price / totalSum;
    double deliveryShare = weightage * delivery;
    double taxShare = weightage * tax;
    double tipShare = weightage * tip;
    double offerShare = weightage * offer;

    // Calculate final price for the product after applying all shares
    product.finalPrice = product.price - offerShare + deliveryShare + taxShare + tipShare;
  }
}

void splitProductPrices(
  List<Product> products, 
  List<Roommate> roommates
) {
  for (var product in products) {
    print('${product.name} - \$${product.finalPrice}');
    print('Enter number of roommates to split among:');
    
    int splitAmong = int.parse(stdin.readLineSync()!);

    double share = product.finalPrice / splitAmong;

    if (splitAmong == roommates.length) {
      // Split among all roommates
      for (var roommate in roommates) {
        roommate.debt += share;
      }
    } else {
      // Let user select roommates to split the cost with
      print('Select roommates by name:');
      for (var roommate in roommates) {
        print(roommate.name);
      }
      for (int i = 0; i < splitAmong; i++) {
        String selectedRoommate = stdin.readLineSync()!;
        roommates.firstWhere((r) => r.name == selectedRoommate).debt += share;
      }
    }
  }
}

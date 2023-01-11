class RewardItem {
  final int itemId;
  final String itemName;
  final String itemTitle;
  final String itemCost;
  final String itempicture;

  RewardItem(
      {required this.itemId,
      required this.itemName,
      required this.itemTitle,
      required this.itemCost,
      required this.itempicture});

  factory RewardItem.fromJson(Map<String, dynamic> json) {
    return RewardItem(
      itemId: json['item_id'],
      itemName: json['item_name'],
      itemTitle: json['item_title'],
      itemCost: json['item_cost'],
      itempicture: json['item_picture'],
    );
  }
}

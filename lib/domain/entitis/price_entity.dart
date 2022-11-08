import 'package:equatable/equatable.dart';

class PriceEntity extends Equatable {
  const PriceEntity(
      {required this.symbolID,
      required this.name,
      required this.description,
      required this.source,
      required this.price,
      required this.iconUri});

  final String symbolID;
  final String name;
  final String description;
  final String source;
  final double price;
  final String iconUri;

  String toUrlParams(int categoryUID) => '?category=$categoryUID&'
      'symbolID=$symbolID&symbol=$name'
      '&price=$price&icon=$iconUri';

  @override
  List<Object?> get props => [symbolID, price];
}

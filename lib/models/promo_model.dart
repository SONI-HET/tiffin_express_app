import 'package:equatable/equatable.dart';

class Promo extends Equatable {
  final int id;
  final String title;
  final String description;
  final String imageUrl;

  Promo(
      {required this.id,
      required this.title,
      required this.description,
      required this.imageUrl});

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    imageUrl,

      ];

      static List<Promo> promos =[
        Promo(id: 1, title: 'Free Delivery On Your First 3 Orders', description: 'Place an order of \u{20B9}500 or more and the deleivery fee is on us.', imageUrl: 'https://th.bing.com/th/id/OIP.l3CpsRi35AWI_wv7xrh_tQHaEr?w=303&h=191&c=7&r=0&o=5&dpr=1.3&pid=1.7'),
        Promo(id: 2, title: 'You Can Use Vouchers if you orders more tiffins', description: 'You can get \u{20B9} 500 to \u{20B9} 700 off if you order more tiffins and you can get free vouchers on festivals.', imageUrl: 'https://i.pinimg.com/736x/bf/98/48/bf9848dab93c0722bb00d1aa4c76ae8b--voucher.jpg'),
        Promo(id: 3, title: 'Experienced TIffin Service Providers are available', description: 'Many well-known tiffin service providers who having high rating and good reviews are available', imageUrl: 'https://th.bing.com/th/id/OIP.KCS6OHvb0U-qz_ekVhesQAAAAA?w=148&h=180&c=7&r=0&o=5&dpr=1.3&pid=1.7'),


        
      ];
}

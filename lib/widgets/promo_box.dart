

import 'package:flutter/material.dart';
import 'package:tiffin_express_app/models/promo_model.dart';

class PromoBox extends StatelessWidget {

  final Promo promo;
  const PromoBox({super.key ,required this.promo});

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Container(
        margin: const EdgeInsets.only(right: 5.0),
        width: MediaQuery.of(context).size.width - 40,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.0),
            color: Color.fromARGB(255, 13, 50, 172),
            image: DecorationImage(
              image: NetworkImage(
                promo.imageUrl,
              ),
              fit: BoxFit.cover,
            )),
      ),
      ClipPath(
        clipper: PromoCustomClipper(),
        child: Container(
          margin: const EdgeInsets.only(right: 5.0),
          width: MediaQuery.of(context).size.width - 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.0),
            color: Color.fromARGB(255, 13, 50, 172),
          ),
          child: Padding(
            padding: const EdgeInsets.only(top: 10, left: 15, right: 125),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                 promo.title,
                  style: TextStyle(color: Colors.white,fontSize: 17, fontFamily: 'Roboto',fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 15,
                ),
                Text(
                    promo.description,
                    style: TextStyle(color: Colors.white,fontSize: 15, fontFamily: 'Roboto', fontWeight: FontWeight.w400),),
              ],
            ),
          ),
        ),
      ),
    ]);
  }
}


class PromoCustomClipper extends CustomClipper<Path>{
  @override
  Path getClip(Size size) {
    var path = new Path();
    path.lineTo(0, 0);
    path.lineTo(0, size.height);
    path.lineTo(225, size.height);
    path.lineTo(275, 0);

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }

}
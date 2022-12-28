import 'package:flutter/material.dart';
import 'poppins_text.dart';
import '../models/order_response.dart';
import 'image_loader.dart';

class OrderCard extends StatelessWidget {
  const OrderCard({Key? key, required this.order, required this.route})
      : super(key: key);

  final OrderResponse order;
  final Widget route;

  String _statusChecker(String status) {
    if (status == "pending") {
      return 'Product Offered';
    } else if (status == "accepted") {
      return "Offer Accepted";
    } else if (status == "declined") {
      return "Offer Declined";
    } else {
      return "Something went wrong";
    }
  }

  @override
  Widget build(BuildContext context) {
    double baseWidth = 360;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    return GestureDetector(
      onTap: () => Navigator.of(context, rootNavigator: true).push(
        MaterialPageRoute(builder: (context) {
          return route;
        }),
      ),
      child: Container(
        margin: EdgeInsets.fromLTRB(0 * fem, 0 * fem, 0 * fem, 8 * fem),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin:
                      EdgeInsets.fromLTRB(0 * fem, 0 * fem, 16 * fem, 0 * fem),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12 * fem),
                    child: ImageLoader(
                      height: 70 * fem,
                      width: 70 * fem,
                      imageUrl: order.product.imageUrl,
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.fromLTRB(
                          0 * fem, 0 * fem, 0 * fem, 4 * fem),
                      child: PoppinsText(
                        text: _statusChecker(order.status),
                        color: const Color(0xff8a8a8a),
                        fontSize: 13,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(
                          0 * fem, 0 * fem, 0 * fem, 4 * fem),
                      child: PoppinsText(
                        text: order.productName,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(
                          0 * fem, 0 * fem, 0 * fem, 4 * fem),
                      child: PoppinsText(
                        text: "Tl. ${order.basePrice}",
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(
                          0 * fem, 0 * fem, 0 * fem, 8 * fem),
                      child: PoppinsText(
                        text: "Offered Tl. ${order.price}",
                      ),
                    )
                  ],
                )
              ],
            ),
            Divider(
              color: const Color(0xffe5e5e5),
              thickness: 1 * fem,
            )
          ],
        ),
      ),
    );
  }
}

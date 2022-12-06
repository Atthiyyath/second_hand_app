import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:second_hand_app/models/product_detail_response.dart';
import 'package:second_hand_app/repositories/market_repository.dart';
import 'package:second_hand_app/widgets/show_loading.dart';

import '../../bloc/product_detail/product_detail_page_bloc.dart';
import '../../bloc/product_detail/product_detail_page_events.dart';
import '../../bloc/product_detail/product_detail_page_states.dart';
import '../../widgets/show_snack_bar.dart';

class ProductDetailpage extends StatelessWidget {
  final String id;
  const ProductDetailpage({Key? key, required this.id})
      : super(
          key: key,
        );

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          ProductDetailBloc(MarketRepository())..add(GetData(id)),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Detail'),
        ),
        body: BlocConsumer<ProductDetailBloc, ProductDetailPageState>(
          builder: (context, state) {
            if (state is ProductDetailPageLoadingState) {
              return const ShowLoading();
            }

            if (state is ProductDetailPageLoadedState) {
              final ProductDetailResponse product = state.products;
              return Content(
                product: product,
              );
            }
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text('Something went wrong...'),
                  ],
                ),
              ],
            );
          },
          listener: (context, state) {
            if (state is ProductDetailPageErrorState) {
              showSnackBar(context, 'Something went wrong', state.error,
                  ContentType.failure);
            }
            if (state is BidSuccessState) {
              showSnackBar(context, 'Bid Successful', state.response,
                  ContentType.success);
            }
            if (state is BidFailedState) {
              showSnackBar(context, 'Something went wrong', state.error,
                  ContentType.failure);
            }
          },
        ),
      ),
    );
  }
}

class Content extends StatelessWidget {
  final ProductDetailResponse product;
  const Content({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final TextEditingController bidController = TextEditingController();

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: ImageLoader(product: product)),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(product.name),
                Text(product.basePrice.toString())
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(product.user?.fullName ?? "No user information"),
                Text(product.user?.city ?? "No user information")
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [const Text('Description'), Text(product.description)],
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
            child: Column(
              children: [
                TextField(
                  keyboardType: TextInputType.number,
                  controller: bidController,
                  decoration: const InputDecoration(labelText: 'Bid Price'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (bidController.text.trim().isNotEmpty) {
                      BlocProvider.of<ProductDetailBloc>(context).add(
                        Order(
                          product.id.toString(),
                          bidController.text.trim(),
                        ),
                      );
                    }
                  },
                  child: const Text("Start Bargain"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ImageLoader extends StatelessWidget {
  final ProductDetailResponse product;
  const ImageLoader({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <CachedNetworkImage>[
        CachedNetworkImage(
          imageUrl: product.imageUrl,
          progressIndicatorBuilder: (context, url, downloadProgress) =>
              const Center(child: Text('Loading image...')),
          errorWidget: (context, url, error) => const Icon(Icons.error),
          fit: BoxFit.cover,
          height: size.height * 0.4,
          width: size.width,
        )
      ],
    );
  }
}

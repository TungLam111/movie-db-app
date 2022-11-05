import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mock_bloc_stream/utils/color.dart';
import 'package:mock_bloc_stream/utils/urls.dart';
import 'package:shimmer/shimmer.dart';

import '../../domain/entities/tv.dart';
import 'minimal_detail.dart';

class HorizontalItemList extends StatelessWidget {
  const HorizontalItemList({
    Key? key,
    required this.tvs,
  }) : super(key: key);
  final List<Tv> tvs;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 170.0,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        itemCount: tvs.length,
        itemBuilder: (BuildContext context, int index) {
          final Tv tv = tvs[index];
          return Container(
            padding: const EdgeInsets.only(right: 8.0),
            child: InkWell(
              onTap: () {
                showModalBottomSheet(
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10.0),
                      topRight: Radius.circular(10.0),
                    ),
                  ),
                  context: context,
                  builder: (BuildContext context) {
                    return MinimalDetail(
                      tv: tv,
                    );
                  },
                );
              },
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(16)),
                child: CachedNetworkImage(
                  width: 120.0,
                  fit: BoxFit.cover,
                  imageUrl: Urls.imageUrl(tv.posterPath!),
                  placeholder: (BuildContext context, String url) =>
                      Shimmer.fromColors(
                    baseColor: ColorConstant.kGrey850,
                    highlightColor: ColorConstant.kGrey800,
                    child: Container(
                      height: 170.0,
                      width: 120.0,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                  errorWidget:
                      (BuildContext context, String url, dynamic error) =>
                          const Icon(Icons.error),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mock_bloc_stream/utils/color.dart';
import 'package:mock_bloc_stream/utils/styles.dart';
import 'package:mock_bloc_stream/utils/urls.dart';

import '../../domain/entities/movie.dart';
import '../pages/movie_detail_page.dart';

class ItemCard extends StatelessWidget {
  const ItemCard({
    Key? key,
    required this.movie,
  }) : super(key: key);
  final Movie movie;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context)
            .pushNamed(MovieDetailPage.routeName, arguments: movie.id);
      },
      child: Container(
        padding: const EdgeInsets.all(8.0),
        margin: const EdgeInsets.only(bottom: 16.0),
        decoration: BoxDecoration(
          color: ColorConstant.kGrey850,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Row(
          children: <Widget>[
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: CachedNetworkImage(
                  imageUrl: Urls.imageUrl(
                    movie.posterPath!,
                  ),
                  placeholder: (BuildContext context, String url) =>
                      const Center(
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget:
                      (BuildContext context, String url, dynamic error) =>
                          const Icon(Icons.error),
                ),
              ),
            ),
            const SizedBox(width: 16.0),
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    movie.title ?? '-',
                    overflow: TextOverflow.ellipsis,
                    style: StylesConstant.kHeading6,
                    maxLines: 1,
                  ),
                  const SizedBox(height: 4.0),
                  Row(
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8.0,
                          vertical: 2.0,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.redAccent,
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                        child: Text(movie.releaseDate!.split('-')[0]),
                      ),
                      const SizedBox(width: 16.0),
                      const Icon(
                        Icons.star,
                        color: Colors.amber,
                        size: 18.0,
                      ),
                      const SizedBox(width: 4.0),
                      Text(
                        (movie.voteAverage! / 2).toStringAsFixed(1),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  Text(
                    movie.overview ?? '-',
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

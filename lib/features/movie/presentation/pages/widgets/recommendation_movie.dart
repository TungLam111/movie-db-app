import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mock_bloc_stream/core/base/bloc_provider.dart';
import 'package:mock_bloc_stream/core/extension/extension.dart';
import 'package:mock_bloc_stream/features/movie/presentation/bloc/movie_detail/movie_detail_bloc.dart';
import 'package:mock_bloc_stream/utils/color.dart';
import 'package:mock_bloc_stream/utils/common_util.dart';
import 'package:mock_bloc_stream/utils/enum.dart';
import 'package:mock_bloc_stream/utils/urls.dart';
import 'package:shimmer/shimmer.dart';

import 'package:mock_bloc_stream/features/movie/domain/entities/movie.dart';
import 'package:mock_bloc_stream/features/movie/presentation/widgets/minimal_detail.dart';

class MovieRecommendation extends StatelessWidget {
  const MovieRecommendation({super.key});

  @override
  Widget build(BuildContext context) {
    return RequiredStreamBuilder<TupleEx2<List<Movie>, RequestState>>(
      stream: BlocProvider.of<MovieDetailBloc>(
        context,
      ).suggestStream,
      builder: (
        BuildContext context,
        AsyncSnapshot<TupleEx2<List<Movie>, RequestState>> snapshot,
      ) {
        if (!snapshot.hasData || snapshot.data == null) {
          return const SliverToBoxAdapter(
            child: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.data!.value2 == RequestState.loaded) {
          return SliverGrid(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                final Movie recommendation = snapshot.data!.value1[index];
                return FadeInUp(
                  from: 20,
                  duration: const Duration(milliseconds: 500),
                  child: GestureDetector(
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
                            movie: recommendation,
                          );
                        },
                      );
                    },
                    child: ClipRRect(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(4.0)),
                      child: CachedNetworkImage(
                        imageUrl: Urls.imageUrl(recommendation.posterPath!),
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
                        errorWidget: (
                          BuildContext context,
                          String url,
                          dynamic error,
                        ) =>
                            const Icon(Icons.error),
                        height: 180.0,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                );
              },
              childCount: snapshot.data!.value1.length,
            ),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              mainAxisSpacing: 8.0,
              crossAxisSpacing: 8.0,
              childAspectRatio: 0.7,
              crossAxisCount:
                  (MediaQuery.of(context).orientation == Orientation.portrait)
                      ? 3
                      : 4,
            ),
          );
        }
        if (snapshot.data!.value2 == RequestState.error) {
          return const SliverToBoxAdapter(
            child: Center(
              child: Text(
                'Cannot get recommendation',
              ),
            ),
          );
        }
        return const SliverToBoxAdapter(
          child: Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}

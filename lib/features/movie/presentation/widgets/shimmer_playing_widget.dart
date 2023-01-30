import 'package:flutter/material.dart';
import 'package:mock_bloc_stream/utils/color.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerPlayingWidget extends StatelessWidget {
  const ShimmerPlayingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (Rect rect) {
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[
            Colors.transparent,
            Colors.black,
            Colors.black,
            Colors.transparent,
          ],
          stops: <double>[0, 0.3, 0.5, 1],
        ).createShader(
          Rect.fromLTRB(0, 0, rect.width, rect.height),
        );
      },
      blendMode: BlendMode.dstIn,
      child: Shimmer.fromColors(
        baseColor: ColorConstant.kGrey850,
        highlightColor: ColorConstant.kGrey800,
        child: Container(
          height: 575.0,
          width: MediaQuery.of(context).size.width,
          color: Colors.black,
        ),
      ),
    );
  }
}

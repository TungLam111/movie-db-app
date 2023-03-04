import 'package:flutter/material.dart';
import 'package:mock_bloc_stream/utils/styles.dart';

class SubHeading extends StatelessWidget {
  const SubHeading({
    Key? key,
    required this.text,
    required this.onSeeMoreTapped,
  }) : super(key: key);
  final String text;
  final Function() onSeeMoreTapped;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(
        16.0,
        24.0,
        16.0,
        8.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(text, style: StylesConstant.kHeading6),
          InkWell(
            onTap: onSeeMoreTapped,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: const <Widget>[
                  Text('See More'),
                  Icon(Icons.arrow_forward_ios, size: 16.0)
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

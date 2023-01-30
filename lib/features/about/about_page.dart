import 'package:flutter/material.dart';
import 'package:mock_bloc_stream/utils/color.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({Key? key}) : super(key: key);
  static const String routeName = '/about';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About'),
      ),
      body: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              Expanded(
                child: Container(
                  color: ColorConstant.kRichBlack,
                  child: const Center(
                    child: Text(
                      'MDB',
                      style: TextStyle(
                        fontSize: 64.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.redAccent,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(32.0),
                  color: ColorConstant.kRichBlack,
                  child: const Text(
                    '''Movie Database (MDB) is a movie and tv series catalog app developed by Aditya Rohman sebagai as a project submission for Flutter Developer Expert course on Dicoding Indonesia.''',
                    style: TextStyle(fontSize: 16.0),
                    textAlign: TextAlign.justify,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

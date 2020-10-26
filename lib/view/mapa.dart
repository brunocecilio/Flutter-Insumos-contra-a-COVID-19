import 'package:flutter/material.dart';
import 'package:insumos_covid19/model/covid_data.dart';
import 'package:flutter_image_map/flutter_image_map.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:insumos_covid19/util/contants.dart';

class Mapa extends StatelessWidget {
  Mapa(this.data);

  final CovidData data;

  static List<List<Offset>> points = Constants.mapPoints;

  final List<Path> polygonRegions = points.map((e) {
    Path p = Path();
    p.addPolygon(e, true);
    return p;
  }).toList();

  void _onTap(int i) {
    Fluttertoast.cancel();
    Fluttertoast.showToast(
        msg: Constants.mapNames[i] +
            " \n" +
            (data.totals[Constants.mapNames[i]].toDouble() / 1000000.0)
                .toStringAsFixed(2) +
            " milhões de insumos recebidos",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 1,
        backgroundColor: Constants.toastBgColor,
        textColor: Constants.toastTextColor,
        fontSize: 16.0);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: (MediaQuery.of(context).size.width * 0.9),
      child: ImageMap(
        imagePath: 'assets/mapa.png',
        imageSize: Size(1280, 1280),
        onTap: _onTap,
        regions: polygonRegions,
        regionColors: data.mapColors,
      ),
    );
  }
}

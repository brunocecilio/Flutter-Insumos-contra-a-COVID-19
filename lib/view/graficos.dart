import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

import 'package:insumos_covid19/model/covid_data.dart';

class Graficos extends StatelessWidget {
  Graficos(this.data);

  final CovidData data;
  static final animate = true;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Text(
          'Situação dos Insumos',
          textAlign: TextAlign.center,
          style: TextStyle(height: 2, fontSize: 16),
        ),
        Container(
            height: 250,
            child: charts.BarChart(
              data.statusChartData,
              animate: animate,
              barRendererDecorator: new charts.BarLabelDecorator<String>(),
            )),
        Text(
          'Insumos por Estado',
          textAlign: TextAlign.center,
          style: TextStyle(height: 2, fontSize: 16),
        ),
        Container(
          height: 250,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              Container(
                  width: 3000,
                  child: charts.BarChart(
                    data.estadosChartData,
                    animate: animate,
                    barRendererDecorator:
                        new charts.BarLabelDecorator<String>(),
                  ))
            ],
          ),
        ),
        Text(
          'Insumos por Data',
          textAlign: TextAlign.center,
          style: TextStyle(height: 2, fontSize: 16),
        ),
        Container(
          height: 250,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              Container(
                width: 1000,
                child: new charts.TimeSeriesChart(
                  data.tempoChartData,
                  animate: animate,
                  dateTimeFactory: charts.LocalDateTimeFactory(),
                ),
              )
            ],
          ),
        ),
        Text(
          'Insumos por Tipo',
          textAlign: TextAlign.center,
          style: TextStyle(height: 2, fontSize: 16),
        ),
        Container(
          height: 250,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              Container(
                  width: 1000,
                  child: charts.BarChart(
                    data.tiposChartData,
                    animate: animate,
                    barRendererDecorator:
                        new charts.BarLabelDecorator<String>(),
                  ))
            ],
          ),
        ),
      ],
    );
  }
}

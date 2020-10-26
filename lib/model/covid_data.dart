import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

import 'package:insumos_covid19/model/data_entry.dart';
import 'package:insumos_covid19/model/charts_data.dart';

class CovidData {
  final List<DataEntry> inputs;
  final Map<String, int> totals;
  final int minTotals;
  final int maxTotals;
  final List<Color> mapColors;
  final List<charts.Series<OrdinalInputs, String>> estadosChartData;
  final List<charts.Series<TimeSeriesInput, DateTime>> tempoChartData;
  final List<charts.Series<OrdinalInputs, String>> tiposChartData;
  final List<charts.Series<OrdinalInputs, String>> statusChartData;

  CovidData(
      {this.inputs,
      this.totals,
      this.minTotals,
      this.maxTotals,
      this.mapColors,
      this.estadosChartData,
      this.tempoChartData,
      this.tiposChartData,
      this.statusChartData});
}

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

import 'package:insumos_covid19/model/charts_data.dart';
import 'package:insumos_covid19/model/data_entry.dart';
import 'package:insumos_covid19/model/covid_data.dart';
import 'package:insumos_covid19/util/contants.dart';
import 'package:insumos_covid19/util/number_formatter.dart';

Future<CovidData> fetchData() async {
  final response = await http.get(Constants.webServiceURL);

  if (response.statusCode == 200) {
    final decodeData = utf8.decode(response.bodyBytes);
    final LineSplitter ls = new LineSplitter();
    List<String> lines = ls.convert(decodeData);
    List<DataEntry> entries = [];
    Map<String, int> totalsMap = new Map();
    List<OrdinalInputs> estadosChartList = List<OrdinalInputs>();
    List<TimeSeriesInput> tempoChartList = List<TimeSeriesInput>();
    Map<DateTime, int> tempoChartMap = new Map();
    List<OrdinalInputs> tipoChartList = List<OrdinalInputs>();
    Map<String, int> tipoChartMap = new Map();
    List<OrdinalInputs> statusChartList = List<OrdinalInputs>();
    Map<String, int> statusChartMap = new Map();
    int minTotal;
    int maxTotal;
    CovidData covidData;

    for (int i = 0; i < Constants.mapNames.length; i++) {
      totalsMap[Constants.mapNames[i]] = 0;
    }

    for (int i = 1; i < lines.length; i++) {
      String line = lines[i];
      var arr = line.split(';');
      DataEntry entry = new DataEntry(
          material: arr[0],
          dtSaida: DateTime.parse(arr[1]),
          numPedido: int.parse(arr[2]),
          requisitante: arr[3],
          unidade: arr[4],
          quantidade: double.parse(arr[5].replaceAll(',', '.')),
          status: arr[6]);
      entries.add(entry);

      if (tempoChartMap.containsKey(entry.dtSaida)) {
        tempoChartMap[entry.dtSaida] += entry.quantidade.toInt();
      } else {
        tempoChartMap[entry.dtSaida] = entry.quantidade.toInt();
      }

      if (tipoChartMap.containsKey(entry.material)) {
        tipoChartMap[entry.material] += entry.quantidade.toInt();
      } else {
        tipoChartMap[entry.material] = entry.quantidade.toInt();
      }

      if (statusChartMap.containsKey(entry.status)) {
        statusChartMap[entry.status] += entry.quantidade.toInt();
      } else {
        statusChartMap[entry.status] = entry.quantidade.toInt();
      }

      if (totalsMap[entry.requisitante] != null) {
        totalsMap[entry.requisitante] =
            totalsMap[entry.requisitante] + entry.quantidade.toInt();
      }
    }

    entries.sort((a, b) => b.dtSaida.compareTo(a.dtSaida));

    totalsMap.forEach((key, value) {
      if (maxTotal == null || value > maxTotal) maxTotal = value;
      if (minTotal == null || value < minTotal) minTotal = value;
    });

    List<Color> colors =
        List.generate(totalsMap.length, (index) => Constants.mapMinColor);

    for (int i = 0; i < totalsMap.length; i++) {
      colors[i] = Color.alphaBlend(
              Constants.mapMaxColor.withOpacity(
                  totalsMap[Constants.mapNames[i]].toDouble() /
                      (maxTotal.toDouble())),
              colors[i])
          .withOpacity(0.85);

      estadosChartList.add(new OrdinalInputs(
          totalsMap.keys.elementAt(i), totalsMap.values.elementAt(i)));
    }

    estadosChartList.sort((a, b) {
      if (a.label == 'Outros Órgãos Federais') return 1;
      if (b.label == 'Outros Órgãos Federais') return -1;
      return a.label.compareTo(b.label);
    });

    tempoChartMap.forEach((key, value) {
      tempoChartList.add(new TimeSeriesInput(key, value));
    });

    tempoChartList.sort((a, b) => a.time.compareTo(b.time));

    tipoChartMap.forEach((key, value) {
      tipoChartList.add(new OrdinalInputs(key, value));
    });

    tipoChartList.sort((a, b) => a.label.compareTo(b.label));

    statusChartMap.forEach((key, value) {
      statusChartList.add(new OrdinalInputs(key, value));
    });

    statusChartList.sort((a, b) => a.label.compareTo(b.label));

    final charts.Series<OrdinalInputs, String> estadosChartData =
        new charts.Series<OrdinalInputs, String>(
      id: 'InsumosPorEstado',
      colorFn: (_, __) =>
          charts.ColorUtil.fromDartColor(Constants.chartsPrimaryColor),
      domainFn: (OrdinalInputs input, _) => input.label,
      measureFn: (OrdinalInputs input, _) => input.value,
      data: estadosChartList,
      labelAccessorFn: (OrdinalInputs input, _) =>
          toStringSepareted(input.value),
    );

    final charts.Series<TimeSeriesInput, DateTime> tempoChartData =
        new charts.Series<TimeSeriesInput, DateTime>(
      id: 'InsumosPorData',
      colorFn: (_, __) =>
          charts.ColorUtil.fromDartColor(Constants.chartsPrimaryColor),
      domainFn: (TimeSeriesInput input, _) => input.time,
      measureFn: (TimeSeriesInput input, _) => input.value,
      data: tempoChartList,
    );

    final charts.Series<OrdinalInputs, String> tipoChartData =
        new charts.Series<OrdinalInputs, String>(
      id: 'InsumosPorTipo',
      colorFn: (_, __) =>
          charts.ColorUtil.fromDartColor(Constants.chartsPrimaryColor),
      domainFn: (OrdinalInputs input, _) => input.label,
      measureFn: (OrdinalInputs input, _) => input.value,
      data: tipoChartList,
      labelAccessorFn: (OrdinalInputs input, _) =>
          toStringSepareted(input.value),
    );

    final charts.Series<OrdinalInputs, String> statusChartData =
        new charts.Series<OrdinalInputs, String>(
      id: 'InsumosPorStatus',
      colorFn: (_, __) =>
          charts.ColorUtil.fromDartColor(Constants.chartsPrimaryColor),
      domainFn: (OrdinalInputs input, _) => input.label,
      measureFn: (OrdinalInputs input, _) => input.value,
      data: statusChartList,
      labelAccessorFn: (OrdinalInputs input, _) =>
          toStringSepareted(input.value),
    );

    covidData = new CovidData(
        inputs: entries,
        totals: totalsMap,
        minTotals: minTotal,
        maxTotals: maxTotal,
        mapColors: colors,
        estadosChartData: [estadosChartData],
        tempoChartData: [tempoChartData],
        tiposChartData: [tipoChartData],
        statusChartData: [statusChartData]);

    return covidData;
  } else {
    throw Exception('Falha ao recuperar dados');
  }
}

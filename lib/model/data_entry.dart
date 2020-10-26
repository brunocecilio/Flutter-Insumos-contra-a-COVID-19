class DataEntry {
  final String material;
  final DateTime dtSaida;
  final int numPedido;
  final String requisitante;
  final String unidade;
  final double quantidade;
  final String status;

  DataEntry(
      {this.material,
      this.dtSaida,
      this.numPedido,
      this.requisitante,
      this.unidade,
      this.quantidade,
      this.status});
}

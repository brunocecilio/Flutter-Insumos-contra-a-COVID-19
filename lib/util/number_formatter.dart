final RegExp reg = new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
final Function mathFunc = (Match match) => '${match[1]},';

String toStringSepareted(int input) {
  String result = input.toString().replaceAllMapped(reg, mathFunc);
  return result;
}

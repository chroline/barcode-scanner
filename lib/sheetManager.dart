import 'package:gsheets/gsheets.dart';

const _credentials = ""; // TODO: add service account credentials

const _sheetId = ""; // TODO: add sheet id

final gsheets = GSheets(_credentials);

Future updateCode(String code) async {
  Worksheet sheet = (await gsheets.spreadsheet(_sheetId)).worksheetById(0);

  final barcodeNumbers = (await sheet.cells.column(1));
  int barcodeRow = barcodeNumbers.indexWhere((cell) => cell.value == code) + 1;

  if (barcodeRow == 0) {
    int openRow = barcodeNumbers.indexWhere((cell) => cell.value == "") + 1;
    barcodeRow = openRow > 0 ? openRow : barcodeNumbers.length + 1;
  }

  int quantity;

  try {
    quantity =
        int.parse((await sheet.cells.cell(row: barcodeRow, column: 2)).value);
  } catch (e) {
    quantity = 0;
  } finally {
    quantity++;
  }

  DateTime now = DateTime.now();

  await sheet.values.insertRow(barcodeRow, [code, quantity, now.toString()]);
}

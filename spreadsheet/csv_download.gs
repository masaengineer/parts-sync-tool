/**
 * スプレッドシートを開いたときにカスタムメニューを追加します。
 */
function onOpen() {
  var ui = SpreadsheetApp.getUi();
  ui.createMenu('カスタムメニュー')
    .addItem('CSVをダウンロード', 'showDownloadDialog')
    .addToUi();
}

/**
 * フィルタリングされたCSVデータのダウンロードリンクを含むダイアログを表示します。
 */
function showDownloadDialog() {
  var result = generateFilteredCSV();
  var csvContent = result.csv;
  var sheetName = result.sheetName;

  // ファイル名を生成 ("Wisewill 委託分データ " + シート名)
  // スラッシュなどをファイル名として安全な形にエスケープ
  var safeSheetName = escapeFileName(sheetName);
  var fileName = 'Wisewill 委託分データ ' + safeSheetName + '.csv';

  // BOM付きUTF-8でCSVデータを作成
  var csvContentWithBOM = '\ufeff' + csvContent;

  var blob = Utilities.newBlob(csvContentWithBOM, 'text/csv', fileName);
  var file = DriveApp.createFile(blob);

  var csvData = Utilities.parseCsv(csvContent);

  // 新しいスプレッドシートの名前を変更
  var newSS = SpreadsheetApp.create(
    'Wisewill 委託分データ (' + sheetName + ')'
  );
  var sheet = newSS.getActiveSheet();

  sheet.clear();
  sheet.getRange(1, 1, csvData.length, csvData[0].length).setValues(csvData);

  var fileUrl = file.getDownloadUrl();
  var sheetUrl = newSS.getUrl();

  var htmlContent =
    '<p>以下からCSVをダウンロードできます：</p>' +
    '<p><a href="' +
    fileUrl +
    '" target="_blank">CSVダウンロード (' +
    sheetName +
    ')</a></p>' + //ここはsheetNameだけでOK。fileNameはblob生成時に使われている。
    '<p>スプレッドシートとして開く場合はこちら：</p>' +
    '<p><a href="' +
    sheetUrl +
    '" target="_blank">Googleスプレッドシートを開く</a></p>';

  var html = HtmlService.createHtmlOutput(htmlContent)
    .setWidth(400)
    .setHeight(250);
  SpreadsheetApp.getUi().showModalDialog(html, 'ダウンロードリンク');
}

/**
 * ファイル名として安全な文字列にエスケープします。
 * @param {string} fileName エスケープするファイル名
 * @return {string} エスケープされたファイル名
 */
function escapeFileName(fileName) {
  // ファイル名に使用できない文字を置換
  return fileName.replace(/[/\\?%*:|"<>]/g, '_');
}

/**
 * アクティブなシートからデータをフィルタリングし、CSV形式の文字列とシート名を返します。
 * @return {{csv: string, sheetName: string}} フィルタリングされたCSVデータとシート名を含むオブジェクト
 */
function generateFilteredCSV() {
  var ss = SpreadsheetApp.getActiveSpreadsheet();
  var sheet = ss.getActiveSheet();
  var data = sheet.getDataRange().getValues();

  var result = [];
  // CSVのヘッダー行を変更
  result.push([
    'order_number',
    'manufacturer_name',
    'purchase_price',
    'handling_fee',
    'option_fee',
  ]);

  var orderNumberPattern = /^\d{2}-\d{5}-\d{5}$/;

  var colOrderNum = 1; // B列
  var colMarket = 2; // C列
  var colManu = 7; // H列
  var colPart = 8; // I列
  var colPurchase = 15; // P列
  var colHandling = 17; // R列
  var colOption = 18; // S列

  var sheetName = sheet.getName();
  var isMatome = sheetName.indexOf('まとめ専用') >= 0;

  // スキップカウントと最大スキップ行数を設定
  var skipCount = 0;
  var maxSkip = 50; // 無効行が50行連続したらループ終了

  // 日本語メーカー名と英語メーカー名の対応マップ
  const manufacturerNameMap = {
    トヨタ: 'toyota',
    ホンダ: 'honda',
    日産: 'nissan',
    三菱: 'mitsubishi',
    スバル: 'subaru',
    マツダ: 'mazda',
    スズキ: 'suzuki',
    レクサス: 'lexus',
    ダイハツ: 'daihatsu',
    いすゞ: 'isuzu',
    ヤマハ: 'yamaha',
  };

  for (var i = 1; i < data.length; i++) {
    var row = data[i];
    var orderNumber = (row[colOrderNum] || '').toString().trim();
    if (!orderNumberPattern.test(orderNumber)) {
      // 無効行の場合
      skipCount++;
      if (skipCount > maxSkip) {
        // 一定数以上無効行が続いたため終了
        break;
      }
      continue;
    }
    // 有効行の場合はスキップカウントリセット
    skipCount = 0;

    var manufacturerName = (row[colManu] || '').toString().trim();
    var purchaseValue = (row[colPurchase] || '').toString().trim();
    var handling_fee = parseNumericOrZero(row[colHandling]);
    // 変数名を photo_fee から option_fee に変更
    var option_fee = parseNumericOrZero(row[colOption]);
    var market = (row[colMarket] || '').toString().trim();

    var purchase_price = 0;
    if (purchaseValue === '在庫') {
      var partStr = (row[colPart] || '').toString();
      var parts = extractAndCleanPartNumbers(partStr);
      if (parts.length > 0) {
        var foundPrice = searchPriceByPartNumber(ss, parts[0]);
        if (foundPrice === null) {
          continue;
        } else {
          purchase_price = foundPrice;
        }
      } else {
        continue;
      }
    } else {
      purchase_price = parseNumericOrZero(purchaseValue);
    }

    if (market === 'その他' && isMatome) {
      handling_fee += 1000;
    }

    // メーカー名を英語に変換 (対応マップに存在しない場合は元の日本語のまま)
    var englishManufacturerName =
      manufacturerNameMap[manufacturerName] || manufacturerName;

    // CSVに出力する配列の要素を変更
    result.push([
      orderNumber,
      englishManufacturerName,
      purchase_price,
      handling_fee,
      option_fee,
    ]);
  }

  var csv = result
    .map(function (r) {
      return r.map(csvEscape).join(',');
    })
    .join('\r\n');

  return { csv: csv, sheetName: sheetName };
}

/**
 * 文字列を数値に変換し、数値でない場合は0を返します。
 * @param {string|number} value 変換する値
 * @return {number} 変換された数値、または0
 */
function parseNumericOrZero(value) {
  var v = (value || '').toString().trim().replace(/[¥,]/g, '');
  if (v === '') return 0;
  var num = Number(v);
  if (isNaN(num)) {
    return 0;
  }
  return num;
}

/**
 * CSV形式でエスケープが必要な文字をエスケープします。
 * @param {string} str エスケープする文字列
 * @return {string} エスケープされた文字列
 */
function csvEscape(str) {
  str = (str || '').toString();
  if (str.indexOf(',') >= 0 || str.indexOf('"') >= 0) {
    str = '"' + str.replace(/\"/g, '""') + '"';
  }
  return str;
}

/**
 * 指定された品番に対応する価格をスプレッドシート全体から検索します。
 * @param {Spreadsheet} ss 検索対象のスプレッドシート
 * @param {string} partNumber 検索する品番
 * @return {number|null} 見つかった価格、またはnull
 */
function searchPriceByPartNumber(ss, partNumber) {
  var sheets = ss.getSheets();
  for (var s = 0; s < sheets.length; s++) {
    var sheet = sheets[s];
    var data = sheet.getDataRange().getValues();
    var colPart = 8; // I列
    var colPurchase = 15; // P列
    for (var i = 1; i < data.length; i++) {
      var row = data[i];
      var rowParts = extractAndCleanPartNumbers(
        (row[colPart] || '').toString()
      );
      if (rowParts.indexOf(partNumber) >= 0) {
        var pVal = parseNumericOrZero(row[colPurchase]);
        if (pVal > 0) {
          return pVal;
        }
      }
    }
  }
  return null;
}

/**
 * テキストから品番を抽出し、クリーンアップします。
 * @param {string} text 品番を含むテキスト
 * @return {string[]} クリーンアップされた品番の配列
 */
function extractAndCleanPartNumbers(text) {
  var parts = [];
  var lines = text.toString().split(/\r?\n/);
  for (var i = 0; i < lines.length; i++) {
    var line = lines[i].trim();
    if (!line) continue;
    line = line.replace(/^"(.*)"$/, '$1');

    var tokens = line.split(/\s+/);
    for (var j = 0; j < tokens.length; j++) {
      var token = tokens[j].trim();
      if (!token) continue;
      var cleaned = cleanPartNumber(token);
      if (cleaned) {
        parts.push(cleaned);
      }
    }
  }
  return parts;
}

/**
 * 品番をクリーンアップします（不要な文字を削除し、有効な形式かチェックします）。
 * @param {string} str クリーンアップする品番
 * @return {string} クリーンアップされた品番、または空文字列
 */
function cleanPartNumber(str) {
  str = str.replace(/^[\s　]+|[\s　]+$/g, '');
  if (!str) return '';

  str = str.replace(/[\(\（][^\)\）]*[\)\）]/g, '');
  str = str.replace(/在庫/g, '');
  str = str.replace(/→.*$/, '');
  str = str.replace(/\d+[個]/g, '');
  str = str.replace(/[０-９]+個/g, '');

  str = str.trim();

  var partNumberPattern = /^[A-Za-z0-9\-]+$/;
  if (!partNumberPattern.test(str)) {
    return '';
  }
  return str;
}

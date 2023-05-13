class latestStockData {
  final String symbol;
  //final DateTime timestamp;
  final double price;
  final double open;
  final double high;
  final double low;
  final double close;
  final double change;
  final int volume;
  final String displayName;

  latestStockData({
    required this.symbol,
    //required this.timestamp,
    required this.price,
    required this.open,
    required this.high,
    required this.low,
    required this.close,
    required this.change,
    required this.volume,
    this.displayName = "Boi not getting",
  });

  factory latestStockData.fromJson(Map<String, dynamic> json) {
    print(json['displayName']);
    return latestStockData(
      symbol: json['symbol'],
      // timestamp: DateTime.parse(latestEntryPrices['timestamp']),
      price: json['regularMarketPrice'],
      open: json['regularMarketOpen'],
      high: json['regularMarketDayHigh'],
      low: json['regularMarketDayLow'],
      close: json['regularMarketPreviousClose'],
      change: json['regularMarketChange'],
      volume: json['regularMarketVolume'],
      displayName:
          json['displayName'] == null ? 'no Name' : json['displayName'],
    );
  }
}

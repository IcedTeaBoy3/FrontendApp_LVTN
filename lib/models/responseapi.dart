class ResponseApi<T> {
  final String status;
  final String message;
  final int? statusCode;
  final T? data;

  ResponseApi({
    required this.message,
    required this.status,
    this.statusCode,
    this.data,
  });

  factory ResponseApi.fromJson(
    Map<String, dynamic> json, {
    T Function(dynamic)? funtionParser,
  }) {
    T? parsedData;
    final rawData = json['data'];

    if (funtionParser != null && rawData != null) {
      parsedData = funtionParser(rawData);
    }

    return ResponseApi(
      message: json['message'] ?? '',
      status: json['status'] ?? '',
      statusCode: json['statusCode'] ?? 200,
      data: parsedData,
    );
  }

  Map<String, dynamic> toJson({
    dynamic Function(T)? dataSerializer,
  }) {
    return {
      'message': message,
      'status': status,
      'data': data != null
          ? (dataSerializer != null ? dataSerializer(data!) : data)
          : null,
      'statusCode': statusCode,
    };
  }
}

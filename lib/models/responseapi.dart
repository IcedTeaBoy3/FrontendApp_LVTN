class ResponseApi<T> {
  final String status;
  final String message;
  final int? statusCode;
  final T? data;
  ResponseApi(
      {required this.message,
      required this.status,
      this.statusCode,
      this.data});

  factory ResponseApi.fromJson(Map<String, dynamic> json,
      {T? Function(Map<String, dynamic>)? funtionParser}) {
    T? parserData;
    if (funtionParser != null && json['data'] is Map<String, dynamic>) {
      parserData = funtionParser(json['data'] as Map<String, dynamic>);
    }
    return ResponseApi(
      message: json['message'],
      status: json['status'],
      statusCode: json['statusCode'] ?? '',
      data: parserData,
    );
  }
  Map<String, dynamic> toJson(
      {Map<String, dynamic> Function(T)? dataSerializer}) {
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

class ApiResponse<T> {
  final T? data;
  final bool? error;
  final String? erorMessage;

  ApiResponse({this.data, this.error = false, this.erorMessage});
}

class RequestResult {
  /// IMPORTANT
  // needs to stay consistent with firestore as well as cloud functions
  // do not edit without ensuring consistent
  // also used by a lot of services, but dart analysis should keep that in line

  // properties
  late bool error;
  late dynamic data;

  RequestResult(this.error, this.data);

  // initialize from map (used for returns from cloud functions)
  RequestResult.fromMap(Map<String, dynamic> map) {
    this.error = map['error'];
    this.data = map['data'];
  }
}

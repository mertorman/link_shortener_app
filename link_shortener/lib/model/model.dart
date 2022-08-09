class Model {
  String? resultUrl;

  Model({this.resultUrl});

  Model.fromJson(Map<String, dynamic> json) {
    resultUrl = json['result_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['url'] = this.resultUrl;
    return data;
  }
}
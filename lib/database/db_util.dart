String optString(Map data, dynamic key) {
  return data[key] ?? "";
}

List<T> optList<T>(Map data, dynamic key) {
  final resp = data[key];
  if (data[key] == null || resp.isEmpty) return [];

  return List<T>.from(resp); //List<dynamic> can't be transformed to List<String> even if the content is litteral Strings... trash
}

double optDouble(Map data, dynamic key) {
  return data[key] ?? 0.0;
}

Map optMap(Map data, dynamic key) {
  return data[key] ?? {};
}

Map optDeepMap(Map data, List<dynamic> keys) {
  for (var i = 0; i < keys.length - 1; i++) {
    if (!data.containsKey(keys[i])) return {};
    data = data[keys[i]];
  }
  return data[keys.last];
}
